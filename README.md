# SoftwareJutsu Skills

Reusable skills for coding agents, maintained by [SoftwareJutsu](https://github.com/softwarejutsu).

[![skills.sh](https://skills.sh/b/softwarejutsu/skills)](https://skills.sh/softwarejutsu/skills)

## Install

Install the full collection:

```bash
npx skills add softwarejutsu/skills
```

Install one skill:

```bash
npx skills add softwarejutsu/skills --skill create-agent-skill
```

## Available skills

| Skill | Purpose |
| --- | --- |
| [`create-agent-skill`](skills/create-agent-skill/SKILL.md) | Create focused, maintainable Agent Skills using the standard format. |

## Add a skill

Each skill lives in `skills/<skill-name>/SKILL.md` and must include YAML frontmatter with a lowercase, hyphenated `name` and a clear `description` explaining when to invoke it. Add optional scripts, references, and assets only when they support the skill directly.

Validate a new skill before committing:

```bash
./scripts/validate-skills.sh
```

## License

[MIT](LICENSE)
