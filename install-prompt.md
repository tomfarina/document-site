# Install the agent-friendly repo kit

Copy everything in the `kit/` folder next to this file into the root of the current repo, at the same relative paths.

If a file already exists and differs, do not overwrite it. Merge `.claude/settings.json` by adding the kit's hooks to what is there. For every other conflict, ask me what to do.

Then copy `.claude/sites/_template.md` to `.claude/sites/<key>.md`, using the repo name as the key. Fill in Key, Repo, Client, and Stack from what the repo shows, and leave any you cannot tell as `unknown`.

Do not commit. Finish by listing what you copied, merged, and skipped, and the profile values you chose.
