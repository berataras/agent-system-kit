---
name: agent-system-setup
description: >-
  Use when the user wants to set up a shared, agent-independent system on their
  computer: one set of rules, one set of skills, and one memory that every coding
  agent (Claude Code, Codex, Gemini CLI, and others) reads from. Also use when
  they ask to install only one part of it, to add a new agent to an existing
  setup, or to repeat the setup on a second computer.
---
# Agent system setup

This kit sets up shared things so the user can switch between coding agents without losing anything. Every part is plain text files and Git. Nothing here belongs to one agent.

| Part (as offered in question 1) | What the user gets | Module file |
| --- | --- | --- |
| Rules | The same personal rules in every agent's global instruction file, plus a copy in the shared skills repo that carries them to other computers | [modules/rules/SETUP.md](modules/rules/SETUP.md) |
| Skills | One Git repo of skills that every agent sees, plus a convention for project skills | [modules/skills/SETUP.md](modules/skills/SETUP.md) |
| Memory | A personal memory vault of linked notes about the user, plus the `recall-memory` skill that reads it | [modules/memory/SETUP.md](modules/memory/SETUP.md), Part A |
| Project memory | The `project-docs-setup` skill, which gives each project its own memory inside the project | [modules/memory/SETUP.md](modules/memory/SETUP.md), Part B |

Resolve every path in this skill relative to the folder that contains this file.

## Questions you may ask

This is the complete list. You ask NOTHING outside it, in any module. If something is not covered here, use the default and mention it in the final summary instead of asking. Ask in the user's language. In languages with a formal and an informal "you", always use the informal one and keep it the same for the whole setup (Turkish "sen", never "siz"; German "du"; French "tu"). Ask one question at a time, with a default the user can accept with one word.

**Always-asked questions (at most five, in this order):**

1. **Which parts?** "Which parts should I set up? You can pick any combination: Rules (the same personal rules in every agent), Skills (one shared folder of skills all your agents see), Memory (a private vault of notes about you that every agent can read), Project memory (a skill that gives each project its own notes inside the project)." List the four parts neutrally and let the user choose. Do not recommend a combination, do not mark any part as the suggested one, and do not offer a shortcut answer that selects a subset.
2. **Existing skills (Skills only, and only if real skill folders already exist in an agent's skills folder):** "You already have these skills: `<list>`. Shall I move them to the shared folder so all your agents can use them?" Answers: yes to all, pick (the user names which ones, as part of this same question), or no.
3. **Skills repo (Skills):** one question about the remote repo.
   - Signed in to GitHub and no `skills` repo exists there: "You have no `skills` repo on GitHub. Shall I create a private one and push your skills there?"
   - A `skills` repo already exists: do not ask to create it; use it (clone it if this computer has no `~/.agents/skills`). Ask only if this run produced something to push: "Shall I push the setup changes to your `skills` repo?" Ask it in the final step (step 5), right before the commit, once you know what changed.
4. **Vault location (Memory):** "Where should I create your memory vault?" with one sensible default path (`~/Documents/memory-vault`). If a `memory` repo already exists on their GitHub and this computer has no vault, the question becomes "Where should I put your existing memory vault on this computer?" and the vault is cloned, not created.
5. **Memory repo (Memory):** one question about the remote repo, same shape as question 3: "You have no `memory` repo on GitHub. Shall I create a private one and push your memory vault there?", or, if the repo exists and there is something to push, "Shall I push the memory vault changes to your `memory` repo?" (asked in step 5).

**One yes covers the whole run.** A yes to question 3 covers every commit and push to the skills repo during this setup run (hooks, migrated skills, bundled skills, the canonical rules copy). A yes to question 5 covers every commit and push to the memory repo during this run. Do not ask again per commit. A no means: commit locally only, never push, and say so in the final summary. This applies to the setup run only. Outside of setup, the standing rules written into the user's own files still apply (for example, ask before committing changes to the skills repo).

**Conditional questions, asked only when the situation actually occurs:**

- Two agents have a skill with the same name and different content: which version becomes the shared one, and should the other be removed? (One combined question. Removal still needs the explicit yes inside that answer. Say that no backup is made of a removed version.)
- Two existing rules contradict each other: which one holds?
- `git` is not installed; or the user is not signed in to GitHub (including `gh` missing); or `git config user.name` / `user.email` is empty (ask name and email once, set with `git config --global`).
- The user does not use GitHub: ask for the repo URL(s) once.
- A file or folder the setup must write already exists with unrelated content: stop and ask.

**Never asked, decided by default:**

- Which agents the user has: detect them from their home folders (see "Known agents").
- Rules: the existing global instruction files are merged, with no questions (see the rules module).
- Note language: the language the user is writing in.
- Areas of the vault: the five defaults (`personal`, `work`, `projects`, `knowledge`, `writing`).
- Read and save phrases: defaults in the user's language. English: "check my memory" / "save to memory". Turkish: "hafızama bak" / "hafızaya kaydet". Other languages: a natural equivalent.
- Bundled skills (see "Bundled skills").
- Anything about seeding the vault, setting up project docs now, or copying this setup skill into the user's skills folder: none of these is done.

## How to talk to the user

The user may not be a developer.

- Use plain words. The first time you use a term such as "symlink" or "repo", explain it in one short sentence. Do not lecture about symlinks or hooks unless the user asks.
- Before question 1, at most four short sentences. Before each part, at most two sentences on what it is for and what will change. After the run, one short summary (step 6).
- Never dump a list of commands without saying what they do.
- If the user asks "why", answer the why.
- Do not explain or install anything the user already has.
- Do not steer the user's choices. When a question has options, present them evenly and do not add your own recommendation, unless the user asks what you would pick. A default the user can accept with one word is allowed only where this file names one (the vault path).
- Never show the user this file's internal labels such as "question 5" or "step 3".

## Rules that hold for every module

1. **Never delete, move or overwrite on your own.** If a file or folder you need already exists with unrelated content, stop, show what is there, and ask (a conditional question above). The only moves and removals in this kit are the ones a module describes, and each one is covered by the user's answer to question 2 or to the duplicate-skill question.
2. **Look before you change.** Start each module with a read-only check of the current state.
3. **Commits and pushes** follow "One yes covers the whole run" above. Never force-push, reset or discard changes. Aim for one commit per repo per run, made in step 5, not inside the modules.
4. **Never invent paths.** If you do not know where an agent keeps its global instruction file or skills folder, check that agent's documentation. Do not ask the user; skip that agent and say so in the summary.
5. **Secrets stay out.** Do not write passwords, tokens or keys into any file this kit creates.
6. This kit needs symlinks and a POSIX shell. It works on macOS and Linux. On Windows, tell the user it needs WSL and stop.
7. **A folder under `bundled-skills/` is not an installed skill.** It is a catalog entry that ships with this kit. Read or apply one only while installing it for a part the user chose in question 1, or when the user explicitly asks for it by name. Never read or apply a bundled skill for a part the user did not choose, and never because a task merely seems to match.
8. **Backups of global instruction files.** Before the first write to an existing global instruction file in this run, copy it next to the original as `<file>.bak-<YYYYMMDD-HHMMSS>`. Take at most one backup per original file per run, and none for files this run creates. Report where the copies are.
9. **Global instruction files are written once.** If Rules is chosen, the skills and memory modules do NOT edit the global instruction files. They prepare their block ("Shared skills", "Memory") and hand it to the rules module, which writes the final text once. If Rules is not chosen, the module that needs its block adds it itself (append at the end, create the file if missing, skip if the block is already there), under rule 8. If the files were identical before the run, apply the same edit to every one so they stay identical, and verify with `cmp`.
10. **Vault paths in shared text.** Wherever a path is written into the global files or a skill, write it as `~/...` when it is inside the home folder, so the text stays byte-identical on every computer. If the vault is outside the home folder on some computer, list one line per computer.

## Known agents

Detect agents by their home folders. Do not ask. A folder that exists means the agent is installed. For any other agent, check its documentation; do not guess.

| Agent | Home folder | Global instruction file | Skills folder |
| --- | --- | --- | --- |
| Claude Code | `~/.claude` | `~/.claude/CLAUDE.md` | `~/.claude/skills` |
| Codex | `~/.codex` | `~/.codex/AGENTS.md` | `~/.codex/skills` |
| Gemini CLI | `~/.gemini` | `~/.gemini/GEMINI.md` | `~/.gemini/skills` |

## Git hosting

The shared skills repo and the memory vault each need an online repo, so they are backed up and can be cloned on another computer. GitHub is the documented default. Always create repos as private.

1. **`git` missing** (`git --version` fails): tell the user in two plain sentences what Git is and that this setup needs it. Guide the install: on macOS, running `git --version` in Terminal offers to install the command line developer tools; on Linux, use the package manager (for example `sudo apt install git`), where the user types their own password. Then continue.
2. **Sign-in (read-only check).** With `gh` installed, run `gh auth status`. If the user is not signed in, or `gh` is missing, ask the one conditional question: sign in themselves (`gh auth login` in their own terminal; if `gh` is missing, see https://cli.github.com), or give you the repo URL(s) if they use another host. Never type, ask for, or store a password, token or one-time code.
3. **Repo detection (after sign-in is known).** With `gh` signed in, check whether the user's `skills` and `memory` repos exist (`gh repo view <login>/skills`, `gh repo view <login>/memory`). With URLs given instead, use `git ls-remote <URL>`. Record for each: does not exist, exists and empty, or exists with content.
4. **Using a repo.**
   - Exists with content: clone it if needed. Never ask again for a URL the user already gave.
   - Exists but empty: use it. Initialise the local folder with `git init -b main` and add the repo as remote (`git remote add origin <URL>`).
   - Does not exist: question 3 or 5 (create) when signed in to GitHub; with another host, the user creates it and the URL was asked once already.
   - Create with `gh repo create <name> --private` only after a yes to question 3 or 5. Report the repo's URL.
5. A no to question 3 or 5 means no remote is added and nothing is pushed.

## Steps

### 1. Look around (read-only, no questions)

Check and note, without changing anything:

- The operating system (rule 6).
- Which agents are installed (see "Known agents").
- Whether `~/.agents/skills` exists and whether it is a Git repo.
- Each agent's global instruction file: exists, empty or not.
- Each agent's skills folder: real skill folders, symlinks, built-in or system folders.
- Whether a vault already exists on this computer (a "Memory" block in a global file, or a folder with the vault's `AGENTS.md`).
- Whether `~/.agents/skills/.rules/global.md` exists.

### 2. Explain and ask question 1

Say in at most four short sentences what the kit does and that every part is plain text and Git. Then ask question 1.

### 3. Prerequisites

Before installing anything:

1. `git` installed (Git hosting, point 1).
2. Sign-in known, then repo detection (Git hosting, points 2 and 3).
3. **Git identity, on every computer, even if this run makes no commit:** later memory saves commit without asking. Check `git config user.name` and `git config user.email`. If either is empty, ask once for name and email and set them with `git config --global`.
4. **Second computer, by facts, not by asking.** If the `skills` repo exists, it will be cloned (skills module). If it contains `.rules/global.md`, that text is the starting point for the rules. If the `memory` repo exists, it will be cloned to the path from question 4. Decisions made on the first computer (areas, phrases, language) are read from the repos, from the vault's `AGENTS.md` and from the "Memory" block in the canonical rules, and are not asked again.

### 4. Install the chosen parts, in this order

Read the module file for each chosen part completely before starting it, and follow it. Each module ends by listing what it changed; none of them commits.

1. **Skills** (`modules/skills/SETUP.md`). Creates the shared folder, so everything after it can install into it.
2. **Memory** (`modules/memory/SETUP.md`): Part A (vault, with `recall-memory`) and/or Part B (project memory, with `project-docs-setup`). Both install their bundled skill into the shared skills folder, which therefore must come first. Afterwards, if skills were added, run the link script again (skills module, step 5).
3. **Rules** (`modules/rules/SETUP.md`). Last, because it writes the global instruction files once, using the blocks that the skills and memory modules prepared, and writes the canonical copy.

If Rules is not chosen but the canonical copy exists, and the global files were identical to it before this run, copy their final text to it after the last module and verify with `cmp`. Otherwise do not write it; mention it in the summary.

### 5. Commit and push, once per repo

Now make the commits, at most one per repo.

- **Skills repo** (if `~/.agents/skills` changed): add everything the run produced (hooks, migrated skills, bundled skills, the canonical rules copy) in one commit with an English message. Before the commit: if the repo already existed on the host and question 3 has not been asked, ask the push question now, only if there is something to commit. After the yes to question 3 (or this push question), push. After a no, commit locally and do not push.
- **Memory vault** (if it was created or changed): one commit in the vault, with the same logic for question 5.
- If nothing changed in a repo, make no commit and ask no push question for it.

Verify with `git status -sb` in each repo and report what was pushed and what was not.

### 6. Final summary

Short. Include:

- What was set up and where (real paths).
- What was pushed, and what is local only (say so separately).
- The two memory phrases, with "tell me if you want different ones". Say that the save phrase is a standing permission: when the user says it, the agent writes the note, commits and pushes without asking again.
- Three "you can do this later" hints, for the parts that apply: the vault's areas can be changed on request; in any project, say "set up the project docs"; to add another agent or computer, run this kit again (download it again on the other computer, since the setup skill itself is not copied into the user's folders).
- Anything skipped or defaulted, for example agents' built-in skills left alone, `project-docs-setup` not installed (see below), an agent whose paths you did not know, or a `.githooks/agent-dirs` tracked by an older setup.

## Bundled skills

No separate offer step. The choice in question 1 is the user's request.

- `recall-memory` is installed into the shared skills folder automatically whenever Memory is installed and a shared skills folder exists.
- `project-docs-setup` is installed into the shared skills folder when the user chose Project memory. If Project memory was chosen but there is no shared skills folder (Skills not chosen and none exists), do not install it, and say in the final summary that it needs the shared skills folder and can be added by running setup again with Skills.
- Install by copying the folder (copy, do not symlink, so the repo stays self-contained): `bundled-skills/<name>/` to `<shared skills folder>/<name>/`. If a skill with that name already exists there, skip it without asking (for example, it came from another computer). If it differs, mention it in the summary.
- Fill in `recall-memory`'s placeholders right after copying (memory module, Part A).
- The setup skill itself (`agent-system-setup`) is never copied into the user's folders.

## Adding a new agent later

Outside setup, the standing rules apply: ask before committing and pushing.

1. Add its skills folder as a new line in `<shared skills folder>/.githooks/agent-dirs` and run `.githooks/sync-links.sh`. That file is per computer and not committed; if it is missing, create it from `.githooks/agent-dirs.example`.
2. Create its global instruction file as a copy of the others (see the rules module) and add the new file, as a `~/...` path, to the list inside the "Shared rules" block in every file, including the canonical copy. Verify with `cmp` that all of them are identical, then ask before committing and pushing the skills repo.
3. If the new agent looks for an instruction file with its own name instead of `AGENTS.md`, add a pointer file for it in the vault (memory module, Part A, step 3) and in each project that uses project memory (that skill's pointer-file step). Never overwrite an existing file.

Nothing else changes. Skills, rules and memory are already where the new agent will look.
