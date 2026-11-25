# Module: rules

This module asks no questions of its own. The only question that can arise here is the conditional one from the root `SKILL.md` ("Two existing rules contradict each other: which one holds?").

## What to tell the user first

At most two sentences, for example:

> "Every agent reads a personal instruction file when it starts, and each agent has its own. I will merge what you already have into one text, put the same text in every agent's file, and add one rule: when you give a new rule, the agent writes it to all of the files."

If the user has a shared skills repo, add: "A copy also goes into your skills repo, so the rules come with you to other computers."

## How it is built

- Each agent keeps its own global instruction file in its own place (locations: "Known agents" in the root `SKILL.md`). This module does not move them.
- All of those files hold exactly the same text.
- **Canonical copy:** if the user has a shared skills repo (`~/.agents/skills`), the same text is also kept at `~/.agents/skills/.rules/global.md`. It is the copy that travels to other computers through the repo. All global instruction files and the canonical copy are byte-for-byte identical. `.rules/` is a dot-folder, like `.githooks/`, so the link script never treats it as a skill.
- One block inside the files tells every agent to keep them identical.
- **This module writes the global instruction files once, at the end.** It collects the blocks prepared by the skills module ("Shared skills") and the memory module ("Memory"), adds its own "Shared rules" block, and writes the final text a single time (root rule 9).

## Steps

### 1. Check the current state (read-only)

For each agent the user has, report whether the file exists, how long it is, and whether the files already match each other (`cmp` or `diff`). Also check whether `~/.agents/skills` is a Git repo and whether `~/.agents/skills/.rules/global.md` exists. If the skills repo exists on the user's Git host but is not on this computer and Skills was not chosen, read its `.rules/global.md` without cloning (for example `gh api repos/<login>/skills/contents/.rules/global.md`); that text is then the starting point.

### 2. Merge what exists, without questions

Build one starting text. Never ask which file wins.

1. Collect the text of the canonical copy (if it exists, or was read remotely in step 1) and of every global instruction file on this computer that has content.
2. **Merge by these rules:**
   - Every rule is kept once.
   - Exact duplicates (the same line or paragraph, ignoring surrounding whitespace) are dropped.
   - The user's wording is never changed or shortened. Do not reword, summarise, reorder the words of, or "clean up" a rule.
   - Rules that overlap without contradicting each other are both kept, verbatim.
   - Keep headings. Where two files have the same heading, put the rules of both under it, each once, in the order they first appear (canonical copy first, then the file with the most content).
   - The managed blocks ("Shared skills", "Memory", "Shared rules") are the exception: if a block with that heading already exists, keep that version as it is and only add what this run needs (for example a new agent's path in the "Shared rules" list, or one more per-computer line for the vault path).
3. **Contradictions** are the only thing you may ask about: two rules that cannot both hold (for example "always commit when done" and "never commit without asking"). Ask which one holds, and write only that one. When in doubt, it is not a contradiction: keep both.
4. If all files are empty and there is no canonical copy, the starting text is empty.

### 3. Assemble the blocks

Final text, in this order: the merged rules, then the "Shared skills" block (if the skills module prepared one, or one already exists), then the "Memory" block (if the memory module prepared one, or one already exists), then the "Shared rules" block below. Each block appears exactly once.

Shared rules block. List the global instruction files of every agent the user has, on any of their computers, as home-relative `~/...` paths, never absolute ones, so the text stays identical on every computer. A file for an agent that is not installed on this computer stays in the list; it is simply skipped here. If this computer has an agent whose file is missing from the list, add it.

```markdown
## Shared rules
My global instruction files and their canonical copy must always be identical:
- ~/<path to file 1>
- ~/<path to file 2>
- ~/<path to file 3>
- ~/.agents/skills/.rules/global.md (canonical copy, in my shared skills repo)

At the start of each session, after updating the skills repo, check that this file, the other files in the list that exist on this computer and the canonical copy are byte-for-byte identical. If they differ, tell me before changing anything; do not choose a version on your own. If a pull brought a newer canonical copy (for example a rule added on another computer), offer to copy it to the other files.

When I tell you a rule, save it permanently in this file. Whenever you add, change or remove a rule here, apply the same change to every file in the list above, including the canonical copy. Then ask me before committing and pushing the skills repo.

Project-specific facts and decisions (architecture, deployment, conventions of one codebase) do not belong here. Save them in that project's AGENTS.md or docs/ folder, where every agent working on the project can see them.

When working in any project, read the AGENTS.md in the repository root first if it exists, even if this agent normally reads a differently named file.
```

Without a shared skills repo, leave out the canonical copy's line, the sentence that starts with "If a pull brought", and the sentence about committing and pushing.

### 4. Write the same text to every file, once

1. Back up each existing global instruction file that will change, as in root rule 8 (one backup per file per run, none for files created now). Skip a file whose final text equals its current text.
2. Write the final text to each global instruction file on this computer, creating missing ones.
3. Verify they are byte-for-byte identical with `cmp`. Report the result.

### 5. Write the canonical copy once

- **With a shared skills repo that is private (or has no remote):** `mkdir -p ~/.agents/skills/.rules`, write the same text to `~/.agents/skills/.rules/global.md`, and verify with `cmp` that it is identical to every global instruction file. Do not commit it here: step 5 of the root `SKILL.md` commits it together with the rest of the run's skills repo changes.
- **If that repo is public:** do not write the canonical copy, because the rules would become public. Say so in the final summary.
- **Without a shared skills repo:** skip this step. The rules exist only on this computer; say so in the final summary.

### 6. Hand over to the final summary

Tell the root skill: the list of files and that they are identical; whether the canonical copy was written (the commit and push happen in step 5 of the root `SKILL.md`); where the backup copies are; any rules that were added to a file during the merge; and the one-line usage: "Tell any agent 'add this to my rules' and it will write the rule to all of your agents."

## Notes for the agent

- These files are read at the start of every session, so keep them short. Long explanations belong in skills.
- Do not put secrets in these files.
- Do not offer to write new rules for the user and do not ask for new ones. This module only merges what exists.
- This module keeps separate identical files and does not replace them with symlinks to one file, because each agent's file stays a normal file that its own tooling can read and edit. The cost is that the rule in the "Shared rules" block has to be followed.
