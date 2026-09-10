---
name: architecture-map
description: Create or refresh an evidence-based ARCHITECTURE.md for a repository, including its subsystem map, runtime flows, boundaries, and verified architectural invariants.
---

# Architecture Map

Create a concise contributor map, not an API reference or a record of every implementation detail.

## 1. Establish scope

1. Read root and relevant nested `AGENTS.md`, contributor guides, and existing architecture documentation.
2. If `ARCHITECTURE.md` exists, preserve its useful structure and refresh it; do not replace it with a generic template.
3. Inspect the repository inventory: root files, entry points, build configuration, major source directories, tests, schemas, and deployment configuration.
4. Scale the investigation to the codebase. Inspect a small repository directly. Parallelize distinct subsystems only when the repository is large enough and the environment supports it.

## 2. Collect evidence before writing

For each proposed architectural statement, record the supporting paths, symbols, and confidence while researching. Distinguish:

- **Verified fact**: directly supported by code, configuration, or maintained documentation.
- **Inference**: a reasonable conclusion from several sources; label it as such.
- **Unknown**: cannot be established from the repository; state it rather than guessing.

Only call something an invariant when the code or tests consistently enforce it.

## 3. Write the smallest useful document

Include the sections that the repository supports:

1. **Purpose and orientation** — problem, primary approach, and intended reader.
2. **Codemap** — major subsystems, their responsibilities, and the important named files or symbols.
3. **Primary flows** — request, event, build, or data flows that explain how the system operates.
4. **Boundaries and invariants** — interfaces between subsystems and verified constraints.
5. **Navigation pointers** — where contributors change common concerns, configure the system, and find tests.

Add cross-cutting concerns, diagrams, key-file sizes, or FAQs only when they materially help navigation. Use named entities and repository-relative paths according to local documentation conventions. Do not document secrets, credentials, or sensitive operational details.

## Diagrams

Use Mermaid only when a relationship is clearer visually. Choose `flowchart` for dependency or layer structure and `sequenceDiagram` for ordered runtime interactions. Keep each diagram focused on one question and label meaningful boundary crossings. Validate Mermaid when an appropriate validator is available; otherwise keep syntax simple and review it manually.

## Verification

Before finishing:

- Confirm each referenced path exists with `test -e`.
- Search for each named symbol or module and correct stale names.
- Trace every architectural claim to its evidence; mark unsupported conclusions as inferences or unknowns.
- Check that the document explains where a contributor would start for the most common changes.
- List maintenance triggers, such as a new subsystem, boundary change, renamed entry point, or altered deployment model.

Report the files changed and any architecture questions that remain unanswered.
