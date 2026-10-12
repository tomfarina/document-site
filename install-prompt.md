# Install the agent-friendly repo kit

Install the kit from https://github.com/tomfarina/document-site into the current repo.

1. Download https://github.com/tomfarina/document-site/archive/refs/heads/main.tar.gz to a temporary directory and extract it. The paths below are inside the extracted folder.

2. Copy everything in `kit/` into the root of the current repo, at the same relative paths. If a file already exists and differs, do not overwrite it. Merge `.claude/settings.json` by adding the kit's hooks to what is there. For every other conflict, ask me what to do.

3. For each folder under `skills/`, copy it to `.claude/skills/<name>/` unless that folder already exists. It already exists when the skills came from `npx skills add`.

4. Copy `.claude/sites/_template.md` to `.claude/sites/<key>.md`, using the repo name as the key. Fill in Key, Repo, Client, and Stack from what the repo shows, and leave any you cannot tell as `unknown`.

5. Delete the temporary directory. Do not commit. Finish by listing what you copied, merged, and skipped, and the profile values you chose.
