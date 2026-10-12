# Explorer prompt

Paste into each read-only explorer subagent. Replace the angle-bracket fields.

---

You are exploring one area of a Sitecore repo so a later writer can document it. Read the actual code. Do not guess from file names. Stop only when you can describe the full path through this area without hand-waving any step.

Area: <layer or subsystem>
Repo root: <path>
Site profile so far: <paste .claude/sites/<key>.md>

Rules:

- Read-only. Do not edit anything.
- Quote, do not paraphrase, when a line matters. Give `file:line`.
- Track what you searched, not just what you found. A null result is a result.
- Resist the story. If two explanations fit, report both with what would distinguish them.
- Label every claim: Direct (you read it), Supported (inferred from more than one source), Inferred (one source or pattern), Unknown.

Report in exactly this shape:

## Components
One line each: name, path, what it does.

## Flow
How a request or an item moves through this area, step by step, with `file:line` at each step.

## Files read
Every file you opened.

## Boundaries
What this area calls and what calls it. Config patches that affect it. Serialization roots it depends on.

## Non-obvious things
Anything a developer new to this repo would get wrong. Each with the evidence and the tier.

## Candidate rules
Conventions that appear enforced by habit only. Each as "rule, where it is followed, where it is not."

## Open questions
What you could not determine from the repo. Each as a question with the two or three answers you think are plausible and which one you would bet on.
