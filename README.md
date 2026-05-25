# growth-retrospective

English · [简体中文](README.zh-CN.md)

[![Validate](https://github.com/YoungApple/growth-retrospective-skill/actions/workflows/validate.yml/badge.svg)](https://github.com/YoungApple/growth-retrospective-skill/actions/workflows/validate.yml)
[![Release](https://img.shields.io/github/v/release/YoungApple/growth-retrospective-skill)](https://github.com/YoungApple/growth-retrospective-skill/releases)
[![License](https://img.shields.io/github/license/YoungApple/growth-retrospective-skill)](LICENSE)
[![Star History Chart](https://api.star-history.com/svg?repos=YoungApple/growth-retrospective-skill&type=Date)](https://star-history.com/#YoungApple/growth-retrospective-skill&Date)

**Most learning logs grow forever. This one is designed to shrink.**

A cross-agent skill that turns a solo dev's git history + chat history into a tiered list of *what they're actually learning right now*, with **graduation markers** — concrete conditions for moving an item off the list. Works in Claude Code, OpenAI Codex CLI, and Google Antigravity.

### One-line install (Claude Code + Codex CLI + Antigravity, auto-detected)

```bash
curl -fsSL https://raw.githubusercontent.com/YoungApple/growth-retrospective-skill/main/install.sh | bash
```

The installer clones to `~/.claude/skills/growth-retrospective/` (canonical) and symlinks into each agent's skill directory it finds. Idempotent — safe to re-run for updates.

**Cursor + VS Code** use per-project skill directories (not global). Run from inside your target project:

```bash
cd <your-project>
mkdir -p .cursor/skills && ln -s ~/.claude/skills/growth-retrospective .cursor/skills/growth-retrospective
```

(The same path works for VS Code with the Skills extension. If you don't have the canonical install yet, run the one-line installer above first.)

**Want to audit before piping curl to bash?** Recommended:

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill /tmp/grs
cat /tmp/grs/install.sh   # audit
bash /tmp/grs/install.sh
```

Then in any session: `/retrospective` (or keyword: *"what are my gaps", "review my growth", "am I improving"*).

**Want to see output before installing at all?** Run the demo (5 seconds, no LLM, no install):

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill /tmp/grs && \
  bash /tmp/grs/examples/demo-fixture/demo.sh
```

Shows the Step 0 Action Audit + signal extraction on a synthetic 14-day project.

**One file out**. You read it once and know: what's hard right now, what concrete action would close each gap, and what observable condition would let an item graduate.

### Real example (anonymized)

A 12-day-old solo project, 138 commits, 7 chat sessions, 15 ADRs. After one pass:

- **5 Tier 1/2 items** with explicit graduation markers
- **2 items demoted to Tier 3** via objective marker (not vibes)
- **1 cross-category insight** the dev hadn't noticed: stats decisions are slow AND happen at 1am AND late-night decisions reverse more often. Only visible across the 5-category sweep.
- **Per-incremental cost**: ~$0.30, 5 minutes.

Full output: [examples/anonymized-worked-example.md](examples/anonymized-worked-example.md).

### What's different from other retro / learning-log tools

| Tool | What it does | What it misses |
|---|---|---|
| `/retro` (gstack) | Commit cadence + work patterns | No tier system, no graduation markers |
| `/learn` (gstack) | Project learnings index | No prioritization by challenge level |
| `claude-mem` | Auto-load memory | Doesn't categorize by 5 growth dimensions |
| `nessie` | Personal context engine | Doesn't surface what's *still hard* |
| **growth-retrospective** | **Tiered by decision-velocity signals + graduation markers + 5 dimensions** | **You will have to use it for 3 months to know if it works** |

For the detailed side-by-side (cost per retro · storage model · when to install which), see [docs/comparisons.md](docs/comparisons.md).

**Considering other tools in this space?** See [docs/landscape.md](docs/landscape.md) — a fair survey of 15+ adjacent skills across 6 categories (engineering retro, project knowledge, agent memory, knowledge graph, personal growth, skill management) with "best when" guidance. Most readers don't need growth-retrospective — they need /retro or napkin or claude-mem instead. The landscape doc helps you find the right tool for your situation.

The genuinely novel part: **graduation markers**. Every item in Tier 1/2 has an observable, time-bounded condition for leaving the list. *"3 PRs without consulting `/codex` on stats"* beats *"feel confident with stats."* The whole point is items leaving, not items piling up.

### The "shrinking gap" promise

The skill bets that **decision velocity × decision quality** is the right north-star for solo-dev growth. Velocity alone is reckless; quality alone is paralysis. Together they say: *"I make better calls faster than I did three months ago."*

You verify this is real by checking, every 3 months: are old gaps actually graduating? Are similar gaps recurring less? The skill ships [a quality eval framework](#how-to-eval-quality) so you can answer "is this working?" with data, not vibes.

---

## Why this exists

Every project leaves a trail of evidence about where its builder is stretching versus operating from expertise — slow decisions, multi-round reviews, repeated chat questions, reversed ADRs, recurring bugs. Without deliberate capture, the same gaps recur on the next project.

This skill operates one loop:

```
capture signals → categorize across 5 dimensions → prioritize by decision velocity
  → produce learning journeys with graduation markers → measure if gaps shrink
```

It is **not** an inspirational coach. It surfaces evidence, ranks it, and tells you the next concrete artifact that would close a gap. If a gap has been "Tier 1" for 6 weeks with no level-up action completed, the skill names that — kindly, but factually.

---

## The five growth categories

Most "learning logs" track only category 1. This skill tracks all five because they compound — a stuck work habit can mask a domain gap, an unprocessed meta-cognitive pattern can keep recreating the same productivity drag.

| # | Category | Signal source | Example level-up action |
|---|---|---|---|
| 1 | **Domain knowledge** — technical / scientific concepts learned while building | ADRs, multi-round reviews | Write a one-page cheatsheet |
| 2 | **Human skills** — judgment, abstraction, communication clarity, asking precise questions | Chat patterns over weeks | Practice ritual with sparring partner |
| 3 | **Work habits** — ADR discipline, PR review cadence, commit hygiene | git history | Automate the habit (hook, template) |
| 4 | **Meta-cognition** — patterns about how you learn / decide / fail | Patterns across multiple domains | Name the pattern, build a guardrail |
| 5 | **Productivity / focus / energy** — when/where/how long you do your best work | Commit timestamps, session lengths | Restructure schedule around the pattern |

Categories 4 and 5 are most often skipped because they're hardest to instrument. The bundled scripts (`scan_git_signals.sh`, `scan_chat_signals.py`) extract data for all five.

---

## The three storage layers

| Layer | Path | Loaded when | Purpose |
|---|---|---|---|
| **Short index** | `~/.claude/projects/<id>/memory/learning_domains.md` (Claude Code; agent-specific elsewhere) | Every chat session, automatically | "What tier is everything in right now" — one line per item |
| **Detailed reference** | `<repo>/docs/learning-domains.md` | On-demand grep | Five fields per item: **Signal · Concepts in play · Status · How to level up · Graduation marker** |
| **Operational logbook** *(optional, for sprint-driven projects)* | `<repo>/growth/` with `daily-signals/`, `weekly-retros/`, `decisions/`, `learnings/` subdirs | On-demand | Daily / weekly captures that feed signals back into the tier system |

The short index has a token-cost budget (~80 lines / ~4 KB) because it loads every chat. The detailed reference and logbook have no budget.

---

## Tier system + signal taxonomy

| Tier | Meaning | Promotion / demotion rule |
|---|---|---|
| **Tier 1** | High challenge — slow decisions, ongoing iteration | Multi-round reviews, reversals, evidence-falsified challenges |
| **Tier 2** | Medium challenge — decided but tested by reality | Incident-driven, reversed-then-decided, awaiting future trigger |
| **Tier 3** | Settled — applying, not learning | Meets a graduation marker (e.g. "3 PRs without consulting `/codex` on stats") |

**Decision velocity is the proxy for challenge level.** A slow decision means the user is stretching. The full taxonomy distinguishes:

- **Strong signals** (Tier 1 trigger): decision reversal, 3+ review rounds, multi-version research docs, evidence-falsified challenges
- **Medium signals** (Tier 2 trigger): open `wedge-blocker` issues, `needs-human`-labeled issues, stacked PRs on one domain, `code-review fixes (max-effort pass)` follow-up commits
- **Weak signals** (tie-breakers only): PR open-to-merge time, file churn, long PR descriptions
- **Anti-signals** (never count as growth gap): repeated meta-instructions to the AI agent (these are tool/loading issues, not user gaps), `nice-to-have` labels, input volume without artifacts

See [`references/signal_taxonomy.md`](references/signal_taxonomy.md) for the full taxonomy.

---

## Level-up action principles

Every Tier 1 and Tier 2 item gets 2-3 **level-up actions** plus a **graduation marker**. Three rules from [`references/learning_journey.md`](references/learning_journey.md):

1. **Doable in ≤ 4 hours of focused work.** "Become better at statistics" fails. "Write `backend/evals/STATS-CHEATSHEET.md` — 3 concepts × 1 example each" passes.
2. **Produces an artifact, not 'reads more'.** Reading rarely shrinks gaps; producing does. Cheatsheets, probe scripts, telemetry alerts, diagrams.
3. **Externalizes the practice.** Right behavior should be easier to do, not require willpower. Build a hook, add a template, set an alert.

Graduation markers must be **observable + bounded + reversible**: "3 consecutive PRs land a stats decision without `/codex consult`" beats "feel confident with stats."

---

## Workflow — what the skill actually does

When invoked (via `/retrospective`, `/reflect`, `/growth-review`, or keyword triggers like "what are my biggest gaps", "review my growth", "我哪些 gap"):

1. **Scan signal sources** — run `scripts/scan_git_signals.sh` + `scripts/scan_chat_signals.py`, or do equivalent manual extraction with `git log` / `gh issue list`.
2. **Categorize by growth category × tier** — explicit sweep across all 5 categories (mandatory in v2 — the default bias is to over-index on category 1).
3. **Update both storage layers** — including a mandatory **demotion check** on every existing Tier 1/2 item: does the graduation marker still hold? **Incremental discipline**: if files were updated since the last retro, prefer append-only over in-place edits.
4. **Generate the learning journey** — 2-3 actions per Tier 1/2 item + graduation marker.
5. **Surface the gap-shrinking signal** — items graduated, items stuck, new items, velocity delta. One paragraph; not a dissertation.

Two modes:
- **Incremental** (default for milestone / session-end triggers): scan only the delta. ≤ 5 minutes.
- **Full** (default for explicit slash commands or first-time setup): scan entire history. ≤ 20 minutes.

---

## Cross-agent compatibility

Three agents, one source-of-truth file layout:

```
~/.claude/skills/growth-retrospective/       ← canonical (Claude Code)
~/.agents/skills/growth-retrospective        → symlink (generic agent-neutral)
~/.codex/skills/growth-retrospective         → symlink (OpenAI Codex CLI)
~/.gemini/antigravity/skills/growth-retrospective  → symlink (Google Antigravity)
```

All three agents read the same `SKILL.md` (YAML frontmatter + Markdown body — the [agensi.io open standard](https://www.agensi.io/learn/skill-md-specification-open-standard) all of Claude / Codex / Antigravity converged on).

Per-agent **storage paths** differ because each agent has its own auto-load convention — see the "Where the short index lives — pick by host agent" section in `SKILL.md`. The skill detects which host is running it and writes to the right path.

---

## Installation

Currently three install paths, depending on which agent(s) you use:

### Claude Code

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git ~/.claude/skills/growth-retrospective
```

The skill is auto-discovered on next session start. Trigger with `/retrospective`, `/reflect`, `/growth-review`, or keyword phrases.

### OpenAI Codex CLI

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git ~/.codex/skills/growth-retrospective
```

### Google Antigravity

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git ~/.gemini/antigravity/skills/growth-retrospective
```

### All three at once (symlink approach)

```bash
git clone https://github.com/YoungApple/growth-retrospective-skill.git ~/.claude/skills/growth-retrospective
ln -s ~/.claude/skills/growth-retrospective ~/.codex/skills/growth-retrospective
mkdir -p ~/.gemini/antigravity/skills
ln -s ~/.claude/skills/growth-retrospective ~/.gemini/antigravity/skills/growth-retrospective
ln -s ~/.claude/skills/growth-retrospective ~/.agents/skills/growth-retrospective
```

---

## Examples

A real worked example is at [`references/examples.md`](references/examples.md) — the `squishy-platypus` project (voice-first memory companion, iOS + Node.js + Supabase). Shows what the short index and detailed reference look like after a month of accumulated signals: 5 Tier 1/2 items, 2 Tier 3 items, decision-velocity signals cited with specific PR / ADR numbers.

---

## Design rationale (why it's built this way)

### Why three layers instead of one big file

The short index loads into **every chat** — token cost matters. The detailed reference can be ~12 KB without penalty because it's only read on demand. The optional `growth/` operational logbook is for sprint-driven projects where weekly retros are too slow — daily / decision-by-decision capture, with signals escalating up to the tier system.

Three layers means token discipline + epistemic discipline + operational discipline can all be optimized separately.

### Why decision velocity instead of self-reported confidence

Self-reports are noisy. A user who says "I'm comfortable with eval methodology" but spent 5 review rounds writing the framework over a week is operating in a learning zone, not an applying zone — and the doc-rounds count is harder to fake than the self-report. Hence the skill grounds tier assignment in **observable artifacts**: ADR count, review round count, reversal events, side-chat question particles.

### Why five categories instead of just "domain knowledge"

Iteration-1 evals revealed that without an explicit 5-category sweep, the default bias is to surface only technical concepts — missing the work habits, meta-cognitive patterns, and productivity rhythms that often have higher leverage. v2 added a mandatory sweep at Step 2 so subagents must actively consider all five.

### Why anti-signals matter

"User keeps having to tell Claude to use Chinese" is **not** a growth gap — it's a tool / memory loading issue. Without explicit anti-signals, the skill would happily pad the growth log with "user is learning to communicate in Chinese" entries that pollute the signal source. Anti-signal taxonomy keeps the log honest.

### Why graduation markers must be observable and bounded

If a Tier 1 item never graduates, the skill is just a complaint board. The graduation marker creates a check: when satisfied, the item moves to Tier 3 and stops claiming attention; if it ever fails again, the item bumps back up. The marker is the mechanism for the "gaps should shrink and not recur" promise.

### Why epistemic discipline > production-ready scaffolding

The fresh-project eval revealed a key tradeoff. Without skill guidance, an LLM agent will happily extrapolate from a project spec to a full retro scaffold — but that scaffold is **invented from ambition, not evidence**. The skill's first-run mode produces a smaller, more honest artifact: a watchlist of 8 candidate domains across 5 categories, each with what to watch for and what would promote it to a tier. Slower initial throughput, much lower hallucination risk.

---

## Iteration journey

Built with the Anthropic [skill-creator](https://github.com/anthropics/anthropic-skills) workflow:

**v1 (iteration-1)** — baseline. 4 evals × 2 configs (with skill / baseline) on a real project (`squishy-platypus`). Skill passed core assertions; surfaced 3 defects:
1. Language rules forgotten when generating chat replies (4-character Chinese gloss rule missed)
2. 5-category coverage implicit, not enforced — baselines also missed it
3. Demotion was accidental, not deliberate

**v2 (iteration-2)** — fixes applied. 4 re-runs + 1 new fresh-project eval × 2 configs. All 3 v1 defects PASS. **v2 is 19% cheaper and 31% faster than v1** because clearer instructions converge faster.

Six v3 candidates were captured during iteration-2 — none blocking. See `evals/` for raw test cases and `iteration-2/benchmark.md` (not in this repo; in the local workspace).

---

## What this skill is NOT

Things the skill explicitly avoids:

- **Tracking expertise** — only gaps. If you're fluent in a domain, it doesn't belong in the log.
- **Vague items** — "Be a better engineer" is not a tracked item. "Land 3 stats PRs without `/codex` consult" is.
- **Inspirational content** — no "you got this!" headers, no journey-of-a-thousand-steps framing. Terse and signal-dense.
- **Running on every session** — proactive trigger fires at most once per session, only if ≥ 30 turns of substantive work.
- **Padding from spec ambition** — Day-1 / first-run produces a watchlist of *candidates*, not invented Tier entries.
- **Violating user's communication memory** — if you have `feedback_complete_sentences.md` or `user_language_preference.md` memories, the skill's chat output must satisfy them. The value-add never costs the user the language discipline they've trained.

---

## File layout

```
.
├── SKILL.md                    # Main skill body (read first)
├── README.md                   # This file
├── references/
│   ├── signal_taxonomy.md      # Strong/medium/weak/anti-signal classification
│   ├── growth_categories.md    # 5 categories with examples + cross-category interactions
│   ├── learning_journey.md     # How to write effective level-up actions + graduation markers
│   └── examples.md             # Real worked example (squishy-platypus)
├── assets/
│   └── templates/
│       ├── short_index.md      # Template for memory-loaded short index
│       └── detailed_reference.md  # Template for repo-side detailed reference
├── scripts/
│   ├── scan_git_signals.sh     # Auto-extract ADRs, review rounds, reversals, stacked PRs
│   └── scan_chat_signals.py    # Auto-extract chat question particles, topic frequency
└── evals/
    └── evals.json              # Test prompts used to validate the skill
```

---

## Standalone references (Gists you can read without installing)

These extract pieces of the skill that are useful even if you don't use the skill itself:

- [**Decision-velocity signals — a taxonomy**](https://gist.github.com/YoungApple/6e78359aa86b9d47f9c39ed54d7b92e4) — strong / medium / weak / anti-signals for grounding tier assignment in observable artifacts (not self-reports). For solo devs who want the thinking tool without the skill.
- [**Anti-busywork forcing function — a design pattern**](https://gist.github.com/YoungApple/cdb12fc27dbd3ff0c35c93fff3b5986f) — the 4-step mechanism for retro/log/tracking tools that prevents item pile-up. For tool builders considering a similar gate in their own tools.

## License

MIT — see [LICENSE](LICENSE).

---

## Contributing

PRs welcome. If you use this skill on a real project, the most useful contribution is a worked example added to `references/examples.md` — what categories surfaced, what level-up actions you took, what graduated, what reversed.

If you've added support for an additional agent platform (Cursor, Aider, etc.), open an issue with the symlink path convention and we'll update the install instructions.
