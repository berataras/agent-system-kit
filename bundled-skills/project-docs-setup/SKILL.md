---
name: project-docs-setup
description: >-
  Use when the user asks to set up the standard project docs (AGENTS.md +
  docs/PROJECT_MAP.md + docs/map/) in a repository, e.g. "set up the project
  docs", "give this project a memory", "add PROJECT_MAP and AGENTS.md here".
  Copies the bundled templates exactly, fills only the project-specific section
  from verified repo facts, and starts the living project map.
---
# Project docs setup

This sets up a standard docs structure in a repository so that any agent can find its way around the project and keep that knowledge current. Use the two bundled files exactly as they are; do not rewrite or reword them.

- [templates/PROJECT_MAP.md](templates/PROJECT_MAP.md): the living project-map standard. It does not depend on any project, so copy it as is.
- [templates/AGENTS.md](templates/AGENTS.md): the agent working instructions. The "Project map", "Project skills" and "Working discipline" sections and the closing paragraph are shared and stay as they are. Only the `## <Project name> rules` section is filled in per project.

## Steps

1. **Check the current state.** Run `git status` and protect the user's uncommitted work. Check whether `AGENTS.md`, `docs/PROJECT_MAP.md`, `docs/map/` or `docs/skills/` already exist.
   - If they exist, do not overwrite them blindly. Compare them with the templates, show the differences, and ask the user whether to update them. Keep any project rules that already exist.
   - If there is a `CLAUDE.md`, `GEMINI.md` or another agent instruction file, do not delete or overwrite it. Step 5 handles it.
2. **Decide the docs language.** Do not ask. Use the language the user is writing in, unless the repository's existing docs clearly use another one. Structural parts stay in English: `docs/PROJECT_MAP.md`, the shared sections of `AGENTS.md`, card frontmatter and card section headings, and file names. The content you write is in the docs language: the project-rules section of `AGENTS.md` and the bodies of the cards.
3. **Copy PROJECT_MAP.md.** Copy `templates/PROJECT_MAP.md` byte-for-byte to `<repo>/docs/PROJECT_MAP.md`, then verify the copy with `cmp`.
4. **Create AGENTS.md.** Copy `templates/AGENTS.md` to `<repo>/AGENTS.md`, then:
   - Replace `<Project name>` with the project's name and `<docs language>` with the language from step 2.
   - Write the project-rules section using only facts verified from the repository: language and framework, folder layout, state and HTTP patterns, how config and secrets are handled (describe them by variable name only), deployment facts the user has given, and the verification commands taken from the manifest. Do not invent commands, tools or paths. If you cannot find something, leave it out and mention it in your report.
   - Delete the `<!-- SETUP ... -->` comment.
   - Keep the shared sections word for word.
5. **Add pointer files for other agents.** Some agents look for an instruction file with their own name in the project root instead of `AGENTS.md` (for example, Claude Code looks for `CLAUDE.md` and Gemini CLI for `GEMINI.md`). For any other agent, check its documentation for the file name; do not guess.
   - To find out which agents the user uses, look for their home folders (for example `~/.claude`, `~/.codex`, `~/.gemini`) and for instruction files already in the repository. Ask only if you cannot tell.
   - For each of those agents whose project instruction file is not `AGENTS.md`, create that file in the project root with this text:

     ```markdown
     All working instructions for this project are kept in one file: **[AGENTS.md](AGENTS.md)**

     Before doing anything in this repository, read `AGENTS.md` first and follow it.

     Do not repeat or fork the rules in this file. If a rule needs to change, change it in `AGENTS.md`.
     ```

   - Add one more line at the end of that text for the two agents whose documentation describes an import syntax: `@AGENTS.md` in `CLAUDE.md` (Claude Code) and `@./AGENTS.md` in `GEMINI.md` (Gemini CLI). Each agent loads its own file by itself but not `AGENTS.md`, and this line imports `AGENTS.md` so its content is loaded even if the sentence is not followed. Write it as plain text on its own line, not inside backticks or a code block, where it would be ignored. Keep each agent's own form. For any other agent, write the text only, unless its documentation describes an import syntax.

   - Never overwrite an existing file on your own. If it already points to `AGENTS.md`, leave it; if it is a `CLAUDE.md` or `GEMINI.md` pointer without its import line, offer to add that line. If it has real content, show it and ask whether to move its rules into the project-rules section of `AGENTS.md` and leave the pointer text in its place. Only on a yes, move the rules, show the result, then replace the file's text with the pointer. On a no, leave the file as it is and mention it in your report.
6. **Start the map.** Follow `docs/PROJECT_MAP.md` section 1, "Start on the first task":
   - Create `docs/map/index.md` and the top-level area cards you can back with evidence. For an empty project, create only the index, following "If there is no code yet".
   - Link existing good docs instead of copying them. Do not move or delete existing docs.
   - If someone else is changing code in the repository at the same time, create only the index and add the area cards after that change lands. State this in the index's scope section.
7. **Prepare the project skills folder.** Do not create `docs/skills/` empty. If the repository already has project-specific skills somewhere else (for example under an agent-specific folder), list them and ask the user whether to move them to `docs/skills/<skill-name>/`.
8. **Link the project rules to a card.** The last project rule should link to a map card that actually exists (for example, the platform or verification card). Leave no broken links.
9. **Report.** Tell the user which files were created or changed (including pointer files), which project rules you wrote and what they are based on, what you left out, and the map status. Do not run `git add` or `commit` without asking.

## Rules

- Write card bodies in the docs language, keep card frontmatter and section headings in English, and name files in English kebab-case, as the standard requires.
- Keep project-specific permanent decisions (deployment shape, architecture decisions) in this repository's `AGENTS.md` or `docs/`, not in an agent's private memory.
- When the standard itself needs to change, update the templates in this skill, ask the user, then commit and push the skill. Changing `PROJECT_MAP.md` in one repository alone causes drift between projects.
