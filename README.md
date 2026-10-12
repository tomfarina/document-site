# Agent-friendly repo kit

The `kit/` folder holds files you copy into a repo so that agents can find their way around it and the docs stay correct as the code changes. The kit has four skills, two hooks, one pull request check, and the templates the skills write from.

After install, the repo carries a short `CLAUDE.md`, a site profile, one feature file per user-facing area, and a few notes. Two scripts keep `docs/index.md` current. On every pull request a gate script checks whether a changed path is one the docs cover. Only when it is does one read-only model call decide whether a sentence in those docs became false, and the workflow posts the fix as a suggestion the author applies with one click. Nothing runs on a schedule.

The gate script was smoke-tested on Git Bash on 2026-10-12. The skills and the workflow have not yet run against a real repo.

## What you need

- Claude Code, with Git Bash on PATH on Windows. The hooks and the gate script are bash and need no other runtime.
- A GitHub repo where every change goes through a pull request.
- An Anthropic API key to store as a repository secret.
- The `gh` CLI, if you want to create the secret and the label from a terminal.

## Install

1. Open a Claude Code session in the site repo and give it this prompt. Replace `<path-to-document-site>` with the path to your copy of this repo.

```text
Read <path-to-document-site>/install-prompt.md and follow it.
```

   It copies every kit file the repo does not have and merges the kit's two hooks into an existing `.claude/settings.json`. It asks before it replaces any file that differs from the kit's. It writes `.claude/sites/<key>.md` with the key, repo, client, and stack it can read from the repo, and tells you what it chose. It commits nothing. You can run it again after a kit update.

2. Store the API key for the workflow.

```bash
gh secret set ANTHROPIC_API_KEY
```

3. Create the label that dismisses the check.

```bash
gh label create docs-not-needed
```

4. In the repo's Actions settings, allow GitHub Actions to create pull requests. The workflow needs this for the side PR it opens when the doc to fix is not in the author's diff.

5. Review and commit what the install changed.

6. Document the repo. In a Claude Code session in the site repo, run:

```text
/document-site
```

   It opens one draft PR confined to `docs/`, `.claude/`, `CLAUDE.md`, and `AGENTS.md`, and writes the questions it could not answer from the code to `docs/open-questions.md`.

7. Answer the open questions a few at a time. Each answer names the question number.

```text
/docs-answer 3: We moved to Solr in 2021 because Lucene could not handle the provider index.
```

8. Merge that PR. From then on the docs check runs on every pull request.

### Installing by hand

On a repo with no `.claude/` or `docs/` folder, a plain copy does the same job as step 1. It overwrites any file that already exists, so use the prompt everywhere else.

```bash
cp -r <path-to-document-site>/kit/. .
cp .claude/sites/_template.md .claude/sites/<key>.md
```

Then fill in Key, Client, Repo, and Stack under Identity in the new profile and leave every other field as `unknown`.

## What to run, and when

| Command | When | What it does |
|---|---|---|
| `/document-site` | Once per repo, or later for one new area | Documents the repo and opens the docs PR |
| `/document-site with-comments` | Only when the architect opts in | Same, plus the comment harvest, which edits product code in its own commit |
| `/docs-answer <n>: <text>` | Whenever the architect has an answer | Writes the answer into the doc it belongs to and removes the question |
| `/docs-check <base-ref>` | Before pushing, if you want the PR verdict early | Runs the same judgment the workflow runs |
| `/validate-docs [task]` | After `/document-site`, then quarterly | Tests whether a fresh agent can do a real task from the docs alone |
| `bash scripts/docs-gate.sh <base-ref>` | Any time | Lists the docs that cover your changed files. No model. |

Everything else runs by itself.

| When | What runs | Model call |
|---|---|---|
| Session start | `inject-docs-index.sh` prints `docs/index.md` into context | No |
| Any Edit, Write, or MultiEdit | `auto-index-docs.sh` regenerates `docs/index.md` if a doc was added or removed | No |
| Every PR | `docs-gate.sh` finds the docs that cover the changed paths. If none do, the check passes with no comment | No |
| Every PR where the gate found docs | `docs-check` reads the diff and those docs | One call, Sonnet, capped at 1.50 USD |
| Every PR where the judgment says yes | The workflow posts suggestions, or a side PR for docs outside the diff | No |

## What each part does

### Hooks

`.claude/settings.json` wires two hooks. Neither calls a model.

- `.claude/hooks/inject-docs-index.sh` runs on SessionStart. It prints `docs/index.md` into the session with one instruction line that tells the agent to read the site profile first and to read a feature file before changing code under a path it lists. It prints nothing if the index does not exist.
- `.claude/hooks/auto-index-docs.sh` runs after every Edit, Write, or MultiEdit. It rebuilds `docs/index.md` from the files under `docs/`, skipping `_templates/`, and writes the file only when the result differs. Nobody edits the index by hand.

### Skills

- `.claude/skills/document-site/` documents the repo. You run it once. It sends read-only explorer subagents through the code, the tool-owned paths, the configuration, and the build. From what they find it writes the site profile, one feature file per user-facing area, and the notes that pass the bar. It also writes `CLAUDE.md` and `AGENTS.md`. Where the app can run, it writes a `verify-<key>` skill and runs it once against the read-only endpoints in the profile. Each claim carries a tier of Direct, Supported, Inferred, or Unknown. An Unknown records what was searched and tells agents to preserve the code as-is. The architect gets only the questions the code and history could not answer. The skill never edits product code or tool-owned paths, apart from the opt-in comment harvest.
- `.claude/skills/document-site/references/` holds the prompts and formats `/document-site` reads.
  - `explorer-prompt.md` is the brief for each explorer subagent.
  - `why-prompt.md` is the brief for the git history investigation.
  - `profile-fields.md` says where each profile field comes from.
  - `interview-format.md` is the layout of `docs/open-questions.md`.
  - `verify-skill.md` is the shape of the verify skill for a repo that runs.
  - `comment-harvest.md` has the rules for the opt-in comment pass.
- `.claude/skills/docs-check/` is the judgment half of the PR check. It reads the diff and the docs the gate found, and says yes for only three reasons. A listed path moved, a sentence states something the code no longer does, or the change adds a trap the next agent would fall into. It returns JSON with exact replacement lines and never writes a file.
- `.claude/skills/docs-answer/` takes `<n>: <text>`, finds question `n` in `docs/open-questions.md`, and writes the answer to the site profile, a feature file's Gotchas, or a new note. "I don't know" becomes an Unknown entry. It then removes the question.
- `.claude/skills/validate-docs/` gives a fresh subagent `CLAUDE.md`, the index, and one small real task. It compares the path the subagent took with the real one and scores each difference as wrong way, lag, or gap. It fixes every wrong-way item in the same session and logs the rest.

### Site profile

`.claude/sites/_template.md` is the template for `.claude/sites/<key>.md`, the file agents read before any other. It holds the site's identity, fences, tool-owned paths, runtime versions and top-level modules, build and test commands, the evidence ceiling, the gating files, and the places that look like the fix location but are not. Keep it under 16 KB.

### Pull request check

- `scripts/docs-gate.sh` is the gate. For each file changed between the base and the head it finds the docs that cover it. A feature file covers a path listed under its `## Files` heading. A note covers a path in its `trigger:` line. The site profile covers the paths listed under its `## Gating files` heading. It prints one line per affected doc and prints nothing when no doc covers a change. It ignores changes under `docs/` and `.claude/`.
- `scripts/docs-check.schema.json` is the shape of the judgment's output. It has a `needs_update` flag, a reason, up to eight line-range suggestions, and up to three new files.
- `.github/workflows/docs-check.yml` runs on every pull request from a branch in the same repo. It skips pull requests from forks. It runs the gate, then the judgment only if the gate printed something, then posts the result. A fix to a doc that is in the diff arrives as a review suggestion. A fix to a doc outside the diff arrives as a side PR into the author's branch. The check never blocks a merge. Adding the `docs-not-needed` label skips it and leaves the dismissal in the PR history.

### Docs folder

- `docs/index.md` is the generated index. It starts empty.
- `docs/features/README.md` explains the feature map and holds the baseline preconditions and the sweep order. `/document-site` fills in both.
- `docs/notes/README.md` states the bar for a note. A note earns a file only if an agent would reliably get the topic wrong without it.
- `docs/_templates/CLAUDE.md` and `docs/_templates/AGENTS.md` are the root instruction files, under forty lines each, with the must-read pointers, the commands, and the rule table.
- `docs/_templates/feature-page.md` is the feature file with its five fixed headings, which are Sub-features, How to get to it, Driving it, Files, and Gotchas. The Files list is what the gate reads.
- `docs/_templates/note.md` is the note, with `trigger`, `confidence`, and `source` front matter.

## Making the check required

Start with the check optional. After a couple of months, count dismissed suggestions against applied ones. If fewer than about one in ten were dismissed, make the check required in branch protection and keep the label as the way out. If more were dismissed, tighten the three reasons in `.claude/skills/docs-check/SKILL.md` first.

## Known gaps

- `docs/features/README.md` mentions a `how` skill that explains a subsystem on demand. The kit does not include it.
- The workflow pins Claude Code 2.1.296 and the model `claude-sonnet-5-5`. Update both when you update the kit.

## Removing it

Delete `.claude/hooks`, the four skill folders, `.github/workflows/docs-check.yml`, and `scripts/`, and remove the `hooks` block from `.claude/settings.json`. The docs keep working without any of it.
