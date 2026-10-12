#!/usr/bin/env bash
set -euo pipefail

root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
index="$root/docs/index.md"

[ -f "$index" ] || exit 0

echo "Repo docs index (docs/index.md). Read .claude/site.md first. Before changing code under a path a feature file lists, read that file. Notes with a trigger line apply when you touch what the trigger names."
echo
cat "$index"
