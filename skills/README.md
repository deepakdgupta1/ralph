# Ralph Skills

Skills are specialized instruction sets that agents can load for specific tasks.

## Available Skills

| Skill | Description | Triggers |
|-------|-------------|----------|
| [prd](prd/SKILL.md) | Generate Product Requirements Documents | "create a prd", "write prd for", "plan this feature" |
| [ralph](ralph/SKILL.md) | Convert PRDs to prd.json format | "convert this prd", "create prd.json", "ralph json" |
| [dev-browser](dev-browser/SKILL.md) | Browser-based UI verification | "verify in browser", "check ui", "screenshot" |

## Skill Format

Each skill lives in its own directory with a `SKILL.md` file containing:

```yaml
---
name: skill-name
description: "What the skill does and when to use it. Triggers on: keyword1, keyword2."
---
```

Followed by the skill instructions in markdown.

## Usage

Skills are loaded by the agent when needed. In Amp, use:

```
Load the [skill-name] skill
```

Or reference a trigger phrase and the agent will load it automatically.

## Creating New Skills

1. Create a directory: `skills/[skill-name]/`
2. Create `SKILL.md` with frontmatter and instructions
3. Add to this README

### Skill Guidelines

- **Focused**: One skill = one job
- **Actionable**: Clear steps the agent can follow
- **Verifiable**: Include checklists and success criteria
- **Examples**: Show expected inputs/outputs
