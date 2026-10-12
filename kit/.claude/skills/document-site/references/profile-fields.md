# Site profile fields

The profile at `.claude/sites/<key>.md` has two halves. The knowledge half is always loaded and stays near 16 KB with the critical lines first. The executable half is what an agent runs to get a clean working state. Situational facts are notes under `docs/notes/` with a trigger line.

## Knowledge half

| Field | Where it comes from | If unknown |
|---|---|---|
| Key, client, repo, role (`backend`, `head`, `both`) | Install step | Stop |
| Platform (`xp`, `jss-on-xp`, `xm-cloud`) | Install step, confirm from packages | Confirm card |
| Base branch, target branch, branch pattern | Install step, defaults `main`, `develop`, `agent/<ticket-key>` | Use defaults |
| Sitecore version | `packages.config`, `*.csproj` PackageReference, or `package.json` for a head | Ask |
| .NET or Node version | `TargetFramework`, `global.json`, `.nvmrc`, `engines` | Ask |
| Helix or not, and where Foundation, Feature, Project live | Solution folders, project names | Record "not Helix" if absent |
| Web Forms present | `.ascx`, `.aspx` under the web project | Record yes or no |
| Serialization tool and roots | Unicorn configs under `App_Config/Include`, `*.module.json` for SCS, `.scproj` for TDS | Ask |
| Architect's sync command | From the tool: `dotnet sitecore ser pull`, Unicorn sync, TDS | Ask |
| Model generation (Glass, Synthesis, Leprechaun, none) | T4 templates, `*.tt`, Synthesis config, Leprechaun config | Record none |
| Site definitions | `<sites>` patches under `App_Config/Include` | Record the list |
| Config patch roots and order concerns | `App_Config/Include` folder names, `patch:before` and `patch:after` | Record |
| Build command, result on a stock runner | What you ran in step 1 and what happened | Record "could not run" |
| Test command, test framework | Test projects, `package.json` scripts | Record none |
| Evidence ceiling | From the above: static trace only; passing build; tests run; head runs | Derive |
| Runner OS | XP and JSS backend: Windows. Heads: Linux | Derive |
| Head details | Component registry path, Layout Service or Edge endpoint, preview key secret name | Ask for the endpoint and secret name |
| Item-change surface | Content Editor, Pages, or both | Derive from platform |
| Review lens | Helix for XP; JSS for heads; Helix disabled when not Helix | Derive |
| Do-not-touch fences | History, explorer reports, architect | Record with reason or "reason unknown, preserve as-is" |
| Wrong surfaces | Explorer reports: things that look like the fix location but are not | Record |
| Eligibility overrides | Architect | Leave empty |

## Executable half

```yaml
environment:
  initialize:      # install tools and runtimes, one command per line
    - ...
  maintenance:     # restore dependencies; surfaced to the agent, not auto-run
    - ...
  knowledge:       # named commands the agent references when verifying
    build: ...
    test: ...
    lint: ...
    ser-pull: ...
  post-build:      # health check; non-zero fails the environment
    - ...
```

## Situational facts

Not in the profile. A fact that applies only when touching certain paths is a note under `docs/notes/` from `docs/_templates/note.md`, with a `trigger:` line naming those paths, a tier, and a provenance suffix. The PR docs check reads the trigger the way it reads a feature file's `## Files` list. A note the architect states twice becomes a rule-table row with an enforcer, and the note then points at the enforcer.
