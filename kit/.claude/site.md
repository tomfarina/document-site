# Site profile

Canonical. Agents read this before any file. Keep the whole file under 16 KB, critical lines first. Situational facts go in `docs/notes/` with a trigger line.

## Identity

- Client: <client>
- Repo: <owner/repo>
- Stack: unknown (one line: framework, language, major versions)
- Base branch: main

## Fences

Read before anything else. Each line is a path or a rule, with the reason or "reason unknown, preserve as-is."

- unknown

## Tool-owned paths

Agents read these and never edit them. A tool writes them and the architect syncs them: serialized content, migrations, generated clients, lockfiles.

- Paths: unknown
- Owning tool: unknown
- Architect's sync command: unknown

## Layout

- Runtime versions: unknown
- Top-level modules: unknown (on a Helix solution: where Foundation, Feature, Project live)
- Configuration roots and override order: unknown

## Verification

- Build command: unknown
- Builds on a stock runner: unknown (yes | no | could not run)
- Test command: unknown
- Lint command: unknown
- Runner OS: unknown
- Evidence ceiling: unknown (static trace | passing build | tests run | app runs)
- Run command: unknown
- Endpoints for read-only runs: unknown
- Secret names a run needs: unknown

## Gating files

Build and config files whose change can make a line in this profile false. One path or glob per line. The PR docs check reads this list the way it reads a feature file's `## Files` list.

- unknown

## Wrong surfaces

Things that look like the fix location but are not.

- unknown
