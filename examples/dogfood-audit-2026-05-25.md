# Dogfood audit — running the skill on its own creator's project

This is **real Layer 3 evidence**, not a simulation. Project name anonymized to "Project A" — everything else is verbatim from a `git log` + filesystem check on 2026-05-25.

## Setup

- Project age: ~5 weeks (first commit 2026-04-22)
- Active development phase: last 14 days
- Existing growth log: `docs/learning-domains.md` (251 lines, last updated 2026-05-24)
- Skill version under test: v0.2.0 (Step 0 Action Audit just shipped)

## What Step 0 found

Extracted every `How to level up` action from the existing growth log. 11 actions across Tier 1/2 items.

Then checked the filesystem.

```
ACTION                                                | STATUS  | DAYS SINCE PROPOSED
──────────────────────────────────────────────────────|─────────|────────────────────
Write backend/evals/STATS-CHEATSHEET.md               | ❌      | 1
Generate docs/entity-erd.md (or .mermaid)             | ❌      | 1
Track per-decision timing → docs/decision-timings.md  | ❌      | 1
Add session-end checklist hook                        | ❌      | 1
Write revisit trigger → docs/triggers.md              | ❌      | 1
Add proactive budget alerts in Google project console | ❌      | 1 (un-checkable)
Add Talk-tab debug overlay (DEBUG builds)             | ❌      | 1
Re-read feedback_complete_sentences.md at session start | ⚠️     | 1 (behavioral)
Add pre-proposal checklist to CLAUDE.md               | ❌      | 1
Add post-merge hook for fly deploy reminder           | ❌      | 1
One-week self-observation experiment → docs/work-log-2026-05.md | ❌ | 1
```

**Score**: 0 of 11 actions completed since proposed.

## The interesting twist

The proposed-actions list is **1 day old**. So technically Step 0's "≥14 days pending" rule doesn't fire yet. Push-back behavior would correctly hold off.

But the audit *also* surfaces something the rule alone wouldn't catch:

> *138 commits in 14 days, AND a fresh batch of 11 level-up actions just landed yesterday, AND the user has zero of the prior round's actions completed (most of the prior round's proposed actions trace back to the same retrospective the v2.5 skill is now reviewing — so the 11 are themselves the prior round.)*

This is the **chicken-egg state** the forcing function is designed for. The current Tier 1/2 entries were produced in a recent retro. None of their actions have been actioned yet. If a second retro ran today, the existing 11 actions would get re-justified without ever closing.

## What Step 0 would do correctly

Per the skill's Step 0 spec:

> If ≥3 actions pending >14 days AND 0 completed since last run, skill pushes back.

The current state is "≥3 actions pending, but only 1 day pending." The push-back is held off — which is correct. But the next retro (2026-06-08, 14 days from now) absolutely should push back if the 11 actions remain untouched.

So: **Step 0 will fire correctly at the 14-day mark, with high confidence**. The mechanism is wired right.

## What this evidence does and does NOT prove

✅ **Proves**: Step 0 reads the growth log, extracts actions, checks the filesystem, produces a clean status report. The plumbing works end-to-end on a real project.

✅ **Proves**: Without Step 0, the natural pattern is "138 commits + 11 untouched actions" — the system would happily generate retro #2 ignoring the unfinished work from retro #1. The mechanism addresses a real failure mode in this real project.

❌ **Does NOT prove**: That gaps actually shrink over months. That's the Layer 3 outcome claim, and it needs 3+ months of data.

❌ **Does NOT prove**: That users prefer the forcing function. Persona-2 simulation said yes; real users might say "stop being preachy." We need that signal.

## Single-user Layer 3 commitment

The creator is now committed to the following experiment:

- **Time horizon**: 30 days (2026-05-25 → 2026-06-24)
- **Action target**: complete ≥3 of the 11 proposed actions
- **Forcing function test**: run `/retrospective` weekly. At day 14, Step 0 should push back if <1 action completed. Verify it does. At day 30, if ≥3 actions completed, the next retro should proceed without push-back. Verify it does.
- **Output**: this file gets a new section every retro, logging what Step 0 said vs what was true.

This is a single-user Layer 3 experiment. It does not generalize. But it's better than zero data.

## Update log

*New retros append here. Each entry: date, what Step 0 said, what was true, what got actioned since last run.*

### 2026-05-25 (baseline)
- Step 0 verdict: held off push-back (only 1 day pending)
- Actions completed since last retro: 0
- New actions added: 0
- Notes: This audit is the baseline. Next check 2026-06-01.

---

## For contributors

If you have a real project with a growth log running for >2 weeks, **the most useful contribution you can make is replicating this audit format with your own data**. Anonymize project names + product specifics; keep the action count + completion status + days-since-proposed numbers exact.

Use the [worked-example issue template](https://github.com/YoungApple/growth-retrospective-skill/issues/new?template=worked-example.md) to share. Even 3-5 of these data points from different projects gives us a much better picture of whether the forcing function works in practice.
