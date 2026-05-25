---
name: New agent platform support
about: Adding support for Cursor / Aider / Windsurf / OpenCode / etc.
title: "[agent] add support for "
labels: enhancement, agent-platform
---

## Agent platform

Name: (e.g. Cursor, Aider, Windsurf)
Version: 
Link to docs:

## Skill loading mechanism

- Path the agent looks at for SKILL.md / instructions: 
- Format expected: (markdown? YAML frontmatter? JSON?)
- Does it support multi-file (`scripts/`, `references/`)?

## Proposed symlink / install path

```bash
# What command would install growth-retrospective into this agent?
```

## Storage paths

- Where would the agent's "auto-loaded memory" live? (For the short-index layer.)
- Or is there no auto-load equivalent and we should write to `<repo>/.growth-log/` instead?

## Testing

- [ ] I have access to this agent and can test
- [ ] I do not — would need maintainer or another contributor to verify
