# Feature map

One file per user-facing area, from `docs/_templates/feature-page.md`. Every file has the same five sections: Sub-features, How to get to it, Driving it, Files, Gotchas. Entries are behavior-level and short enough to act on without reading source. A file splits when a section starts needing its own preconditions.

This is the one doc tree. There are no architecture pages. A cross-cutting fact that an agent would get wrong is a note under `docs/notes/`. There is no page that explains a subsystem; the code and its history say that.

## Baseline preconditions

- <What must be true before any feature can be checked: a running app, a read-only endpoint, a logged-in user. Where nothing runs: every check is a static trace.>

## Sweep order

Top to bottom is the regression order for a full pass and the order `validate-docs` picks tasks from.

1. <feature>
2. <feature>
