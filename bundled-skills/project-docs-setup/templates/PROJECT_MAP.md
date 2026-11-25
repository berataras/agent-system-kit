# Living project map standard

Version: 1.0

This file is a working standard that can be used in any project; it does not describe the project itself. Following it, the agent builds short, linked, project-specific cards under `docs/map/`. The goal is to reduce the exploration needed to find the relevant code on later tasks. The map does not replace the source code and the tests.

Use the templates in this file. No separate template file, package, database, MCP server or service needs to be set up. Placeholders shown in code blocks are not left in the cards you produce. Make no assumptions in advance about the project's language or architecture.

## 1. Start on the first task

1. Read the existing scoped instructions and the user's task. If `docs/map/index.md` exists, use it first; do not generate a map from scratch.
2. If there is no map, look at the repository's top-level structure, its manifest/workspace files and any existing architecture or product entry docs. Do not scan the contents of dependency, build, vendor, cache, binary or generated files. Do not carry secrets or runtime data into the map.
3. Find the application entry points, the main responsibilities, the data/contract boundaries and where the tests live. Read a few representative entry points of the candidate areas. If something is unclear, widen the targeted review; do not try to explain every file.
4. Determine the top-level areas with the rules below. Do not fix the number of areas in advance; show the areas you found as one row each in the entry table. Do not keep a separate counter: the table shows how many there are.
5. Create the project entry card and the top-level area cards you can prove. Also create the feature cards relevant to the first task. If the details of other areas have not been reviewed yet, say so in their own cards; do not claim completeness.
6. Make use of existing docs; do not produce a second long document on the same subject. For a good existing doc, link to it from the card. Do not delete or move existing docs unless the user asks.
7. Continue with the user's actual task. Do not turn starting the map into a separate, open-ended documentation project.

### If there is no code yet

Create only `docs/map/index.md`: the known purpose, the source of the requirements, the uncertainties, and planned areas that have a reason. If no area is known, the table may stay empty. Mark plans derived from requirements as `planned`. Do not write imaginary file paths, APIs, dependencies, test commands or an "existing architecture". When code appears, link the relevant cards to the real sources.

## 2. How to separate areas and features

An **area** is a large group of responsibility that can be described in one sentence and has its own scope of change and tasks. A **feature** is a behaviour or capability inside that area that is worth finding and changing on its own.

For top-level grouping, choose an approach that fits the existing architecture and record the reason in one sentence in the project entry:

| **Existing structure**                                     | **Natural top-level areas**                                 |
| ---------------------------------------------------------- | ----------------------------------------------------------- |
| Separate applications and deployment boundaries dominate   | Application/subsystem: web, extension, API, worker.         |
| Clear business responsibilities inside one application     | Business area: orders, payments, membership.                |
| Library, CLI or data project                               | Capability group: parser, transformation, command execution. |

Do not add the examples to a project automatically. An API is an application boundary; payments is a business area. Do not mix these at the same level without a reason. Decide by how the code is really organised and where tasks cluster; do not reorganise the code to match the choice.

- The normal depth is **project → area → feature**. Where the area card is enough for the task, a feature card is not required.
- Open a separate card only when two conditions hold together: there is a separate responsibility/interface, and reading it on its own makes sense on later tasks. The number of files alone is not a criterion.
- Shorten a long card first. If it still carries behaviours independent of each other, split it. Do not split just to even out the number of headings or folders.
- A feature has one canonical card. If it touches several areas, keep it under the main owner and connect the others with relations. If the end-to-end flow is complex, use the flow card below.
- Show a shared module as a shared area/feature only if several areas really use it and it has its own contract. Do not move every helper function into a "shared" area.
- A deeper level may be opened only when an existing feature contains independent sub-responsibilities. Write the reason in one sentence in the parent card. Stay at three levels by default.

## 3. File layout

```other
AGENTS.md
docs/
  PROJECT_MAP.md
  map/
    index.md
    <area>/
      index.md
      <feature>.md
    flows/
      <flow>.md                 # only if needed
  skills/
    <skill-name>/
      SKILL.md                  # project-specific skills, only if any exist
```

File names are English kebab-case. Write card text in the language stated in `AGENTS.md`; if none is stated, use the language the user writes in. Do not change real code symbols. Use standard relative Markdown links between cards; do not use links that only work in one note-taking tool. Write code paths relative to the repository root and show them clearly as code.

A file name is not an identity. Use each card's fixed `id` field. When a title or path changes, do not change the id for cosmetic reasons. The root id is `project`, area ids are `area.<slug>`, feature ids are `feature.<area>.<slug>`, flow ids are `flow.<slug>`. Ids are unique within the repository. For separate repositories, do not act as if a local path exists; write the repository name and a reachable source link explicitly.

## 4. Project entry card template

Use the template below for `docs/map/index.md`. Aim for about 300 words for the entry card; in large projects the necessary area rows may exceed that. Do not list every feature again here.

```other
---
schema: 1
id: project
kind: project
status: planned
summary: "<The project's purpose, one sentence>"
---

# <Project name>

<Whose problem does it solve, and which problem? Two sentences at most.>

## Organisation
Grouping: <application / business area / capability>. Reason: <one sentence>.

## Areas
| Area | Responsibility and when to read it | Card |
| --- | --- | --- |
| <Name> | <One sentence> | [<Name>](<area>/index.md) |

## Cross-area view
<A small Mermaid view or short link table showing only the main relations.>

## Shared resources
- <If any: a link to a verified run/test instruction or contract document.>

## Scope and open points
- <Which areas were reviewed, which are not detailed yet?>
```

`status` values: `planned` not implemented yet; `active` linked to existing code; `needs-review` its match with the source is uncertain. `active` does not mean the tests pass or that the whole project was reviewed. The scope section of the entry card states the limits of the review.

## 5. Area and feature card template

Use the same template for area and feature cards. Choose `kind: area` for an area and `kind: feature` for a feature. Aim for 250–500 words including metadata; do not pad a small card to reach that range.

```other
---
schema: 1
id: "<fixed-id>"
kind: feature
parent: "<parent-card-id>"
status: active
summary: "<One-sentence responsibility>"
read_when:
  - "<Tasks or search terms that call for this card>"
owns:
  - "<repo-relative-directory-or-file>"
entrypoints:
  - "<repo-relative-file>#<real-symbol-or-heading>"
sources:
  - "<real-code-contract-or-requirement-source>"
relations: []
checks: []
---

# <Card title>

<Two sentences at most on the responsibility and its boundary.>

Parent card: [<Parent title>](<relative-card-path>)

## Child cards
<Only if any: one link and a one-sentence description per child card.>

## Flow and contract
<Trigger → main operation → result. Five steps at most.
Link to the existing contract; do not copy the whole schema.>

## Rules to keep
- <An important invariant or trap not obvious from the code. Three items at most.>

## Links
<Relative links to the target cards of the relations in the metadata.
Do not write the reason for the relation a second time.>

## Open points
<Only if there is an important uncertainty.>
```

In a card with no child card, relation or open point, remove that body heading. Keep the metadata fields; use `[]` for an unknown list. In a card that is not implemented, write `status: planned`, and where there is no real source code, `owns: []` and `entrypoints: []`. Do not give the impression that a proposed path is real.

`owns` is not an inventory of all files; it is the scope of responsibility that routes a task to the card. Use a few narrow directories where possible. Overlap between an area and its child feature is normal: the most specific feature match is used first, the parent area as fallback. If ownership is unclear at the same level, narrow the scope or describe the shared responsibility.

For `entrypoints`, 3–7 important entries are usually enough; if there are fewer, do not invent more. Use the file and the real symbol instead of line numbers. Put only an existing related test path or a verified command in `checks`; this field is not a record that the tests were run.

## 6. Relations: the real data of the graph

Containment is kept in the `parent` field. Add a working relation once, to the `relations` list of the source card:

```yaml
relations:
  - to: "<target-card-id>"
    type: calls
    reason: "<Why does this link exist? One sentence.>"
    evidence: "<repo-relative-source>#<real-symbol-or-section>"
```

Types: `calls` calls; `reads` reads; `writes` writes; `publishes` publishes an event; `subscribes` listens to an event; `uses` any other concrete dependency. The type and the reason must be explicit. Do not add an unresolved target or an unproven dependency as a definite relation; write it under open points. Both cards of a planned relation may be planned, and its evidence points to the requirement source; these do not count as existing behaviour.

The Mermaid view is a summary of the metadata, not a separate source of information. Change the relation in the metadata first, then refresh the affected view. The top view holds areas; an area view holds features only where needed. Do not fill one graph with every function or every feature. When rolling feature relations up to area level, leave the details out of that view.

To find incoming dependencies, search for the target `id` in `relations.to` entries instead of reading every card body. Do not add a relation to the target card as a second, reversed entry; if there is a real reverse behaviour, it can be a separate relation. Parent/child navigation links, however, must exist in both directions.

## 7. Flow card — only if needed

If a behaviour moves across several areas/features and reading the cards one by one does not explain the order, create `docs/map/flows/<flow>.md`. Do not open one for a simple call.

```other
---
schema: 1
id: "flow.<slug>"
kind: flow
status: active
summary: "<End-to-end behaviour>"
participants: ["<existing-card-id>", "<existing-card-id>"]
sources: ["<real-flow-source>"]
---

# <Flow name>

Trigger: <what starts it?>

1. [<Card>](<relative-path>) — <what happens in this step?>
2. [<Card>](<relative-path>) — <what happens in this step?>

Result / important failure path: <short description>.
```

Aim for about 200 words for a flow card. Link to the flow from the participating area cards. Do not describe the participants' responsibilities again here; do not add working relations that do not exist just to complete the flow.

## 8. Reading and upkeep on every task

### When starting

- Pick the task's area from the entry card. Start with the relevant card and the neighbours you need. Do not read all cards or all sources before the need arises.
- When you see source changes, unreachable paths or information that conflicts with the task, verify the card. A card existing is not proof that it is current.
- If the map does not point to the right place, do a targeted code search using the task's terms and entry points. Write the new routing you found into the card.

### Before finishing

1. Identify the files changed in this task. With Git, consider staged, unstaged, new, moved and deleted files along with committed changes. Do not claim the user's changes from the start of the task as your own. Without Git, use the available record of file changes.
2. Match the changed paths against `owns`, `entrypoints`, `sources` and relation evidence. Add an unmatched new area to the entry table and a new feature to the fitting parent card; do not open a card automatically for a helper file.
3. Review the affected cards. If an external contract or relation changed, also look at the related consumer/producer cards. On a move or delete, repair the old links; do not delete all product knowledge just because a code path was removed.
4. Update only the lasting information that changed. If a new entry, domain/area, feature, important flow or link appeared, update the related navigation links and views as well.
5. Run the checks below on the affected cards and their neighbours. If a map validator exists, use it. If not, check the files; do not run commands such as `map:check` that are not set up.
6. Report the upkeep status in one sentence in the final answer. If the review could not be done, say why; do not present it as complete.

### Checklist

- Are ids unique; do parent and relation targets exist?
- Is there a loop in the parent chain; can every card be reached from the entry?
- Are parent/child navigation links correct?
- Do the referenced real files and symbols exist?
- Do relations have a source; does the drawing match the metadata?
- Are plans kept apart from implemented behaviour?
- Is the same behaviour described in two cards; does the card make finding the task easier?

When adding a new card, check for an id clash across the whole map's metadata. In day-to-day upkeep, do not re-read all unrelated cards. When a shared contract or the top-level area structure changes, widen the review as far as needed.

## 9. Limit growth

Do not add code bodies, the full file tree, all API schemas, a copy of the setup guide, a task log or general software advice to the cards. Link to the existing canonical document. Do not create the impression of upkeep by updating a date field. If the meaning of the code did not change, do not add text just to have touched the docs.

These two files are an upkeep protocol carried out by the agent. They do not set up a process that runs by itself in the background. Changes made while no agent is running are reviewed on the next related task. Hook/CI validation can be set up separately later; if it is not set up, do not act as if it exists. Do not install new tools to apply this standard, and do not ask the user for upkeep approval on every task; do the upkeep within the existing permissions.
