---
name: recall-memory
description: >-
  Use this when the user says "{{READ_PHRASE}}" about a topic, or asks something
  that their personal memory vault can answer, to read the vault before answering.
---
# Recall memory

The user keeps a personal memory vault: a Git repo of linked Markdown notes. Read it before answering.

## Vault locations

- Local path: `{{VAULT_PATH}}`
- Git mirror: `{{VAULT_REPO}}` (branch `main`, private)

Use the local path if it exists on this machine. If it does not, read from the Git mirror. Reading needs no approval.

<!-- SETUP: replace the three placeholders in this file with the real values. Write the local path as a ~/... path whenever the vault is inside the home folder, so this file is identical on every computer. If the vault is outside the home folder on some computer, add one line per computer. Then delete this comment. -->

## Steps

1. Check the vault's Git state against the live remote `main`. If it is behind, run `git pull --ff-only`, keeping local and untracked changes. Stop and report on divergence or conflict.
2. Read the vault's `AGENTS.md` first, then follow its reading order: `wiki/index.md` → the relevant area index in `wiki/indexes/` → the relevant map in `wiki/maps/` → only the relevant concept notes in `wiki/concepts/`. Do not read every file.
3. Answer from what you read. Keep what the notes say apart from your own inference. Say plainly when the vault has no answer, or when notes conflict or look out of date.
4. This skill is read-only. Change the vault only when the user explicitly says to save or update memory, and then follow the vault's own `AGENTS.md`, including its Git rules. If the vault exists on more than one computer, write to Git from one computer at a time.
