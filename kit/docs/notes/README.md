# Notes

One topic per file, under fifty lines, from `docs/_templates/note.md`. The index is generated; never edit it.

The bar for a note: high-signal (an agent would reliably get this wrong without it), high-frequency, or high-impact. The durability test before writing: would this belong in a prompt for a different task on this repo? If it belongs to one user-facing area, it is a Gotchas bullet in that feature file, not a note.

A note with a `trigger:` line applies only when the named paths are in play. The docs check uses the trigger the same way it uses a feature file's `## Files` list.

A note the architect has stated twice becomes a rule in `CLAUDE.md` with an enforcer, and the note then points at the enforcer.
