# Module: memory

This module has two independent parts. Install whichever the user chose in question 1 ("Memory" is Part A, "Project memory" is Part B).

- **Part A, personal vault:** what the agent knows about the person, across all projects.
- **Part B, project memory:** what the agent knows about one codebase, stored inside that codebase.

The vault follows the person, project memory follows the project. Technical details of a project must not pile up in the personal vault.

This module asks only what the root `SKILL.md` lists under "Questions you may ask": question 4, question 5 and the conditional ones. It does not commit; step 5 of the root `SKILL.md` makes the one commit per repo.

---

## Part A: personal vault

### What to tell the user first

At most two sentences, for example:

> "Agents forget you between sessions, and the memory an agent keeps by itself belongs to that agent. I will create a folder of linked text notes that you own, that any agent can read, and that changes only when you say so."

Explain the "second brain" idea or Git only if the user asks.

### Decisions you make without asking

- **Content language:** the language the user is writing in. File names are always English kebab-case.
- **Areas:** the five defaults, `personal`, `work`, `projects`, `knowledge`, `writing`. An area is a broad, lasting part of a life or work, not a single topic. The final summary says they can be changed later.
- **Read and save phrases:** defaults in the user's language. English: "check my memory" / "save to memory". Turkish: "hafızama bak" / "hafızaya kaydet". Other languages: a natural equivalent. The final summary states them with "tell me if you want different ones".
- **Languages, stated once.** Structural files stay in English: the vault's `AGENTS.md`, the headings of `wiki/index.md` and of the area index notes, frontmatter keys, and the headings of the templates. The content the agent writes is in the user's language: area lines in `wiki/index.md`, area scopes, note bodies. The files in `templates/` are translated only in their placeholder text.
- **The vault is not seeded** with facts about the user. It starts empty apart from the area indexes.

### Which case applies

Check in this order (the vault's facts decide, not a question):

1. **A vault already exists on this computer** (found by a "Memory" block in a global file, or a folder with the vault's `AGENTS.md` and a Git repo): use it. Run `git -C <vault> pull --ff-only` (keep local changes; on a conflict stop and tell the user). Ask no question. Go to "Existing vault", step 4 onwards.
2. **No vault here, and the user's `memory` repo exists with content:** ask question 4 in its existing-vault form, "Where should I put your existing memory vault on this computer?" (default `~/Documents/memory-vault`), then follow "Existing vault".
3. **Otherwise** (no repo, or an empty repo): ask question 4, "Where should I create your memory vault?" (default `~/Documents/memory-vault`), then follow "New vault".

If the chosen folder exists and is not empty, and it is not a clone of the user's vault, stop and ask (a conditional question). Never merge into an existing folder on your own.

### New vault

1. **Check the target (read-only).** The folder does not exist or is empty.
2. **Copy the template.** Copy everything inside `modules/memory/vault-template/` to the chosen folder, then rename `gitignore` to `.gitignore`. The template contains hidden entries (the `.health/` folder and `.gitkeep` files that keep empty folders in Git), and a plain `cp -R vault-template/* <vault>` skips them. Copy the folder's contents including hidden files, for example `cp -R modules/memory/vault-template/. <vault>/` (create `<vault>` first if it does not exist). Afterwards verify that `<vault>/.health/` exists and that the number of `.gitkeep` files matches the template (`find <folder> -name .gitkeep | wc -l` on both).
3. **Add pointer files for the user's other agents.** The template ships `CLAUDE.md`, a short file that sends the agent to `AGENTS.md`, because some agents look for an instruction file with their own name in a folder instead of `AGENTS.md`. For each other agent found in step 1 of the root `SKILL.md` whose instruction file is not `AGENTS.md` (for example `GEMINI.md` for Gemini CLI; for other agents check their documentation, do not guess), create an equivalent pointer file with the same text as `CLAUDE.md`, but without its last line `@AGENTS.md`. That line is Claude Code's import syntax (Claude Code loads `CLAUDE.md` by itself, not `AGENTS.md`), so do not copy it. In `GEMINI.md`, end with Gemini CLI's documented import line instead: `@./AGENTS.md`, as plain text on its own line. For any other agent, add an import line only if that agent's documentation describes one. Remove none of the existing files, including `CLAUDE.md`, and never overwrite one.
4. **Fill in the placeholders** in `AGENTS.md` and `wiki/index.md`:
   - `{{CONTENT_LANGUAGE}}`: the language the user is writing in.
   - `{{AREAS}}`: the five areas, in every place it appears.
   - `{{READ_PHRASE}}` and `{{SAVE_PHRASE}}`: the default phrases.
   - `{{TODAY}}`: today's date as `YYYY-MM-DD`.
5. **Create one index note per area** in `wiki/indexes/<area>.md` from `templates/index.md` (the vault's copy, before translation).
   - Fill the title, dates and a **scope of one or two neutral sentences, in the content language, derived from the area's name**. Never write it as if the user had said it, and never invent facts about the user. For example: personal: "This area covers personal life: health, family, interests and everyday matters."; work: "This area covers work: jobs, employers, responsibilities and work-related matters."; projects: "This area covers projects: things being built or planned, and their current state."; knowledge: "This area covers things worth knowing: topics, ideas and references."; writing: "This area covers writing: drafts, style and writing projects."
   - Keep the headings "Root index", "Maps" and "Direct concepts". Delete the template's placeholder bullet lines under "Maps" and "Direct concepts", so those headings stand empty until real notes exist.
   - In `wiki/index.md`, replace the SETUP comment with one line per area linking to its index, and link each area index back to the root. The scope text in these lines is the same neutral scope, in the content language.
6. **Translate the templates if needed.** If the content language is not English, translate the placeholder text (the parts inside `{{ }}` and the HTML comments) inside `templates/concept.md`, `templates/index.md` and `templates/map.md`. Keep headings and frontmatter keys in English.
7. **Start Git.** `git init -b main` in the vault. If the user's `memory` repo exists (empty), add it as remote and use it. If it does not exist, ask question 5, "You have no `memory` repo on GitHub. Shall I create a private one and push your memory vault there?" On yes, create it with `gh repo create memory --private`, add it as remote and report its URL. On no, add no remote. If the repo exists, the push question is asked in step 5 of the root `SKILL.md`, only if there is something to push. Do not commit here.
8. **Prepare the "Memory" block** (below), then hand it over or add it, as described.
9. **Install `recall-memory`.** If a shared skills folder exists, install `bundled-skills/recall-memory` into it automatically (root, "Bundled skills") and fill in its placeholders: `{{VAULT_PATH}}` as the vault path (root rule 10), `{{VAULT_REPO}}` as the repo URL (or "none yet"), and `{{READ_PHRASE}}`. Then delete the SETUP comment in the installed copy.

### Existing vault

Use this when the user's vault already exists, on this computer or only on their Git host (a second computer).

1. **Check the target (read-only)** if it is a new location. A folder that is not empty and not a clone of the vault: stop and ask.
2. **Git hosting.** Already done in root step 3 (Git, sign-in, identity), because the repo is private and cloning needs access.
3. **Clone it** if it is not on this computer yet: `git clone <memory repo URL> <vault>`. Do not copy the template and do not change the vault's content.
4. **Read the vault's `AGENTS.md`.** It holds the content language, the areas and the two phrases. Use those values from now on. Do not ask the setup questions again.
5. **Pointer files, only if missing.** If one of the user's agents needs a pointer file (new vault, step 3) that the vault does not have yet, or a `GEMINI.md` pointer lacks its `@./AGENTS.md` line, add it. It is a change to the vault and is committed in step 5 of the root `SKILL.md`.
6. **Prepare the "Memory" block** and **install `recall-memory`**, as in New vault, steps 8 and 9. If `recall-memory` is already in the shared skills folder, do not copy it again.

### The "Memory" block

Fill in the real values. Write the vault path as `~/...` if the vault is inside the home folder (root rule 10). If the vault is outside the home folder, or lives at different paths on different computers, write one line per computer.

- **If Rules is chosen in this run:** do not edit any global instruction file. Hand the finished block to the rules module.
- **If Rules is not chosen:** add the block yourself (root rules 8 and 9).

```markdown
## Memory
My personal memory is a vault of linked notes at <vault path> (private Git repo: <repo URL>, branch main). Its working rules are in the vault's AGENTS.md; read that file first and follow it.

- When I say "<read phrase>", read the vault before answering. Reading needs no approval.
- Change the vault only when I explicitly say "<save phrase>" or ask you to update it. Then write to the vault, commit, and push directly to main without opening a pull request. Tell me separately what was written and what was pushed.
- The first time you touch the vault in a session, update it with `git pull --ff-only`. Keep local changes; if there is a conflict, do not overwrite anything and tell me.
- Do not set up periodic or background syncing. No force-push, no hard reset.
- Do not use your own built-in memory for facts about me or my projects. Personal facts go in the vault when I ask; project facts go in that project's AGENTS.md or docs/.
```

If there is no remote, drop the parenthesis.

### Hand over to the final summary

Tell the root skill: the vault path and repo address (or that it was cloned and not changed), the areas created, the two phrases, and that the save phrase is a standing permission. Do not commit.

---

## Part B: project memory

### What to tell the user first

At most two sentences, for example:

> "Each project gets its own memory, stored inside the project, that every agent reads. I will add the skill that creates it; you use it later, in any project."

### What it is

The skill `bundled-skills/project-docs-setup` puts three things into a repository:

- `AGENTS.md`: working instructions every agent reads, including the project's own rules. For agents that look for a file with their own name instead (such as `CLAUDE.md` or `GEMINI.md`), it adds a short pointer file that sends them to `AGENTS.md`.
- `docs/PROJECT_MAP.md`: the standard that says how the map is built and maintained.
- `docs/map/`: the living map itself, one short card per area and feature.

It also sets the convention for **project skills**: skills that belong to one project live in `docs/skills/<skill-name>/SKILL.md`, and the generated `AGENTS.md` tells every agent to look there.

### Steps

1. **If a shared skills folder exists** (Skills chosen in this run, or already there), install `bundled-skills/project-docs-setup` into it (root, "Bundled skills"). It is added to the skills repo and committed in step 5 of the root `SKILL.md`.
2. **If there is no shared skills folder,** do not install it. Say in the final summary that project memory needs the shared skills folder and can be added by running setup again with Skills.
3. Do not set it up in any project during this run. The final summary tells the user how to do it later.

### Hand over to the final summary

Tell the root skill where the skill was installed (or that it was not), and the one-sentence usage: "In any project, say: set up the project docs."
