# Project working instructions

## Project map

The map standard for this repository is `docs/PROJECT_MAP.md`. Card templates and the rules for discovering areas, splitting cards and maintaining them are in that file. The entry to the map is `docs/map/index.md`. Write cards in <docs language>.

- On the first task, read `docs/PROJECT_MAP.md`. If there is no map, start one in the same task following the standard; do not wait for a separate "create the map" instruction. If the project is empty, record only the known requirements; do not invent code or architecture that does not exist.
- On later tasks, read `docs/map/index.md` first, then only the area and feature cards related to the task. If the standard is not in your current context, read `docs/PROJECT_MAP.md` before creating or changing a card.
- Use the map to reach the source code. Verify the code you are about to change, its contracts and its tests. If the map is thin or stale, widen the search as far as needed and correct the map with what you find.
- Before finishing a task that changes code or product behaviour, review the affected cards. If a purpose, boundary, entry point, contract or relation changed, update those cards in the same task. If only formatting or internal implementation changed, do not make needless doc changes.
- For a new feature, update the fitting card if one exists. Do not open a card for every folder, file, class or function. Do not repeat the same information in different cards.
- Verify sources and relations; mark what is unknown as unknown. Do not write that a review or a test run happened when it did not.
- At the end of a task, give a one-sentence status for the map: updated / reviewed, no change needed / incomplete and why. For a plain question with no new lasting information, skip this.

## Project skills

Skills that only make sense for this project live in this repository at `docs/skills/<skill-name>/SKILL.md`. Every agent uses the same folder; do not keep project skills in an agent-specific folder.

- Before starting a task, check `docs/skills/` for a relevant skill. When one applies, read its complete `SKILL.md` and resolve referenced files relative to that skill's folder.
- Skills that apply to any project are global and do not belong here. Do not copy global skills into this repository, and do not move project skills out of it.
- Add or change a project skill only when the user asks, and name the folder in English kebab-case.

## Working discipline

- Protect the user's existing work. Do not reorganise code or folders just to apply this template.
- Use the project's existing commands, tools and more specific scoped instructions. Do not invent a command, test, path or tool integration.
- Do map upkeep together with the task; do not re-read the whole repository or every card on each task.
- This file grants no extra permission to install packages, send data outside, commit, push or deploy. Follow the user's current instructions and the environment's permissions.

## <Project name> rules

<!-- SETUP: Write this section for the project, then delete this comment. Add only lasting,
project-specific working rules verified from the repository (language/framework, folder layout,
state/HTTP patterns, secret configuration, deployment facts, verification command). Do not invent
commands or tools. The last item should link to the map card that holds the verification commands. -->

As the project grows, add only lasting, project-specific working rules here. Keep architecture and feature descriptions under `docs/map/`.
