# <Feature, as a user would name it>

## Sub-features

- One per line, behavior-level.

## How to get to it (user POV)

Where a visitor or an editor finds it. The URL pattern, the Content Editor path, the Pages route.

## Driving it

Heads (JSS, XM Cloud): the page to open against the preview endpoint, the data it needs, the check that proves it works, and the `verify-<key>` section that drives it.

XP: the static trace. The rendering, the template, the serialized item path, and the evidence ceiling. "Static trace through `<rendering>` and `<serialized template>`; no runnable environment" is a valid entry.

## Files

The paths this feature's code lives in. This list is the contract the PR docs check reads. Globs allowed.

- `src/Feature/<Area>/`
- `src/Project/<Site>/Views/<Area>/`

## Gotchas

- One per line, with the tier and the evidence. `(Supported, commit a1b2c3)` or `(Direct, architect, 2026-10-12)`.
