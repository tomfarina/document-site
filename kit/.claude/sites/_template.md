# Site profile: <key>

Canonical. Any registry row caches the gating fields from here and re-validates them on every run. Agents read this before any file. Keep the whole file under 16 KB, critical lines first. Situational facts go in `docs/notes/` with a trigger line.

## Identity

- Key: <key>
- Client: <client>
- Repo: <owner/repo>
- Role: unknown (backend | head | both)
- Platform: unknown (xp | jss-on-xp | xm-cloud)
- Base branch: main
- Target branch: develop
- Branch pattern: agent/<ticket-key>

## Fences

Read before anything else. Each line is a path or a rule, with the reason or "reason unknown, preserve as-is."

- unknown

## Versions and layout

- Sitecore version: unknown
- .NET or Node version: unknown
- Helix: unknown (yes with Foundation, Feature, Project paths | not Helix)
- Web Forms present: unknown
- Model generation: unknown (Glass | Synthesis | Leprechaun | none)
- Site definitions: unknown
- Config patch roots and ordering concerns: unknown

## Serialization

Agents read serialization and never edit it.

- Tool: unknown (Unicorn | SCS | TDS)
- Roots: unknown
- Architect's sync command: unknown

## Verification

- Build command: unknown
- Builds on a stock runner: unknown (yes | no | could not run)
- Test command: unknown
- Runner OS: unknown
- Evidence ceiling: unknown (static trace | passing build | tests run | head runs)

## Head (JSS and XM Cloud only)

- Component registry path: unknown
- Layout Service or Edge endpoint for read-only runs: unknown
- Preview API key secret name: unknown

## Item changes

- Surface: unknown (Content Editor | Pages | both)
- Review lens: unknown (helix | jss | none)

## Wrong surfaces

Things that look like the fix location but are not.

- unknown

## Eligibility overrides

- none

## Environment

```yaml
environment:
  initialize: []
  maintenance: []
  knowledge:
    build: unknown
    test: unknown
    lint: unknown
    ser-pull: unknown
  post-build: []
```
