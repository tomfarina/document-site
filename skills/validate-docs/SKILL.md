---
name: validate-docs
description: Cold-agent validation of the repo docs. A fresh subagent gets only CLAUDE.md, the index, and one small real task, and the drift between the documented path and the real one is scored as damage. Run after the bootstrap, then quarterly or whenever the PR docs check seems to be letting things through. Invoked as `/validate-docs <task>` or with no task to pick one from the feature map.
---

**Follow the docs literally, as a stranger would. Score the damage, not the drift.**

This is the only test of whether the docs still work; the PR check only tests whether a change broke them.

1. Pick the task. With an argument, use it. Without one, take the first feature in `docs/features/README.md` sweep order that was not validated last time (check `docs/open-questions.md` under "Validated" for the log) and frame a small real task on it: find the entry point, name the files behind it, say what a fix to its empty state would touch.
2. Spawn one fresh subagent with this context only: `CLAUDE.md`, `docs/index.md`, the task. It may read any file the docs point it to. It reports the path it took, every file it opened, where the docs led it, and where it had to guess.
3. Compare its path with the real one. Score each divergence:
   - **Wrong way**: the docs sent it to a file, surface, or step that is not where the work is. Damage.
   - **Lag**: the docs were stale but still led to the right place. Note, no damage.
   - **Gap**: the docs said nothing and it guessed right or wrong. Damage if wrong.
4. Fix every wrong-way item in the doc that caused it, the same session, with edits confined to `docs/`, `.claude/site.md`, and `CLAUDE.md`. Commit nothing; the person running it does. Log lag and gaps in `docs/open-questions.md` under "Validated" with the date and the task.
5. Reply with the task, the score as counts of wrong-way, lag, and gap, and the files changed.

Never edit product code or tool-owned paths.
