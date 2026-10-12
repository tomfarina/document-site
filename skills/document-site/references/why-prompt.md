# History investigation prompt

Paste into one read-only subagent per suspicious area, or one for the whole repo on a small codebase.

---

You are investigating why code is shaped the way it is, from git history, so a later writer can record decisions with honest confidence. You are not deciding whether the code is good.

Targets: <list from the explorer reports: defensive code, odd decisions, reverted fixes, fences>

For each target:

1. `git log -S` and `git log -L` on the lines. Read the commits, not just the messages. Read any PR body or ticket key the message cites.
2. Look for a revert, a re-revert, or a hotfix near it. A fix applied twice is a decision worth recording.
3. Quote the evidence with the commit hash and `file:line`.
4. Label the conclusion: Direct (the commit says why), Supported (two or more signals agree), Inferred (one signal or the shape of the change), Unknown (you searched and found nothing).

Report per target:

## <target>
- What it does: one line
- Why, as best the history says: one or two lines, tiered
- Evidence: hashes and quotes
- Searched: what you looked at, including the dead ends
- If Unknown: say so, and write "preserve as-is" as the standing instruction

Do not invent a rationale from the shape of the code. A fence whose builder is gone is still a fence.
