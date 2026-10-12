---
name: docs-check
description: The judgment half of the PR docs check. Given the docs the gate script found covering changed paths, reads the diff and those docs and decides whether any sentence became false, any listed path moved, or a new trap appeared. Returns a small JSON object with exact replacement text. Read-only. Run by the docs-check workflow, or by hand before pushing as `/docs-check <base-ref>`.
---

**Decide whether this change makes the docs wrong. Propose the smallest edit that makes them right. Say no when nothing is wrong.**

Argument: the base ref to diff against. The gate's output is in `.docs-check-affected` when run by the workflow; when run by hand, run `bash scripts/docs-gate.sh <base-ref>` first and use its output.

## The only three reasons to say yes

1. A path listed under `## Files` in a feature file, or in a note's `trigger:` line, was moved, renamed, added to, or removed by this change.
2. A sentence in an affected doc states something the code no longer does. Quote the sentence and the `file:line` that contradicts it.
3. The change introduces a trap the next agent would reliably fall into without a line in Gotchas or a note: a non-obvious ordering, a fence, a surface that looks like the fix location but is not.

Everything else is no. A change that leaves the mechanism as described is no even though a listed path changed. "Could mention" is no. Describing what the new code does is no; the code says that.

## Procedure

1. Read `.docs-check-affected` or the gate output. Each line is a doc and the changed files it covers.
2. `git diff <base-ref>...HEAD -- <those files>`. Read the hunks, not the file names.
3. Read each affected doc in full.
4. For each doc, test the three reasons above against the diff. Collect `file:line` evidence for every yes.
5. For each yes, write the smallest replacement: the exact lines to replace and the exact new text, keeping the doc's headings and shape. A new trap goes into the feature file's `## Gotchas` as one bullet with the tier and the evidence, or into a new note only when it applies across features. Never propose more than eight suggestions or three new files; if the change needs more, say so in `reason` and propose the most important.
6. Return the JSON object in `scripts/docs-check.schema.json`. `reason` is one or two sentences a reviewer reads first. For `needs_update: false`, `reason` says what was checked and why it still holds.

## Rules

- Read-only. Never edit, never write, never push. The workflow delivers your output as suggestions.
- Line numbers refer to the doc as it is on this branch now.
- Quote evidence. "The code changed" is not evidence; `src/Feature/Search/Index.cs:41` is.
- Prefer deleting a sentence that is now false over adding a paragraph that is now true.
- The site profile is a doc too. A changed serialization root, build command, or package version is reason 2 against `.claude/sites/<key>.md`.
