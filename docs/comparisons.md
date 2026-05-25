# Compared to other retro / learning-log tools

If you already have `/retro`, `/learn`, `claude-mem`, or `nessie` installed, this is the honest side-by-side. Recommendations at the bottom: *when to install growth-retrospective vs when to stick with what you have*.

## The 5-category sweep

| Category | `/retro` | `/learn` | `claude-mem` | `nessie` | `growth-retrospective` |
|---|---|---|---|---|---|
| Domain knowledge | ⚠️ implicit | ✅ explicit | ✅ via memory | ✅ via context | ✅ explicit |
| Human skills (decision-making) | ⚠️ commit cadence proxies | ❌ | ❌ | ❌ | ✅ explicit |
| Work habits | ✅ commit + PR patterns | ❌ | ❌ | ❌ | ✅ explicit |
| Meta-cognition | ❌ | ❌ | ❌ | ⚠️ patterns inferred | ✅ explicit |
| Productivity / focus / energy | ⚠️ commit timestamps | ❌ | ❌ | ❌ | ✅ explicit |

`/retro` is closest on work habits but doesn't tag dimensions. The 5-category framing is genuinely novel as of 2026-05.

## Tier / priority system

| | `/retro` | `/learn` | `claude-mem` | `nessie` | `growth-retrospective` |
|---|---|---|---|---|---|
| Items have priority/tier | ⚠️ "praise vs growth" binary | ❌ flat list | ❌ flat | ❌ flat | ✅ Tier 1/2/3 |
| Signals ground the tier | ⚠️ implicit | ❌ | ❌ | ❌ | ✅ explicit (multi-round reviews, ADR reversals, etc.) |
| Items can demote | ❌ | ⚠️ via prune | ❌ | ❌ | ✅ via graduation marker |
| Items can bump back up | ❌ | ❌ | ❌ | ❌ | ✅ via signal reversal |

This is the biggest single differentiator. Other tools track learning; this one tracks learning **with explicit movement criteria**.

## Graduation markers

| | Existence | Format | Auto-checked |
|---|---|---|---|
| `/retro` | ❌ | n/a | n/a |
| `/learn` | ❌ | n/a | n/a |
| `claude-mem` | ❌ | n/a | n/a |
| `nessie` | ❌ | n/a | n/a |
| `growth-retrospective` | ✅ | Observable + bounded + reversible | ⚠️ partial — Step 0 checks proposed artifacts, not all marker types |

Example marker the others can't express: *"3 consecutive PRs land a stats decision without a `/codex` consult."* That's a domain-specific, observable, bounded condition. Other tools have no syntax for this.

## Anti-busywork mechanism

| | Mechanism | When it fires |
|---|---|---|
| `/retro` | None — runs every time | Always |
| `/learn` | Manual prune | When user notices |
| `claude-mem` | Memory consolidation | On schedule |
| `nessie` | Context decay | Time-based |
| `growth-retrospective` | **Step 0 Action Audit** | Refuses new scan if ≥3 actions pending >14d AND 0 completed |

The persona-2 simulation flagged this as the largest stickiness defect of v1 (this skill, before v2.5). Without the Action Audit, second runs look identical to first runs and the tool becomes busywork. v2.5 added it. Other tools haven't.

## Cross-agent compatibility

| | Claude Code | Codex CLI | Antigravity | Same SKILL.md |
|---|---|---|---|---|
| `/retro` (gstack) | ✅ | ❌ | ❌ | n/a |
| `/learn` (gstack) | ✅ | ❌ | ❌ | n/a |
| `claude-mem` | ✅ | ❌ | ❌ | n/a |
| `nessie` | ✅ | ❌ | ❌ | n/a |
| `growth-retrospective` | ✅ | ✅ | ✅ | Yes — agensi.io open standard |

If you use Codex CLI or Antigravity in addition to Claude Code, this is currently the only option for this category of tool.

## Storage model

| | Layers | Path defaults | Cross-machine sync |
|---|---|---|---|
| `/retro` | 1 (in-repo) | `docs/retros/` | Via git |
| `/learn` | 1 (in-repo) | configurable | Via git |
| `claude-mem` | 2 (memory + project) | `~/.claude-mem/` + ChromaDB | Via claude-mem's own sync |
| `nessie` | 1 (engine-managed) | Nessie context engine | Via Nessie |
| `growth-retrospective` | 2 default, 3 if sprint-driven | Memory + repo `docs/` + optional `growth/` | Via git for layers 2-3 |

If you already use `claude-mem` for project memory, the short-index layer in growth-retrospective is partially redundant. The detailed reference (Layer 2) and the optional logbook (Layer 3) are not.

## Cost per retro

| | Token | Wall time | One-time setup |
|---|---|---|---|
| `/retro` (gstack) | low | ~30s | gstack install |
| `/learn` (gstack) | low | <1min | gstack install |
| `claude-mem` | medium | low (passive) | claude-mem install + setup |
| `nessie` | medium | low (passive) | Nessie install + auth |
| `growth-retrospective` | ~75K (full scan) / ~30K (incremental) | ~5min (incremental) / ~15min (full) | git clone + symlinks (~30s) |

Highest cost per retro of the five, but only runs on user invocation. Not background-passive.

## When to install which

**Already running `/retro`?**
Keep it. Don't replace. Add `growth-retrospective` IF you want graduation markers or you're using Codex / Antigravity in addition to Claude Code. The two coexist — `/retro` for engineering retro patterns from git, `growth-retrospective` for the broader 5-dimensional growth log.

**Already running `/learn`?**
Different purpose. `/learn` is about project learnings (codebase quirks, gotchas). `growth-retrospective` is about *the developer's* gaps. Run both.

**Already running `claude-mem`?**
The memory short-index layer overlaps. You can configure `growth-retrospective` to write to a `<repo>/.growth-log/` directory instead of the memory dir, avoiding overlap.

**Already running `nessie`?**
Similar. Nessie tracks context; growth-retrospective tracks gaps. Coexist comfortably.

**Use Codex / Antigravity?**
`growth-retrospective` is currently the only cross-agent option for this category. The other four are Claude-only.

**Have a learning log that's grown to 30+ items and you're afraid to delete anything?**
This is the canonical install case. The graduation marker mechanism is designed for exactly this pile-up state. See [examples/anonymized-worked-example.md](../examples/anonymized-worked-example.md) for what one pass produces.

**Brand new project, no growth log anywhere?**
Day-1 mode produces a 5-category watchlist, not invented Tier-1 items. Faster install than waiting until you have 4 weeks of git history.

## Honest limitations

- **The "shrinking" claim is unvalidated** at the 3-month outcome horizon. See [EVAL-FRAMEWORK.md](../EVAL-FRAMEWORK.md) Layer 3.
- **The 5-category sweep can be overkill** for small projects with one obvious gap.
- **Step 0 Action Audit's heuristics (≥3 + 14d + 0 completed)** are reasonable defaults but not tuned against real distributions.
- **No CI integration** — must be invoked manually. PR welcome.
- **No team mode** — designed for solo devs.

If any of these are dealbreakers for your situation, one of the other four tools is probably a better fit.
