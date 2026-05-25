# Worked example — fresh project (Day 1, no signals yet)

The skill's hardest test case: a brand-new project with **zero git history, zero chat archive, zero ADRs**. What does it produce?

This is real data from a 5-week sprint project (anonymized: "Project B", a content product with a 5-week build → operate cycle). Day-1 setup, 1 commit. Same evaluator (the skill) that produced [the 12-day worked example](anonymized-worked-example.md) was given the fresh project instead.

## The trap to avoid

The default LLM behavior on "set up a growth log for this new project" is to **extrapolate from the project spec** and invent Tier 1 items based on the user's stated ambitions:

> *"You're building a content product, so add 'content velocity' to Tier 1. You mentioned monetization, so 'payment integration' goes Tier 2..."*

This is wrong. Tier 1 means "evidence shows this is hard *for this user, right now*." On Day 1 there's no evidence either way. Inventing tiers from spec ambition produces a false retrospective.

The skill's signal taxonomy explicitly forbids this:

> "Strong signals are execution artifacts (reversals, multi-round reviews, ADRs), not spec ambition."

## What the skill actually produces on Day 1

Empty tiers + a **watchlist** of candidates.

```markdown
**Baseline: 2026-05-24 (Day 1 — scaffolding only, no signals yet).**

This project has 1 commit, no chat archive, no ADRs. The growth log
is **pre-baselined** — entries are watchlist candidates, not confirmed
gaps. Real tiers populate after week 1 of execution.

## Tier 1 — high challenge
_(empty — no Tier 1 evidence yet. Re-scan at end of week 1.)_

## Tier 2 — medium challenge (reversed or evidence-tested)
_(empty — no decisions taken yet.)_

## Tier 3 — settled (mostly applying not learning)
_(empty.)_

## Watchlist — candidates to confirm in weeks 1-4

From product spec the user is taking on these domains. Each may
land in Tier 1 / 2 once execution surfaces evidence. Do NOT add to
tiers without a strong/medium signal.

- **Candidate A** — Platform-specific compliance and review process
- **Candidate B** — Viral share-card design (conversion funnel, cold start)
- **Candidate C** — Multi-persona AI prompt engineering (character voice consistency)
- **Candidate D** — Subscription + payment integration (SKU design, refund flow, compliance)
- ...(4 more candidates from the spec, all 5 categories represented)
```

Notice what's NOT here:
- ❌ No fabricated Tier 1 entries based on spec
- ❌ No graduation markers on Day 1 (you can't measure exit when there's no entry yet)
- ❌ No level-up actions (you can't act on a gap that isn't proven)

What IS here:
- ✅ Empty tiers (honest)
- ✅ Watchlist with category-tagged candidates (each maps to one of the 5 categories)
- ✅ Promotion criteria — what would push a watchlist item to Tier 1/2

## Why this matters

This is what makes the skill different from a "fill out this template" framework. A template would force you to put SOMETHING in Tier 1 on Day 1. The skill refuses, because the whole credibility of the tier system rests on tiers being signal-grounded.

In persona-3 review (power user with `/retro` + `/learn` + `claude-mem` + `nessie`), the fresh-project handling was identified as a real differentiator:

> *"This was the test of whether the tool is rigorous or LARP-y. Other tools would happily generate a 'growth plan' from the spec. This one refuses, and that refusal is the value."*

## What happens at week 1

After 7 days of execution, the user re-runs `/retrospective`. The skill scans:

- New commits (probably 20-50 on a sprint project)
- New chat archive (probably 1-3 sessions)
- New ADRs / decisions

For each watchlist candidate, check: is there strong/medium signal yet?

- **Compliance candidate** → maybe an ADR landed about how to handle review feedback. Promote to Tier 2.
- **Share-card candidate** → if 3 revisions on the card design = multi-round signal. Tier 1.
- **AI persona candidate** → if not touched yet, stays on watchlist.
- **Payment candidate** → if deferred past sprint, mark "deferred to v2", not "Tier 1."

The growth log starts populating from evidence as it accumulates. By week 4, you have a real tier table you can defend with `git log` evidence.

## The operational logbook (optional layer 3)

For sprint-driven projects like this one, the skill recommends adding a `growth/` directory with daily / weekly capture subdirs. This is NOT mandatory — the default 2-layer (memory + `docs/`) is enough. But on a 5-week sprint with daily go/no-go decisions, the optional logbook helps:

- `growth/daily-signals/2026-05-25.md` — 2-minute capture of decisions made / surprises
- `growth/weekly-retros/week-1-cold-start.md` — 15-minute structured retro at each go/no-go checkpoint
- `growth/decisions/{slug}.md` — lightweight ADR-like records, written only when a decision gets reversed

The Day-1 output for this project included a watchlist + the `growth/` scaffold. After week 1, those captures feed evidence back into the tier system.

## Cost

Day-1 baseline pass on Project B: 1 LLM run, ~$0.15, 3 minutes. Output: 1 short-index file + 1 detailed reference + 1 watchlist + 4 logbook templates.

Compare to the Day-1 mistake mode (invent tiers from spec): same cost, but produces a confidence trap that takes weeks to unwind.

## What contributors can add

If you have a fresh project and want to add a worked example: clone the format from this file, anonymize project-specific nouns, keep the watchlist categories and candidate counts exact. Use the [worked-example issue template](https://github.com/YoungApple/growth-retrospective-skill/issues/new?template=worked-example.md).

The most useful contribution: come back at week 4 and add an "update log" showing which watchlist items promoted to Tier 1/2, which stayed on watchlist, which were dropped. That's the Layer 3 outcome data the skill's "shrinking gap" claim depends on.
