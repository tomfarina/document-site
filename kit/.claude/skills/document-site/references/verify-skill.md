# The verify skill for a head

Heads only. Written by `document-site` step 4 for JSS and XM Cloud repos, following poteto's `create-verification-skill`: it interviews the repo, writes the skill, and proves it once end to end before handoff. "A generated skill that was never executed is a draft, not a deliverable." XP sites get no verify skill; their feature files carry the static trace instead.

Lives at `.claude/skills/verify-<key>/SKILL.md` with five sections.

## Launch

How to start the head against the read-only preview or Edge endpoint. The exact command, the env vars by name (never by value), the port, how long it takes, what "up" looks like.

## Doctor

The checks that tell you the environment is sane before driving anything: the endpoint answers, the API key secret is present, the component registry loads, `npm run build` passes. Each with its command and its expected output.

## Drive

How to reach each feature in the map and what to assert. One entry per feature file, in sweep order, referencing the feature file's "Driving it" section. Prefer a scripted check over a manual one; a Playwright script in `scripts/verify/` is the usual shape.

## Evidence

What a passing run produces and where it lands: screenshots at the widths the feature file names, the test output, the build log. The PR body's Verification section quotes from here.

## Cleanup

How to stop the head and remove anything the run created.

Rules:

- Prove it once. Run every section before the bootstrap PR opens and record the result in the PR body. A section that could not run is written as `could not run: <reason>`, not left blank.
- The skill reads the site profile for the endpoint and the secret name. Never hardcode either.
- Nothing in it writes to Sitecore. The endpoint is read-only by design.
