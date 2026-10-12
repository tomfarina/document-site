# Site profile fields

The profile at `.claude/site.md` is the first file an agent reads. It stays near 16 KB with the critical lines first. Situational facts are notes under `docs/notes/` with a trigger line.

| Field | Where it comes from | If unknown |
|---|---|---|
| Client, repo | Install step | Stop |
| Stack | Install step, confirm from package manifests and project files | Confirm card |
| Base branch | Template default `main`; change it when the repo's base is not `main` | Use the default |
| Do-not-touch fences | History, explorer reports, architect | Record with reason or "reason unknown, preserve as-is" |
| Tool-owned paths, owning tool | Paths a tool writes: serialized content, migrations, generated code, lockfiles. Found from tool configs and generated-file headers | Ask |
| Architect's sync command | From the owning tool | Ask |
| Runtime versions | Project files, `global.json`, `.nvmrc`, `engines`, and the like | Ask |
| Top-level modules | Solution or workspace folders, project names. On a Helix solution, where Foundation, Feature, and Project live | Record the folders as found |
| Configuration roots and override order | Config folders, environment overlays, patch or merge order | Record |
| Build command, result on a stock runner | What you ran in step 1 and what happened | Record "could not run" |
| Test command, lint command | Test projects, package scripts | Record none |
| Runner OS | What the build needs | Derive |
| Evidence ceiling | From the above: static trace only; passing build; tests run; app runs | Derive |
| Run command, read-only endpoints, secret names | Package scripts, launch configs, env files by name | Ask for the endpoint and secret names |
| Gating files | The build and config files the fields above were read from | Record |
| Wrong surfaces | Explorer reports: things that look like the fix location but are not | Record |

## Situational facts

Not in the profile. A fact that applies only when touching certain paths is a note under `docs/notes/` from `docs/_templates/note.md`, with a `trigger:` line naming those paths, a tier, and a provenance suffix. The PR docs check reads the trigger the way it reads a feature file's `## Files` list. A note the architect states twice becomes a rule-table row with an enforcer, and the note then points at the enforcer.
