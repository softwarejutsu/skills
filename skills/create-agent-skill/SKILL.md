---
name: create-agent-skill
description: Create or improve a reusable Agent Skill with concise instructions, useful resources, and valid metadata. Use when designing a custom skill or standardizing an existing skill.
---

# Create an Agent Skill

## Workflow

1. Define the job the skill performs and 2–3 representative user prompts. Do not create a skill for a one-off task.
2. Choose a short, lowercase hyphenated name that describes the action.
3. Write a trigger-focused `description`: say both what the skill does and when it should be used.
4. Keep `SKILL.md` to the essential workflow. Put detailed, conditional material in `references/`; use `scripts/` for fragile or repeatable operations; use `assets/` for files consumed by outputs.
5. Add `agents/openai.yaml` for the skill UI metadata. Keep its display name and prompt aligned with `SKILL.md`.
6. Validate the folder, then update the collection README.

## Required structure

```text
skills/<skill-name>/
├── SKILL.md
└── agents/openai.yaml
```

## Quality bar

- Give explicit steps only where sequence or safety matters; otherwise allow the agent to choose the appropriate approach.
- Do not duplicate reference content in `SKILL.md`.
- Avoid extra documentation files inside a skill unless they are direct inputs to the agent's work.
- Keep instructions portable: do not assume a specific machine path, account, or unlisted tool.

## Validate

```bash
./scripts/validate-skills.sh
```
