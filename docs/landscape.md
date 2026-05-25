# Landscape — AI-augmented personal growth + learning + retro tools

A fair survey of adjacent tools as of 2026-05. Goal: help readers find the right
tool for their situation, not push our skill. Every tool listed below solves a
real problem; differentiation is shape, not quality.

If you're an author of a tool listed here and the description is wrong or
out-of-date, [open a PR](../CONTRIBUTING.md) — accuracy serves readers and we
update without ceremony.

## Quick decision tree

```
Q: What is your tool tracking?

  Code quality / engineering output ─────▶ /retro (gstack), claude-dev-insights
  Project-specific knowledge / gotchas ──▶ /learn (gstack), napkin
  General agent memory / context ────────▶ claude-mem, akephalos, beads, memU
  Knowledge-graph / second brain ────────▶ second-brain-skills, graphify, tapestry
  Continuous learning while shipping ────▶ claude-code-continuous-learning-skill
  Personal growth gaps (this skill) ─────▶ growth-retrospective ← you are here
  Decision-making coaching ──────────────▶ no canonical option as of 2026-05
```

The category labels are descriptive, not prescriptive. Many tools span 2-3
categories.

## Code quality / engineering retrospectives

### `/retro` (gstack)
- **What**: Weekly engineering retrospective from git history. Analyzes commit cadence, work patterns, per-person contributions (in team mode).
- **Strengths**: Git-native, no extra storage, surfaces "what shipped" cleanly.
- **Gaps relative to growth-retrospective**: No tier system, no graduation markers, no human-skill / meta-cognition categories. Team-aware.
- **Best when**: You want a recurring "what did we ship + what could improve" doc from observable git data.

### `claude-dev-insights` ([kanopi](https://github.com/kanopi/claude-dev-insights))
- **What**: Per-session analytics for Claude Code — duration, tokens, costs, tool usage, 29 data points per session, optional Google Sheets sync.
- **Strengths**: Quantitative metrics with dashboards. Great for ROI conversations.
- **Gaps relative to growth-retrospective**: Quantitative-only; doesn't surface qualitative learning patterns or skill gaps.
- **Best when**: You need to defend Claude Code adoption with concrete usage numbers.

## Project knowledge + learnings

### `/learn` (gstack)
- **What**: Project learnings index — review, search, prune, export.
- **Strengths**: Project-scoped, light, easy to integrate with retros.
- **Gaps relative to growth-retrospective**: No prioritization by challenge level; no exit criteria for learnings.
- **Best when**: You want a searchable index of "things learned about this codebase."

### `napkin` ([blader](https://github.com/blader/napkin))
- **What**: A Claude Code skill that gives the agent persistent memory of its mistakes via a per-repo markdown scratchpad.
- **Strengths**: Tight scope, agent-side memory, low overhead.
- **Gaps relative to growth-retrospective**: Tracks agent mistakes, not user growth gaps. No tier or graduation system.
- **Best when**: You want Claude to remember "don't do X in this repo" across sessions.

### `claude-code-continuous-learning-skill` ([blader](https://github.com/blader/claude-code-continuous-learning-skill))
- **What**: Autonomous skill extraction and continuous learning — Claude gets smarter as it works.
- **Strengths**: Active learning loop; agent-driven knowledge accumulation.
- **Gaps relative to growth-retrospective**: Focus is agent's accumulating knowledge, not user's growth patterns. No 5-category sweep, no graduation markers.
- **Best when**: You want the agent to compound its understanding of your codebase, not your own gaps.

## Agent memory / context engines

### `claude-mem` ([thedotmack](https://github.com/thedotmack/claude-mem))
- **What**: Automatic session capture + AI compression for long-term memory, SQLite + ChromaDB, RAG integration.
- **Strengths**: Background passive operation, semantic search via vectors.
- **Gaps relative to growth-retrospective**: Generic agent memory, not categorized by growth dimension; no decision-velocity ranking.
- **Best when**: You want Claude to remember context across sessions without effort.

### `akephalos` ([sunnja69](https://github.com/sunnja69/akephalos))
- **What**: Markdown-first portable agent passport — preferences, tool notes, rules, durable memories. Cross-agent (Claude Code, Codex, Cursor, Hermes, OpenClaw, MCP).
- **Strengths**: Plain-files-and-git sync; agent-neutral.
- **Gaps relative to growth-retrospective**: Stores agent preferences/notes; not a growth-tracking tool per se.
- **Best when**: You bounce between multiple agents and want consistent preferences.

### `beads` ([gastownhall](https://github.com/gastownhall/beads))
- **What**: Memory upgrade for coding agents — persists context across sessions, Go binary.
- **Strengths**: Lightweight, language-agnostic.
- **Gaps relative to growth-retrospective**: Pure context persistence, no growth framing.

### `nessie` (personal context engine)
- **What**: Access user's personal context engine from AI agent sessions — search transcripts, read contexts, generate structured contexts.
- **Strengths**: Personal-context across all your work, not project-scoped.
- **Gaps relative to growth-retrospective**: Doesn't surface "what's still hard" — provides context, doesn't categorize.

## Knowledge graph / second brain

### `second-brain-skills` ([coleam00](https://github.com/coleam00/second-brain-skills))
- **What**: Collection of Claude skills to turn Claude Code into a Second Brain (Tiago Forte's PARA / CODE methodology).
- **Strengths**: Methodologically grounded; bridges PKM and coding agents.
- **Gaps relative to growth-retrospective**: Knowledge-organization focused; not focused on shrinking-gap retro mechanics.
- **Best when**: You want PKM (Tiago Forte / Building a Second Brain) integrated with your agent workflow.

### `graphify` ([safishamsi](https://github.com/safishamsi/graphify))
- **What**: Knowledge-graph skill ingesting code, SQL, scripts, docs, papers, images, video. GraphRAG with tree-sitter + Leiden community detection.
- **Strengths**: Truly multi-modal knowledge graph; semantic queries.
- **Gaps relative to growth-retrospective**: Heavy infrastructure; not designed for personal-growth retro pattern.

### `tapestry` ([michalparkola](https://github.com/michalparkola/tapestry-skills-for-claude-code/tree/main/tapestry))
- **What**: Interlink and summarize related documents into knowledge networks.
- **Strengths**: Document network construction; lighter than graphify.

### `ship-learn-next` ([michalparkola](https://github.com/michalparkola/tapestry-skills-for-claude-code/tree/main/ship-learn-next))
- **What**: Skill to help iterate on what to build or learn next, based on feedback loops.
- **Strengths**: Iterative loop framing; closest in spirit to growth-retrospective.
- **Gaps relative to growth-retrospective**: Iteration-focused, not gap-tracking; no graduation markers.

## Personal growth / reflection

### `growth-retrospective-skill` (this skill)
- **What**: 5-category gap tracking ranked by decision-velocity signals from git + chat, with graduation markers + Step 0 forcing function (anti-busywork).
- **Strengths**: Items are designed to leave the list; cross-agent; signal-grounded tier assignment.
- **Gaps**: Layer 3 outcome data is zero (needs real users for 3+ months); single-user dogfood evidence only as of 2026-05.
- **Best when**: You're a solo developer who has tried 3+ learning logs that piled up; you want the one designed to shrink.

### `solo-skills` ([rockscy](https://github.com/rockscy/solo-skills))
- **What**: 7 bilingual (EN + 中文) skills for solo founders and indie devs — launch tweets, customer emails, decision frameworks, postmortems.
- **Strengths**: Solo-founder audience match; "When NOT to use" sections.
- **Gaps relative to growth-retrospective**: Doesn't track personal gaps; focused on output (tweets, emails, postmortems).
- **Best when**: You want solo-founder-shaped utility skills, not a growth log.

### `founder-skills` ([ognjengt](https://github.com/ognjengt/founder-skills))
- **What**: Claude skills for founders — packaged startup workflows.
- **Strengths**: Startup-specific framings.
- **Gaps relative to growth-retrospective**: Startup-workflow utilities, not growth tracking.

## "Manage your own skills"

### `skill-creator` ([anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/skill-creator))
- **What**: Provides guidance for creating effective Claude Skills.
- **Strengths**: Anthropic-official, well-documented.
- **Use with growth-retrospective**: If you're building your own retro variant, this is the right starting tool.

### `find-skills` ([vercel-labs](https://github.com/rohitg00/skillkit-find-skills))
- **What**: Discovery tool for finding existing skills — 418K installs.
- **Strengths**: Highest-installed skill in the ecosystem.

## Honest gaps in the landscape

As of 2026-05, the categories that are still underserved:

1. **Decision-making coaching** — no skill specifically targets "help me make faster better decisions," only retroactive analysis. growth-retrospective brushes against this with decision-velocity signals but doesn't coach in-the-moment.
2. **Team / multi-user growth tracking** — all tools above are solo-dev. Team adaptations are emerging but no canonical option.
3. **Cross-project gap aggregation** — most tools are project-scoped; tracking "what gap recurs across my 4 projects" is unsolved.
4. **Pre-action gate (forcing function as a skill primitive)** — growth-retrospective is unique in having Step 0 Action Audit as a refusal mechanism. The pattern could be lifted into other tools.

If you're building in #1–#4, the maintainer of this repo would love to read your design notes. Drop a comment on the [roadmap issue](https://github.com/YoungApple/growth-retrospective-skill/issues/1).

## How to use this landscape

- **If you found this via search**: pick the row that matches your situation. Most readers don't need growth-retrospective — they need /retro or napkin or claude-mem instead. That's correct.
- **If you're already using one tool and want to add another**: see the "Best when" line for each. The right number of growth/retro tools installed is 1-2, not 5.
- **If you're an author and the description is wrong**: PR welcome. Accuracy serves readers.

## Methodology

The comparisons are based on:
- Reading each tool's `SKILL.md` / README (as of 2026-05-25)
- Checking the latest commits to see what's actively maintained vs abandoned
- Star counts as a proxy for adoption (not endorsement)

No tool was tested longitudinally — that requires the same 3+ month horizon the
growth-retrospective project itself is currently lacking data on.
