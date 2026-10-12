# Comment harvest

Opt-in. Edits product code across the repo, so it runs only when the architect invokes `/document-site with-comments` and lands as its own commit inside the docs PR, or as its own PR on client repos where a sweeping change will be contested.

Classify every existing comment:

| Kind | Test | What happens |
|---|---|---|
| What-comment | Describes what the next lines do. The code already says it. | Delete |
| Why-comment, local | Explains a constraint or workaround that applies to these lines only | Keep, cut to one line |
| Why-comment, subsystem | Explains how a subsystem works or why it is shaped this way | If an agent would reliably get it wrong without it: a Gotchas bullet in the owning feature file, or a note with a trigger line when it cuts across areas, with a `file:line` pointer; replace with one line naming the doc. Otherwise cut to one line |
| Claimed constraint | "Must", "never", "always", "do not" | Keep the one line; add a rule-table row with a proposed enforcer (lint, test, project reference check) |
| Commented-out code | Dead code | Delete; history has it |
| TODO or FIXME | Work owed | Move to `docs/open-questions.md` under "Owed" with the path; delete the comment |

Rules:

- One commit, message `chore(<key>): move comments to docs`. No other changes in it.
- Do not touch generated files, vendored code, or tool-owned paths.
- Do not reword code. Only comments move.
- Where a claimed constraint has no obvious enforcer, the rule-table row says "enforcer: none yet." That is a result, not a failure.
