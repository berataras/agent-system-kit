# Memory vault working rules

This vault is the user's personal memory. Their preferences, decisions, project states and anything worth knowing later are kept up to date under `wiki/`. It is fed by what the user says directly, by what becomes clear while working together, and by references the user explicitly hands over. It changes only on the user's instruction. Conversations are not archived in full.

```text
what the user tells you ───────────┐
what becomes clear while working ──┼── user's update instruction ──> wiki/
references the user hands over ────┘                                   │
                                                                       └── question ──> answer / outputs/
```

Write what you add (area lines and scopes, note bodies) in **{{CONTENT_LANGUAGE}}**. Structural parts stay in English: this file, the headings of `wiki/index.md` and of the index, map and concept notes, and the frontmatter keys. File names are English `kebab-case`.

## Structure

```text
.
├── AGENTS.md
├── CLAUDE.md           pointer to this file (other agents may have their own)
├── wiki/
│   ├── index.md
│   ├── indexes/        one file per area: {{AREAS}}
│   ├── maps/
│   └── concepts/
├── outputs/
│   ├── answers/
│   ├── slides/
│   └── images/
├── templates/
├── tools/
└── .health/
```

Do not add new top-level folders. Do not build an archive of raw source files here, and do not scan or copy the user's other notes into the vault on your own.

## What each folder is for

- `wiki/index.md`: the root entry. Links only to the area indexes.
- `wiki/indexes/`: one entry note per fixed area ({{AREAS}}). Links to maps and, where needed, straight to concepts.
- `wiki/maps/`: topic and project maps that arrange at least three related concepts or a meaningful reading order.
- `wiki/concepts/`: one living, canonical note per topic. Preferences, decisions, project states and knowledge live here.
- `outputs/answers/`: structured answers and research reports.
- `outputs/slides/`: presentations.
- `outputs/images/`: generated charts and diagrams.
- `templates/`: templates for index, map and concept notes.
- `tools/`: helper scripts that work on the wiki.
- `.health/`: reports from consistency checks.

## Rules that do not change

1. Change memory only on the user's instruction to save or update. Answering a question, doing research or producing an output is not permission to update the wiki. If something worth saving came up, remind the user at the end; do not save without the instruction.
2. `wiki/` is the living, canonical memory. A fact does not need a source file to be saved.
3. State the sources you actually used. Keep apart what the user told you, what an outside source claims, and what you inferred. Mark your own synthesis with the label `**Inference:**`.
4. Navigation order is `wiki/index.md → area index → map (if any) → concept`. The root index never links straight to a map or concept.
5. The area indexes are fixed: {{AREAS}}. Do not create a new one unless the user asks.
6. Do not create a map unless there are at least three related concepts or a clear reading order. Otherwise link the concept straight from its area index.
7. A note may appear in several indexes or maps. Do not copy its content; link to the one canonical concept.
8. One concept per topic. Before creating a file, check existing names and `aliases`. When a decision or project state changes, update the existing note. If the reason behind the old decision still matters, keep it as a short dated history line.
9. A concept must make sense on its own, and its first paragraph is a two-to-three sentence summary. Keep the knowledge and the context that will be useful later, not a transcript.
10. Use wikilinks: `[[note-name|Visible title]]`. Link index, map and concept notes in both directions. Leave no broken links.
11. Link a new concept from its map, or from the area index if there is no map. Link a new map from its area index. Update the root index only when the area indexes change.
12. Do not run terminal commands or scripts in `tools/` without the user's approval. The Git operations approved for memory tasks are listed below.
13. A document outside the vault being moved, deleted or changed does not make the wiki wrong by itself. Point out contradictions; never undo the user's current decision because of an old source. Do not record an uncertainty as a fact.

## Frontmatter

Every index, map and concept note has these fields:

```yaml
---
type: index | map | concept
title: Readable title
aliases: []
tags: []
status: stub | draft | reviewed
sources: []
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

- `sources` lists the documents or links actually used. They do not have to be inside the vault. Never invent a path or URL.
- Folder and type match: `wiki/indexes/` → `index`, `wiki/maps/` → `map`, `wiki/concepts/` → `concept`. `wiki/index.md` is also `type: index`.
- For facts the user told you directly, `sources: []` is correct. Where it helps, say in the text that the user gave the information, or the date of the decision.
- A missing source does not mean `status: stub`. Use `stub` when the note itself is thin.
- Refresh `updated` whenever the content changes.
- When a source is a project path, write it relative to the project root, never the full path on the user's computer.

## Saving and updating

When the user says "{{SAVE_PHRASE}}", "remember this", "update my memory" or similar:

1. Read `wiki/index.md`, then the relevant area index and map. Go down only to the concept notes that matter.
2. Work out the lasting facts, preferences, decisions and current state covered by the instruction. Do not copy the conversation. Drop passing details.
3. If the user asked you to take a document or link into memory, read it; work through long documents section by section. It does not need to be archived here. A request to review or summarise a document is not an instruction to save it.
4. Find the note for the topic and update it. If there is none, create one from `templates/concept.md`. Adapt the template sections to the kind of information and remove empty ones.
5. If the new information contradicts the record, apply the user's explicit correction. If it is unclear which is current, say so and ask. Label your inferences.
6. Add the references you really used to `sources`. Refresh `updated`.
7. Link related concepts in both directions.
8. Pick the fixed area index first. Update the map if there are at least three concepts or a meaningful reading order; otherwise link the concept straight from the index.
9. Link a new map from the area index, and a new concept from the map or the index, in both directions.
10. Tell the user what was saved, which notes were created or updated, any contradictions, and what is still missing.

Do not create separate "source notes". The knowledge and its reference live in the canonical concept note.

## Answering from memory

When the user says "{{READ_PHRASE}}" or asks something the vault can answer:

1. Read `wiki/index.md`, then the relevant area index and map.
2. Go down only to the relevant concept notes and, if needed, their reachable references. If what is there is enough, do not search further.
3. A short answer can be given directly. A long one is written to `outputs/answers/YYYY-MM-DD-topic.md`.
4. Presentations go to `outputs/slides/`, charts and diagrams to `outputs/images/`.
5. If lasting information, a correction or a gap came up while answering, suggest saving it. Change the wiki only if the user says so.
6. If the notes are thin or contradict each other, say so plainly. Do not invent certainty.

Producing an output is not saving to the wiki.

## Outputs

- Answer: `outputs/answers/YYYY-MM-DD-topic.md`
- Presentation: `outputs/slides/YYYY-MM-DD-topic.md`
- Image: `outputs/images/YYYY-MM-DD-topic.png`
- Every output links to the wiki notes and the real sources it rests on.
- An output that is no longer valid is not deleted. Add a link to the newer one and say it is superseded.

## Health check

When the user says "health check" or "lint", write `.health/YYYY-MM-DD.md` and check for:

- Broken wikilinks
- Concept notes with no links at all
- Missing or wrong frontmatter, or a `type` that does not match its folder
- Links from the root index to anything other than an area index
- Maps not linked from an area index; concepts in no map or index
- One topic split across several notes, and needless repetition
- Inferences without the label
- Concepts with no summary, or a summary that no longer describes the current state
- Index and map descriptions that are out of date
- Facts that contradict each other, stale project states, and unclear "which decision is current"
- Missing context and open questions that need the user

A missing source file or an empty `sources` field is not an error.

A health check is permission to write the report, not to change the wiki. If the user also asked for fixes, repair the safe, clear structural errors. For anything that affects meaning, merging, deleting or scope, ask. End the report with three to five questions that would fill the gaps.

## Reading order and scale

As the vault grows, do not read every file. The order is:

1. `wiki/index.md`
2. The relevant note in `wiki/indexes/`
3. The relevant note in `wiki/maps/`, if any
4. The summary paragraphs of concept notes
5. The full text of the concepts you need
6. The sources, only when necessary

If the user only asks you to load memory, read `AGENTS.md` and the root index and stop. A project, topic or person being mentioned is not a reason to read all of its notes. If you cannot find something, do not widen the search without need.

If the indexes, maps and summaries are out of date, the knowledge cannot be found in practice. The navigation upkeep an allowed update needs is part of the same job.

## Git rules

An authorised memory update is saved with a normal commit and push straight to `main`. No branch and no pull request just for a memory update.

1. Before a memory update, check `git status` for local changes and the remote `main`, then run `git pull --ff-only`. Keep local and unrelated changes. If the pull would overwrite a local change or conflicts, stop. No reset, no forced pull, no overwriting.
2. Commit the authorised change and push it to `main`. Do not leave it local only. Add only the files changed in this task.
3. On a conflict, a risk of overwriting, or a failed push: stop and report the full local and remote state. Never delete or overwrite the user's local changes. No force-push, no hard reset.
4. These Git operations are approved for memory tasks. Other terminal commands and `tools/` scripts still need approval.
5. Syncing is not a background or scheduled job. The first time you reach the vault in a session, compare it with the live remote `main` and pull with `--ff-only` if it is behind. If the computer is offline, say the sync is pending; do not say it is done. Do not install scheduled tasks or scan the disk.
6. If the vault exists on more than one computer, write to Git from one computer at a time. A push to `main` does not mean the other computer's copy is updated.
7. Always tell the user separately what was written and what was pushed. If one of them failed, say which. Never present it as done.
