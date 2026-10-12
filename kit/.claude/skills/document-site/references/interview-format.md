# Interview format for docs/open-questions.md

The architect answers asynchronously, a few at a time, through `/docs-answer <n>: <text>`. The file is the queue. Every question carries a number that never changes, concrete options, and the agent's bet, so a ten-minute pass still leaves the site better documented.

```markdown
# Open questions

Answer with `/docs-answer <n>: <text>`. Answered questions are removed by that command and written into the feature file, note, or profile they belong to with "source: architect, <date>."

## Confirm

Proposed values the bootstrap is not sure of. Reply "ok" or the correction.

- [1] Sitecore version: 9.3.0 (Supported: Sitecore.Kernel 13.0.0 in packages.config)
- [2] Serialization: Unicorn, roots under src/Foundation/Serialization and src/Feature/*/serialization (Direct)

## Search

- [3] `ProviderIndexRebuildProcessor` swallows exceptions and logs at Info. Why?
  Options: (a) a 2019 outage where a bad record stopped the whole rebuild; (b) left over from debugging; (c) something else.
  Bet: (a), Inferred from the commit message "stop rebuild dying on one bad provider."
  If nobody knows: record Unknown, preserve as-is.

## Rendering

- [4] ...

## Validated

Log lines written by `/validate-docs`: date, task, wrong-way, lag, gap counts.
```

Rules:

- Four to six questions per group. More than that waits for the next round.
- Never a blank "tell me about the site." Every question names the file, the symptom, and the plausible answers.
- The bet is required. It is what the architect corrects, which is faster than composing.
- "I don't know" is a valid answer. It becomes an Unknown entry with what was searched and "preserve as-is."
- An answer that explains a workaround also produces a rule-table row with "enforcer: none yet."
