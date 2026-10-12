---
name: docs-answer
description: >-
  Write one architect answer from docs/open-questions.md back into the doc it belongs to.
  Invoked as `/docs-answer <n>: <text>`. The answer lands in a feature file's Gotchas, a note,
  or the site profile, as a Direct claim with its source and date. "I don't know" becomes an
  Unknown entry with preserve-as-is. Removes the question from the queue.
---

**Write one answer where the next agent will find it. Nothing else changes.**

Arguments: `<n>: <text>`.

1. Find question `[n]` in `docs/open-questions.md`. If absent, reply `No open question n.` and stop.
2. Decide the home, in this order:
   - A fact about the site (version, root, command, endpoint): the matching line in `.claude/site.md`.
   - A trap or a why that belongs to one user-facing area: one bullet under `## Gotchas` in that feature file, with `(Direct, architect, <today>)`.
   - A trap or a why that cuts across areas, or a fence with no feature: a note in `docs/notes/` from `.claude/skills/document-site/templates/note.md`, with a `trigger:` line naming the paths it applies to. Apply the bar first: would an agent reliably get this wrong without it? If not, the Gotchas bullet is enough.
3. "I don't know" or equivalent becomes an Unknown entry: what was searched, nothing found, preserve as-is, do not describe as intentional.
4. If the answer explains a workaround or names a fence, add a row to the rule table in `CLAUDE.md` with `enforcer: none yet`.
5. If the answer corrects a proposed value under "Confirm," apply it to the profile.
6. Remove the question from `docs/open-questions.md`. Renumber nothing.
7. Reply with the file written and the one line that was added.

Never edit product code, tool-owned paths, or `docs/index.md`.
