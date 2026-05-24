# Learning journeys — how to write level-up actions that actually fire

The "How to level up" section in each detailed-reference entry is where this skill earns its keep. Bad level-up actions are aspirations that never happen. Good ones are concrete enough that the user can do them this week.

## Three rules for level-up actions

### Rule 1 — Doable in ≤4 hours of focused work

If an action takes longer, decompose it.

- ❌ "Become better at statistics."
- ❌ "Master Bayesian inference."
- ✅ "Write `backend/evals/STATS-CHEATSHEET.md` — one page, three concepts, one example each."
- ✅ "Add `pnpm eval --explain-stats` flag that prints a plain-language verdict."

The cost is calibrated against what a focused half-day can produce. If the action requires a multi-week study plan, break it into the first concrete artifact.

### Rule 2 — Produces an artifact, not "reads more"

Reading rarely shrinks gaps; producing does. Every level-up action should result in something committable, runnable, or postable.

- ❌ "Read the Langfuse docs."
- ❌ "Study the LiveKit data channel protocol."
- ✅ "Write a one-page eval cheatsheet citing 3 specific examples from `dataset-baseline-v1`."
- ✅ "Build a `gemini:probe` CLI script that smoke-tests all 4 buckets in 5 seconds."
- ✅ "Generate `docs/entity-erd.md` from the Supabase schema."

Exception: for Tier 2 items in "passive mode" (decided, paused, awaiting a trigger), the action is often "set up the trigger" rather than "produce knowledge." That's fine — but the trigger setup itself is an artifact (a GH milestone, a `docs/triggers.md` entry, a calendar reminder).

### Rule 3 — Externalizes the practice

The level-up action should make the right behavior easier to do, not require willpower. Build a script, add a template, set an alert. The user shouldn't have to remember to do the right thing — the artifact should make the right thing happen.

- ❌ "Remember to check the Gemini billing dashboard weekly."
- ✅ "Set budget alert at 70% / 90% in each Google project console → email to user."
- ❌ "Be more careful about silent error handling."
- ✅ "Add a `[silent-fail]` lint rule that catches catch-blocks without re-raise or logging."

## Graduation markers — what "done" looks like

Every Tier 1 and Tier 2 item gets a **graduation marker**: a concrete, observable condition that says "this item can move to Tier 3."

### Rules for graduation markers

1. **Observable, not subjective.**
   - ❌ "Feel confident with eval statistics."
   - ✅ "3 consecutive PRs land a stats decision without `/codex consult` or `/plan-eng-review`."
2. **Bounded in time or count, not open-ended.**
   - ❌ "Eventually settle the entity taxonomy."
   - ✅ "2 consecutive sprints with no new entity type added and no taxonomy ADR."
3. **Reversible — if the marker stops holding, the item bounces back.**
   - ✅ "3 months with zero 429 incidents" — if a 429 happens at month 4, item bumps back to Tier 1.
4. **Measurable from existing artifacts** (git log, gh issue list, eval results) when possible. Self-report works but is weaker.

### Marker patterns by category

| Category | Marker template |
|---|---|
| Domain knowledge | "N PRs landed without consulting external reference / second opinion." |
| Human skill | "Pattern executed correctly across M unrelated situations." |
| Work habit | "T weeks of consistent practice without lapse, even under stress." |
| Meta-cognition | "Pattern named + guardrail in place + 1 documented catch (the guardrail fired, user didn't fall into trap)." |
| Productivity / focus | "Schedule restructured + measured improvement (e.g. higher commit quality during identified peak hours)." |

## The "shrinking gap" property

The skill's promise is that **the same gap should not be re-discovered next quarter, and over time gaps should be smaller and shorter-lived.** Level-up actions and graduation markers are the mechanism.

A gap shrinks when:
- The level-up artifact externalizes the knowledge (cheatsheet, script, alert) so the user doesn't need to re-derive it.
- The graduation marker creates a check: if the marker stops holding, the user catches it early instead of rediscovering the gap from scratch.

A gap re-emerges when:
- The artifact bit-rots (script broke, cheatsheet outdated) and no one notices.
- The graduation marker was too lax (e.g., "feel confident") so the demotion to Tier 3 was premature.
- A real change in the territory (new vendor, new model, new architecture) invalidates the old understanding.

When a gap re-emerges, the retrospective should NOTE this as a meta-signal:
- The artifact needs rebuild.
- The marker needs tightening.
- The new territory is a fresh Tier 1 item, not a regression of the old one.

## When the user resists level-up actions

If a level-up action keeps getting postponed across multiple retrospective passes, that's data:

- **Maybe the action is too big** — decompose further.
- **Maybe the action is wrong** — the artifact won't actually help; rethink.
- **Maybe the item should not be Tier 1** — if it's stalled without harm, maybe it's actually Tier 2 (decided, passive) and the action shouldn't fire.
- **Maybe there's a meta-pattern** — the user consistently postpones actions in one category (e.g. always skips habit-formation work). Add to meta-cognition.

Don't nag. Surface the pattern at the next retrospective and let the user decide.

## Tier 3 items — what to keep

Once an item graduates to Tier 3, the detailed reference entry shrinks to 2 lines:

```
### iOS release pipeline (Fastlane + TestFlight)
Concepts: xcargs-in-memory build numbers, ASC API auth, co-deploy backend-before-iOS.
Signal: settled since ADR-0006/0007; no controversy on release-script changes.
```

Drop the level-up section. Drop the graduation marker (already met). Keep just enough that if the marker reverses (next 429 incident, next release-script controversy), the entry can be re-expanded.

In the short index, Tier 3 items can be dropped entirely if completely settled, or kept as a one-liner if they're worth remembering as "I have this skill now."
