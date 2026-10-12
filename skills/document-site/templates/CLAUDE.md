# <repo name>

<One sentence: what this repo is. Stack, major versions, what it serves.>

Read `.claude/site.md` before anything. Before changing code under a path a feature file lists, read that file. The index is `docs/index.md`. A note under `docs/notes/` with a trigger line applies when you touch what it names.

## Must read first

- `docs/features/<area>.md` before touching `<path/to/area>/`
- `docs/notes/<the one that bites most>.md`

## Commands

- Build: `<from the profile's Verification section>`
- Test: `<...>`
- Lint: `<...>`
- Sync tool-owned paths (architect only): `<...>`

## Rules

| Rule | Enforcer |
|---|---|
| <Layering rule. On Helix: Foundation never references Feature; Feature never references Feature> | none yet |
| Agents never edit files under <tool-owned paths> | hook |
| <rule from the architect> | none yet |

Keep this file under forty lines. Anything longer belongs in a feature file or a note.
