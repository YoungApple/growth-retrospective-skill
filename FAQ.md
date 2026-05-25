# FAQ

Frequently-asked-things compiled from persona reviews + actual reviewer feedback. Read top-down; the most common rejections are at the top.

## "Isn't this just another self-improvement framework?"

That's the natural first reaction; this kind of tool has been over-promised for 20 years. Three structural differences worth checking before you bounce:

1. **Tier assignment is grounded in observable git/chat signals**, not self-reports. "I'm uncertain about stats" doesn't matter; "you wrote 5 sequential review rounds on the stats framework" does.
2. **Graduation markers are required**. Every Tier 1/2 item has an observable, time-bounded exit condition. Items leave the list. The point is the list shrinks.
3. **Step 0 Action Audit refuses to run a new scan if old commitments are untouched**. Skill pushes back instead of adding more items.

If any of those three sound interesting, give it 5 minutes. If they sound like jargon, this isn't for you — and that's a useful signal too.

## "Why 5 categories? Isn't 5 too many?"

Skeptical-engineer-persona feedback said this directly. Honest answer: 5 is debatable; 1 is definitely too few.

Most learning logs only track category 1 (technical concepts). The skill argues you compound by tracking work habits + meta-cognitive patterns + productivity rhythm together. Real dogfood data on the creator's project surfaced a cross-category insight that wouldn't have been visible in a 1-category sweep: *"stats decisions are slow AND happen at 1am AND late-night decisions reverse more often."*

That said: in v2.5, the 5-category sweep is **mandatory in full mode but optional in incremental mode**. So per-PR retro doesn't have to audit all 5. Only the weekly full retro does.

If after using it for 2-3 weeks you still find the 5-category sweep is theatre, [open an issue](https://github.com/YoungApple/growth-retrospective-skill/issues/new?template=bug.md). Real data > my theory.

## "Why three storage layers? Sounds like over-engineering."

Persona feedback flagged this too. Honest defense:

- **Short index in memory** loads automatically every chat — but has a hard ~80-line budget so token cost stays low
- **Detailed reference in `docs/`** is the source of truth for tier assignment — grep'd on demand
- **Optional `growth/` operational logbook** is only for sprint-driven projects with daily/weekly capture cadence

For 95% of users, you use the first two and ignore the third. The skill defaults to 2 layers; `growth/` is opt-in.

If you want a one-file version, the lean redesign proposal in [the CEO review notes](https://github.com/YoungApple/growth-retrospective-skill/issues) is exactly that. Open an issue if you want to drive that direction.

## "How is this different from /retro, /learn, or claude-mem?"

Read the [README "What's different" table](README.md#whats-different-from-other-retro--learning-log-tools) for the side-by-side.

Short version: the genuinely novel part is **graduation markers**. The other tools track items; this one tracks items *with exit criteria*. They could absolutely add that, and I'd be thrilled if they did — but as of 2026-05, none has.

The other differentiator is **cross-agent compatibility via the agensi.io SKILL.md open standard** — same skill in Claude Code, Codex CLI, and Antigravity. The other tools are Claude-only.

## "Does it work without git history or chat archive?"

Yes, but it gives weaker output. The bundled scripts (`scan_git_signals.sh`, `scan_chat_signals.py`) are accelerants, not requirements. Without them, the skill falls back to direct chat conversation: "what have you been working on lately? what felt hard?" The output is shaped the same way (tier + graduation marker), just less evidence-grounded.

Day-1 / fresh project: the skill produces a **watchlist** (candidates to monitor) instead of inventing Tier 1 items from spec ambition. See `examples/anonymized-worked-example.md`'s "What this skill is NOT" section.

## "What if I don't use the Claude Code memory system?"

The short index path is configurable. Default is `~/.claude/projects/<id>/memory/learning_domains.md`, but if you write to `<repo>/.growth-log/short-index.md` instead, that works too — you lose the auto-load convenience but keep everything else. See [SKILL.md](SKILL.md) "Where the short index lives — pick by host agent" for paths per agent.

## "Does the forcing function get annoying?"

Possible. It's designed to push back if you have ≥3 actions pending >14 days AND 0 completed since last run. If you're shipping fast but on a different axis from the proposed actions (e.g., you decided the actions don't matter anymore), the push-back option **B (Deprioritize)** is the right choice — explicitly kill the actions. The skill removes them from the log. New retro proceeds.

If you find yourself always using option **C (Override)**, that's a signal the skill is mis-tiering your gaps. [Open a bug](https://github.com/YoungApple/growth-retrospective-skill/issues/new?template=bug.md).

## "I tried it once and the second run looked identical. Is this thing broken?"

No, that's exactly the situation Step 0 was added for. If between run #1 and run #2 you didn't complete any level-up action, run #2 *should* look the same — there's no new evidence to update against. v2.5's forcing function will push back on this and refuse to add new items. Previously (v2 and earlier) the skill would happily generate a new round of items on top of the old ones — that's the "busywork retro" failure mode persona-2 simulation flagged.

## "How do I know if it's actually helping me?"

That's the [Layer 3 question](EVAL-FRAMEWORK.md), and the honest answer is: you'll know in 3 months. The skill ships a quality framework so you can verify with data rather than vibes. Specifically:

- Are old Tier 1 items actually graduating to Tier 3? (Not just being deferred.)
- Are similar gaps recurring on the next project, or actually staying closed?
- Has your median time-to-decision on a previously-Tier-1 domain dropped?

If after 3 months the answer to all three is "no," delete the skill. It's not for you, or it's not for you yet.

## "I built something in the same space — let's compare."

Yes please. Open an issue or PR with a comparison table. Specifically interested in tools that already have something like graduation markers — they exist (mostly in productivity-coaching apps), but I haven't found a developer-tooling equivalent. If you know of one, I want to read it before defending my approach.

## "Can I use this on a team / shared codebase?"

The skill is designed for solo developers (or "team of one with AI augmentation"). On a shared codebase, the signals get noisier — multi-round review docs might mean the team is learning, not you. The growth log conflates individual + team learning.

A team adaptation would be useful but not yet built. [Open an issue](https://github.com/YoungApple/growth-retrospective-skill/issues/new) if you have a use case and we can scope it.

## "How do I uninstall?"

```bash
rm -rf ~/.claude/skills/growth-retrospective
rm -f ~/.codex/skills/growth-retrospective
rm -f ~/.gemini/antigravity/skills/growth-retrospective
rm -f ~/.agents/skills/growth-retrospective
```

Your growth log files (`docs/learning-domains.md` etc.) stay on disk — they're your artifacts, not the skill's.

## Anything else?

Open an issue or DM. The skill is brand new and the FAQ will grow as questions surface.
