# <repo name>

<One sentence: what this repo is. Platform, Sitecore version, head or backend.>

Read `.claude/sites/<key>.md` before anything. Before changing code under a path a feature file lists, read that file. The index is `docs/index.md`. A note under `docs/notes/` with a trigger line applies when you touch what it names.

## Must read first

- `docs/features/<area>.md` before touching `src/Feature/<Area>/`
- `docs/notes/<the one that bites most>.md`

## Commands

- Build: `<from the profile's environment.knowledge.build>`
- Test: `<...>`
- Lint: `<...>`
- Serialization pull (architect only): `<...>`

## Rules

| Rule | Enforcer |
|---|---|
| Foundation never references Feature; Feature never references Feature | none yet |
| Agents never edit files under <serialization roots> | hook |
| <rule from the architect> | none yet |

Keep this file under forty lines. Anything longer belongs in a feature file or a note.
