#!/usr/bin/env bash
# The deterministic gate of the PR docs check. No model.
#
# For every file changed between base and head, find the docs that cover it:
#   - a feature file whose "## Files" list matches the path
#   - a note whose "trigger:" front matter lists a matching path
#   - the site profile, when the path matches its "## Gating files" list
#
# Prints one line per affected doc: "<doc>\t<changed file> <changed file> ...".
# Prints nothing when no doc covers any changed path. Exit 0 always.
#
# Usage: scripts/docs-gate.sh <base-ref> [head-ref]
set -euo pipefail

base="${1:?base ref}"
head="${2:-HEAD}"

changed=$(git diff --name-only "$base...$head" | grep -vE '^(docs/|\.claude/|CLAUDE\.md|AGENTS\.md)' || true)
[ -n "$changed" ] || exit 0

# (doc, pattern) pairs from feature files and triggered notes.
pairs=$(
  for f in $(find docs/features -name '*.md' 2>/dev/null | grep -v README.md); do
    awk -v doc="$f" '
      /^## /{ in_list = ($0 ~ /^## Files/); next }
      in_list && /^- / { line=$0; sub(/^- +/,"",line); gsub(/`/,"",line); split(line,p," "); if (p[1]!="") print doc "\t" p[1] }
    ' "$f"
  done
  for f in $(find docs/notes -name '*.md' 2>/dev/null | grep -v README.md); do
    awk -v doc="$f" '
      NR==1 && $0!="---" { exit }
      NR>1 && /^---/ { exit }
      /^trigger:/ {
        line=$0; sub(/^trigger: */,"",line); gsub(/[`"]/,"",line)
        n=split(line,p,/[ ,]+/); for (i=1;i<=n;i++) if (p[i] ~ /\//) print doc "\t" p[i]
      }
    ' "$f"
  done
  for prof in $(find .claude/sites -maxdepth 1 -name '*.md' -not -name '_template.md' 2>/dev/null); do
    awk -v doc="$prof" '
      /^## /{ in_list = ($0 ~ /^## Gating files/); next }
      in_list && /^- / { line=$0; sub(/^- +/,"",line); gsub(/`/,"",line); split(line,p," "); if (p[1]!="" && p[1]!="unknown") print doc "\t" p[1] }
    ' "$prof"
  done
)
[ -n "$pairs" ] || exit 0

shopt -s extglob globstar nullglob
declare -A hit

while IFS=$'\t' read -r doc pattern; do
  [ -n "$pattern" ] || continue
  pattern="${pattern%/}"
  for file in $changed; do
    base_name="${file##*/}"
    # shellcheck disable=SC2254
    case "$file" in
      $pattern|$pattern/*|*/$pattern|*/$pattern/*) ;;
      *) case "$base_name" in $pattern) ;; *) continue ;; esac ;;
    esac
    hit["$doc"]+="$file "
  done
done <<< "$pairs"

for doc in "${!hit[@]}"; do
  printf '%s\t%s\n' "$doc" "${hit[$doc]% }"
done | sort
