# Module: shared skills

## What to tell the user first

At most two sentences, for example:

> "A skill is a folder with an instruction file that teaches an agent how to do one kind of task. I will create one shared folder for all your skills, back it up in a private repo online, and make every agent see it."

Explain other terms only when needed and only once, in one short sentence:

- **Repo**: a folder whose history is tracked by Git and can be backed up online.
- **Symlink**: a shortcut. The agent thinks the skill is in its own folder, but the real files live in the shared folder.

Do not explain hooks unless the user asks.

## How it is built

- **Source of truth:** `~/.agents/skills`, a Git repo the user owns, named `skills` on their Git hosting account, private.
- **Each agent's skills folder stays a real folder.** Inside it there is one symlink per skill, pointing into `~/.agents/skills`.
- **Flow is one-way.** Skills are edited only in `~/.agents/skills`. Nothing is ever copied from an agent's folder into the shared repo. The single exception is the one-time migration in step 4, which happens only during setup and only with the user's yes to question 2.

Why one symlink per skill and not one symlink for the whole folder: if the agent's entire skills folder pointed at the shared repo, anything the agent itself puts there (its own built-in or system skills) would leak into the user's repo. Per-skill links keep the two apart.

Do not rely on an agent reading `~/.agents/skills` on its own. Some do, some do not, and it can change between versions. The links make it certain.

This module asks only what the root `SKILL.md` lists under "Questions you may ask": question 2, question 3 and the conditional ones. It does not commit; step 5 of the root `SKILL.md` makes the one commit.

## Steps

### 1. Check the current state (read-only)

For `~/.agents/skills` and each agent skills folder (see "Known agents" in the root `SKILL.md`), report whether it is missing, a real folder, a symlink, or a file. If `~/.agents/skills` exists, run `git -C ~/.agents/skills remote -v` and `git -C ~/.agents/skills status -sb`.

Stop and ask (a conditional question) only if `~/.agents/skills` exists with content but is not a Git repo, or is a Git repo with a different remote than the user's `skills` repo. If an agent's skills folder is itself a symlink, leave that agent out, do not ask, and say so in the final summary.

### 2. Create or connect the shared repo

The repo detection from the root "Git hosting" section tells you whether the user's `skills` repo does not exist, is empty, or has content.

- **Repo has content, nothing at `~/.agents/skills`:** `git clone <URL> ~/.agents/skills`.
- **Repo has content and `~/.agents/skills` is already a clone of it:** `git -C ~/.agents/skills pull --ff-only`.
- **Repo exists but is empty:** use it. Create `~/.agents/skills` if needed, run `git init -b main` inside it and add the repo as remote.
- **Repo does not exist:** create `~/.agents/skills` if needed, run `git init -b main`, and ask question 3 ("You have no `skills` repo on GitHub. Shall I create a private one and push your skills there?"). On yes, create it with `gh repo create skills --private`, add it as remote, and report its URL. On no, add no remote.
- **No GitHub (the user gave a URL):** treat the URL as an existing repo (empty or with content, as above).

In every "repo exists" case, question 3 becomes the push question and is asked in step 5 of the root `SKILL.md`, only if there is something to push.

### 3. Add the link script and hooks

Copy these from this kit into the shared repo. If a file already exists with identical content, skip it. If it exists with different content, stop and ask (a conditional question).

| From this kit | To the shared repo |
| --- | --- |
| `modules/skills/githooks/sync-links.sh` | `.githooks/sync-links.sh` |
| `modules/skills/githooks/post-merge`, `post-commit`, `post-checkout`, `post-rewrite` | `.githooks/` (same names) |
| `modules/skills/githooks/agent-dirs.example` | `.githooks/agent-dirs.example` |
| `modules/skills/gitignore` | `.gitignore` |

Keep the scripts executable: `chmod +x ~/.agents/skills/.githooks/sync-links.sh ~/.agents/skills/.githooks/post-*`.

Then create this computer's list of agent skills folders: copy `.githooks/agent-dirs.example` to `.githooks/agent-dirs` (unless it already exists) and edit the copy so it lists exactly the skills folders of the agents installed on this computer ("Known agents" in the root `SKILL.md`), one per line. `agent-dirs` is per computer: `.gitignore` keeps it out of the repo, because two computers can have different agents. Only the example is committed. If the repo already tracks `.githooks/agent-dirs` (an older setup), leave it as it is and mention it in the final summary.

### 4. Move existing skills in (one-time, before the first run of the script)

An agent's skills folder may already hold skills the user wrote or installed there, as real folders. The link script never touches those, so without this step they stay visible to one agent only. This migration is the single exception to the one-way rule. It happens only during setup and only with the user's yes to question 2; outside setup, never copy anything from an agent's folder into the shared repo.

1. **List what is there (read-only).** In each skills folder listed in `agent-dirs`, list the real folders, not symlinks. A symlink that points somewhere other than `~/.agents/skills` is left alone and mentioned in the final summary.
2. **Leave out the agent's own skills, without asking.** Exclude built-in or system skills that came with the agent: a `.system` folder, any folder whose name starts with a dot, and anything you cannot tell is the user's. When unsure, leave it out and mention it in the final summary.
3. **If nothing is left, skip the rest of this step and ask nothing.** Otherwise ask question 2: "You already have these skills: `<list>`. Shall I move them to the shared folder so all your agents can use them?" The list names each skill with a few words from its `description`. Before asking, say in one sentence what moving means: the skill's folder goes into the shared repo and a shortcut takes its place, so the agent keeps seeing it. Answers: yes to all, pick (the user names which ones, as part of this same question), or no. A skill the user declines stays untouched in that agent's folder, remains specific to that agent, and never gets a link.
4. **Handle duplicates** among the accepted skills, and against skills already in `~/.agents/skills`. Compare with `diff -r`.
   - **Identical:** treat them as one skill, no question. If it is not in the shared repo yet, move one copy (sub-step 5). The yes to question 2 also covers the identical copies in the other agents' folders: check once more with `diff -r` that each is still identical to the shared one, then remove it so a link can take its place.
   - **Different:** ask the one combined conditional question: "`<name>` exists in `<agent A>` and `<agent B>` with different content. Which version should become the shared one, and should I remove the other?" Show the difference. Say that no backup is made of a removed version. If the user says remove, remove the other only after that explicit yes. If the user says keep it, it stays where it is as an agent-specific folder (no link is made for that agent and the link script prints a warning for it). Never merge versions on your own.
5. **Move and verify.** For each accepted skill, count its files first (`find "<agent skills folder>/<name>" -type f | wc -l`), then move the whole folder, hidden files included: `mv "<agent skills folder>/<name>" ~/.agents/skills/<name>` (the target must not exist yet). Then verify that it arrived complete: `~/.agents/skills/<name>/SKILL.md` exists, the file count in `~/.agents/skills/<name>` is the same, and the original path is now free. If anything is off, stop and report. In step 5 of this module, the link script puts a link at the original path.

The migrated skills are new files in the shared repo. They are committed with everything else in step 5 of the root `SKILL.md`.

### 5. Turn the hooks on and run the script

```bash
git -C ~/.agents/skills config core.hooksPath .githooks
```

Create each agent skills folder listed in `agent-dirs` if it is missing (`mkdir -p`), then run:

```bash
~/.agents/skills/.githooks/sync-links.sh
```

What the script does: it adds a link for every skill folder that contains a `SKILL.md`, and removes links whose skill no longer exists. It only touches links that point into the shared repo. If it finds a real folder with the same name as a skill, it leaves it alone and prints a warning; mention every warning in the final summary (usually it is a version the user chose to keep in step 4). If a listed folder does not exist, the script skips it without a message. If `agent-dirs` is missing, the script prints one line saying to create it from the example and does nothing else.

From now on Git runs the script by itself after pull, commit, checkout and rebase. The hook setting (`core.hooksPath`) is stored on this computer only, so every additional computer repeats steps 2, 3 and 5 (step 3 then only creates that computer's `agent-dirs`, because the other files come with the clone). The root skill runs the script again after the memory module has added bundled skills.

### 6. Prepare the "Shared skills" block

The block below goes into each agent's global instruction file. Replace `<repo URL>` with the real one, or drop the parenthesis if there is no remote.

- **If Rules is chosen in this run:** do not edit any global instruction file. Keep the finished text and hand it to the rules module, which writes it once.
- **If Rules is not chosen:** add the block yourself, following root rules 8 and 9: create the file if it is missing, append at the end if it has content (one backup per file per run), and skip it if the block is already there.

Never write the canonical copy of the rules here; see step 4 of the root `SKILL.md`.

```markdown
## Shared skills
Shared skills are stored in ~/.agents/skills (Git repo: <repo URL>, branch main). Before starting a task, check this directory for a relevant skill. When a skill applies, read its complete SKILL.md and resolve referenced files relative to that skill directory.

Sync rules:
- At the start of a session, run `git -C ~/.agents/skills fetch` and `git -C ~/.agents/skills status -sb`. If the branch is behind and the working tree is clean, run `git -C ~/.agents/skills pull --ff-only`. If there are local uncommitted changes or unpushed commits, tell the user before doing anything else; never discard, reset, or force-push.
- Flow is one-way: ~/.agents/skills is the source of truth. This agent's skills folder holds per-skill symlinks into it, plus only the agent's own built-in skills and any agent-specific skills the user chose to keep there. Never copy or move skills from this agent's folder (including its built-in or system skills) into ~/.agents/skills.
- To add or change a shared skill, edit it in ~/.agents/skills, then ask the user before committing and pushing.
- If a skill exists in ~/.agents/skills but has no symlink in this agent's skills folder, tell the user (or add the missing symlink if asked).

Project skills: a skill that only makes sense for one project lives in that project's repository at docs/skills/<skill-name>/SKILL.md, not in ~/.agents/skills. When working in a project, check its docs/skills folder as well.
```

### 7. Hand over to the final summary

Tell the root skill: the repo's remote address (or that there is none), the links now present in each agent's skills folder, any path you skipped or that produced a warning, and which skills were moved in and which stayed in an agent's folder as agent-specific skills. Do not commit; step 5 of the root `SKILL.md` does.

## Two kinds of skills

Tell the user this only if they ask where a new skill should go (one or two sentences):

- **Global skills** apply to any work (a code style, a writing style, a personal routine). They live in `~/.agents/skills`.
- **Project skills** only make sense inside one codebase (how to release this app, how to seed this database). They live in that project at `docs/skills/<skill-name>/SKILL.md`, so anyone who clones the project gets them. The project memory skill in this kit writes this rule into each project's `AGENTS.md`.

## Known limits

- Editing a skill through a link changes the shared file. That is intended, but it means a change made from any agent shows up in `git status` of the shared repo. Always check status, and outside a setup run ask before pushing.
- Git has no hook that runs after a push. A skill added on one computer appears on another after the next pull there.
