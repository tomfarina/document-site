# <Feature, as a user would name it>

## Sub-features

- One per line, behavior-level.

## How to get to it (user POV)

Where a visitor or an editor finds it. The URL pattern, the menu path, the admin screen.

## Driving it

Where the app runs: the page to open against the read-only endpoint, the data it needs, the check that proves it works, and the `verify-<key>` section that drives it.

Where it does not: the static trace. The entry point, the files it passes through, and the evidence ceiling. "Static trace through `<entry point>` and `<view>`; no runnable environment" is a valid entry.

## Files

The paths this feature's code lives in. This list is the contract the PR docs check reads. Globs allowed.

- `<path/to/area>/`
- `<path/to/views>/<area>/`

## Gotchas

- One per line, with the tier and the evidence. `(Supported, commit a1b2c3)` or `(Direct, architect, 2026-10-12)`.
