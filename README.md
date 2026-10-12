# Document Site

Skills that document a repo once, from evidence, and keep the docs true as the code changes. Built for legacy repos whose authors are often gone: the skills interview the code first and the architect last, and every claim carries a tier of Direct, Supported, Inferred, or Unknown.

[![skills.sh](https://skills.sh/b/tomfarina/document-site)](https://skills.sh/tomfarina/document-site)

Four skills, two hooks, one pull request check, and the templates the skills write from. After install, the repo carries a short `CLAUDE.md`, a site profile, one feature file per user-facing area, and a few notes. On every pull request a gate script checks whether a changed path is one the docs cover. Only then does one read-only model call decide whether a sentence in those docs became false, and the workflow posts the fix as a suggestion the author applies with one click. Nothing runs on a schedule.

## Install into a repo

Everything installs into one repo and works only there. The skills read that repo's site profile and docs, the hooks live in its `.claude/settings.json`, and the check runs on its pull requests. Run every step from the root of the repo you want documented, and do not pass `-g`.

You need Claude Code, Node for `npx`, and Git Bash on PATH on Windows. The hooks and the gate script are bash and need no other runtime.

### 1. Get the skills

```bash
npx skills add tomfarina/document-site --copy -y
```

This writes `.claude/skills/<name>/` for each skill and a `skills-lock.json` at the repo root. Commit the lock file. Pass `--copy` so the repo holds real files rather than links, which the workflow needs when it checks out `.claude` from the base branch.

### 2. Install the hooks and the PR check

Open a Claude Code session in the same repo and paste the text of [install-prompt.md](install-prompt.md).

It downloads this repo, copies every kit file the repo does not have, and merges the two hooks into an existing `.claude/settings.json`. It asks before it replaces any file that differs. It writes `.claude/sites/<key>.md` with the key, repo, client, and stack it can read from the repo, and tells you what it chose. It commits nothing. If you skipped step 1, it copies the skills too.

### 3. Wire up GitHub

The repo needs every change to go through a pull request.

```bash
gh secret set ANTHROPIC_API_KEY
```

Optionally, create the label authors can apply to skip the docs check on a pull request. Without it the check still runs; the label only exists to dismiss it.

```bash
gh label create docs-not-needed
```

In the repo's Actions settings, allow GitHub Actions to create pull requests. The workflow needs this for the side PR it opens when the doc to fix is not in the author's diff. Then review and commit what the install changed.

### 4. Document the repo

```text
/document-site
```

It opens one draft PR confined to `docs/`, `.claude/`, `CLAUDE.md`, and `AGENTS.md`, and writes the questions it could not answer from the code to `docs/open-questions.md`. Answer those a few at a time with `/docs-answer`, then merge the PR. From then on the docs check runs on every pull request.

## Skills

### document-site

Documents the repo. Sends read-only explorer subagents through the code, the tool-owned paths, the configuration, and the build. From what they find it writes the site profile, one feature file per user-facing area, the notes that pass the bar, `CLAUDE.md`, and `AGENTS.md`. Where the app can run, it writes a `verify-<key>` skill and runs it once against the read-only endpoints in the profile. An Unknown records what was searched and tells agents to preserve the code as-is. The architect gets only the questions the code and history could not answer. It never edits product code or tool-owned paths, apart from the opt-in comment harvest.

**Use when:**

- A repo has no `.claude/sites/<key>.md`, or its profile is mostly `unknown`
- One new area needs a feature file
- `/document-site with-comments`, only when the architect opts in. Adds the comment harvest, which edits product code in its own commit

The [references](skills/document-site/references) folder holds what it reads: the explorer brief, the git history brief, where each profile field comes from, the layout of the open questions file, the shape of the verify skill, and the rules for the comment pass.

### docs-answer

Takes `<n>: <text>`, finds question `n` in `docs/open-questions.md`, and writes the answer where the next agent will find it: the site profile, a feature file's Gotchas, or a new note. The answer lands as a Direct claim with its source and date. "I don't know" becomes an Unknown entry. It then removes the question.

**Use when:**

- The architect has an answer to an open question

```text
/docs-answer 3: We moved to Solr in 2021 because Lucene could not handle the provider index.
```

### docs-check

The judgment half of the PR check. Reads the diff and the docs the gate found, and says yes for only three reasons. A listed path moved, a sentence states something the code no longer does, or the change adds a trap the next agent would fall into. Returns JSON with exact replacement lines and never writes a file. The workflow runs it on every PR where the gate fired. One call, Sonnet, capped at 1.50 USD.

**Use when:**

- You want the PR verdict before pushing: `/docs-check <base-ref>`

### validate-docs

Gives a fresh subagent `CLAUDE.md`, the index, and one small real task. Compares the path the subagent took with the real one and scores each difference as wrong way, lag, or gap. Fixes every wrong-way item in the same session and logs the rest. This is the only test of whether the docs still work; the PR check only tests whether a change broke them.

**Use when:**

- Right after `/document-site`
- Quarterly, or whenever the PR check seems to be letting things through
- `/validate-docs <task>`, or no task to pick one from the feature map

## What else the kit installs

The install prompt copies [kit/](kit) into the repo. None of it calls a model.

| When | What runs |
|---|---|
| Session start | `.claude/hooks/inject-docs-index.sh` prints `docs/index.md` into context with one line telling the agent to read the site profile first, and a feature file before changing code under a path it lists |
| Any Edit, Write, or MultiEdit | `.claude/hooks/auto-index-docs.sh` rebuilds `docs/index.md` from the files under `docs/` when a doc was added or removed. Nobody edits the index by hand |
| Every PR | `scripts/docs-gate.sh` lists the docs that cover the changed paths. A feature file covers a path under its `## Files` heading, a note covers a path in its `trigger:` line, the site profile covers its `## Gating files`. Prints nothing when no doc covers a change |
| Every PR where the gate fired | `.github/workflows/docs-check.yml` runs `docs-check`, then posts a review suggestion for a doc in the diff, or a side PR into the author's branch for a doc outside it. Never blocks a merge. The `docs-not-needed` label skips it |

- `.claude/settings.json` wires the two hooks.
- `.claude/sites/_template.md` is the template for the site profile, the file agents read before any other. It holds identity, fences, tool-owned paths, runtime versions, build and test commands, the evidence ceiling, the gating files, and the places that look like the fix location but are not. Keep it under 16 KB.
- `scripts/docs-check.schema.json` is the shape of the judgment's output: a `needs_update` flag, a reason, up to eight line-range suggestions, and up to three new files.
- `docs/_templates/` holds the root instruction files, under forty lines each, the feature file with its five fixed headings, and the note with `trigger`, `confidence`, and `source` front matter. The feature file's Files list is what the gate reads.
- `docs/features/README.md` explains the feature map. `docs/notes/README.md` states the bar for a note: an agent would reliably get the topic wrong without it.

Run `bash scripts/docs-gate.sh <base-ref>` any time to see which docs cover your changes.

## Updating

```bash
npx skills update
```

Then paste [install-prompt.md](install-prompt.md) again. It only touches files that are missing or unchanged.

## Making the check required

Start with the check optional. After a couple of months, count dismissed suggestions against applied ones. If fewer than about one in ten were dismissed, make the check required in branch protection and keep the label as the way out. If more were dismissed, tighten the three reasons in `.claude/skills/docs-check/SKILL.md` first.

## Known gaps

- The gate script was smoke-tested on Git Bash on 2026-10-12. The skills and the workflow have not yet run against a real repo.
- `docs/features/README.md` mentions a `how` skill that explains a subsystem on demand. The kit does not include it.
- The workflow pins Claude Code 2.1.296 and the model `claude-sonnet-5-5`. Update both when you update the kit.

## Removing it

```bash
npx skills remove tomfarina/document-site --all
```

Then delete `.claude/hooks`, `.github/workflows/docs-check.yml`, and `scripts/`, and remove the `hooks` block from `.claude/settings.json`. The docs keep working without any of it.
