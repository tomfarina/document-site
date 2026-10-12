# The verify skill

Written by `document-site` step 4 only when the profile's evidence ceiling is `app runs`, following poteto's `create-verification-skill`: it interviews the repo, writes the skill, and proves it once end to end before handoff. "A generated skill that was never executed is a draft, not a deliverable." A repo that cannot run gets no verify skill; its feature files carry the static trace instead.

Lives at `.claude/skills/verify-<key>/SKILL.md` with five sections.

## Launch

How to start the app against the read-only endpoints in the profile. The exact command, the env vars by name (never by value), the port, how long it takes, what "up" looks like.

## Doctor

The checks that tell you the environment is sane before driving anything: the endpoint answers, the secrets are present, the build passes. Each with its command and its expected output.

## Drive

How to reach each feature in the map and what to assert. One entry per feature file, in sweep order, referencing the feature file's "Driving it" section. Prefer a scripted check over a manual one; a Playwright script in `scripts/verify/` is the usual shape for a web app.

## Evidence

What a passing run produces and where it lands: screenshots at the widths the feature file names, the test output, the build log. The PR body's Verification section quotes from here.

## Cleanup

How to stop the app and remove anything the run created.

Rules:

- Prove it once. Run every section before the bootstrap PR opens and record the result in the PR body. A section that could not run is written as `could not run: <reason>`, not left blank.
- The skill reads the site profile for the endpoints and the secret names. Never hardcode either.
- Nothing in it writes to a shared backend. The endpoints are read-only by design.
