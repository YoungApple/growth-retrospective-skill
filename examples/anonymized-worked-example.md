# Worked example — anonymized real project

Real data from a 5-week-old solo-dev project (anonymized: project name → "Project A", a voice-first memory product). Project age at baseline: 12 days · 138 commits · 1685 user chat messages across 7 sessions · 15 ADRs.

This is what the skill produced after one full retrospective pass. Numbers are real; nouns are sanitized.

---

## Tier 1 — high challenge

### Eval methodology + statistical rigor *[domain knowledge]*

**Signal.** 5 sequential review rounds (review-round-2 through 5) + 482-line framework audit + separate mechanism audit. The most-reviewed topic across the whole project — no other domain reaches this volume.

**Concepts the user was actively learning.**
- **McNemar paired test** — paired binary outcomes between two model runs on the same eval set
- **Wilson confidence interval** — small-sample binomial CI tighter than normal-approximation
- **Multi-seed evaluation** — same eval N seeds to estimate variance
- **MVFR** (self-coined Minimum Viable Fixture-Replay) — fixture-user corpus + idempotent seeder
- **Cite-on-single-pass** vs **two-pass evidence-first** answer modes
- **Gold set lock** (84q × 11 categories) vs experimental promotion path

**Status.** Framework converging; per-category regression hunts still open.

**How to level up** *(produced by the skill)*.
1. Write `STATS-CHEATSHEET.md` — one page, three concepts × one example each. Saves the 5-round-review cycle next time.
2. Add `--explain-stats` CLI flag that prints plain-language verdict ("delta statistically significant at p<0.05, n=84") after every run.
3. **Graduation marker**: 3 consecutive PRs land a stats decision without consulting an out-of-band reviewer → demote to Tier 3.

---

### Memory architecture + entity graph design *[domain knowledge]*

**Signal.** 753 lines of research across two doc versions + multi-stage taxonomy rollout across 4 sequential PRs.

**Concepts in play.** 9-type entity taxonomy · compound-mention disambiguation · contacts grounding to bound hallucination · HITL preference correction · per-session meeting-notes vs aggregated themes · raw-transcript-as-ground-truth.

**Status.** Taxonomy locked at 9 types; emotion / who / themes write-path open; one P1 wedge-blocker still open.

**Level-up** *(produced by the skill)*.
1. Generate ERD diagram from schema. Beats re-reading the taxonomy ADR every time.
2. Run per-type confusion matrix on the gold set. The top off-diagonal cell tells you which grounding source is missing next.
3. **Graduation marker**: 2 consecutive sprints with no new entity type added and no taxonomy ADR → schema is stable.

---

### Decision-making speed under uncertainty *[human skill]*

**Signal.** User's own north star. Two recent events show it's still calibrating:
- **Incident 1** (vendor quota incident): user mid-incident probed "429 means rate too high. Is there a bug?" — wrong working hypothesis (was actually budget cap), required dashboard inspection before deciding. Decision speed limited by **domain knowledge**, not lack of process.
- **Incident 2** (UTC default fix): user pushed back on a 4-part over-engineered fix proposal, surfaced a simpler 1-step iOS fix. Decision was fast, but the fact that a 4-part proposal was on the table is itself the signal.

**Concepts in play.** Decision reversal as highest-information signal · pre-merge review gate · evidence-falsified challenge · out-of-band second opinion.

**Status.** Decisions vary in speed by domain — fast on UX (expertise), slow on stats / infra (learning).

**Level-up** *(produced by the skill)*.
1. Track per-decision timing on Tier 1 domains for one sprint. Log start-time and end-time. Two weeks of data shows whether velocity is improving.
2. Monthly retrospective on the timings ledger: which decisions took >24h, which took <1h, where's the gap?
3. **Graduation marker**: median time-to-decision on a Tier 1 domain drops 50% over 2 months AND no decision-reversal events in that window → graduation.

---

### Naming patterns from incidents *[meta-cognition]*

**Signal.** Three new principle-naming memories created in a single day: `feedback_adr_pressure_test`, `feedback_adr_cadence_smell`, `feedback_dont_overengineer_bootstrap`. The user is actively converting individual frustrations into reusable rules — but only when they explicitly stop and say "name this."

**Status.** Pattern-naming active and accelerating; no graduation marker yet. Risk: the cycle stays ad-hoc — naming happens when the user thinks to do it, not on a schedule.

**Level-up** *(produced by the skill)*.
1. Session-end checklist hook: at session close, ask "any patterns named today? File a feedback memory NOW or note why not."
2. Write `principles.md` — one-page index of all named patterns, read at session start.
3. **Graduation marker**: 3 consecutive weeks with at least one new principle named via the hook (not ad-hoc) AND zero "should have named this earlier" regrets → demote to Tier 2.

---

## Tier 2 — medium challenge (reversed or evidence-tested)

- **Multi-tenant API quota isolation** *[domain]* — vendor budget caps, 429 quota-vs-rate distinction, 4-bucket env split (LIVE/TTS/BATCH/EVAL). Status: shipped, incident-validated.
- **Voice resilience + state machine** *[domain]* — error envelope protocol, silence watchdog, cross-component error binding. Status: error channel shipped; ADR spec vs impl drift on watchdog arm-point surfaced same-day.
- **Observability tooling decision** *[domain]* — vendor landscape (3 alternatives) evaluated, **reversed same-day** via pre-merge review, reissued as self-hosted. Status: decided, passive until ~1000 sessions/mo.
- **ADR ↔ PR-split granularity** *[work habit]* — pattern visible: 3 of last 4 PRs needed a follow-up max-effort review pass. Status: pattern named, not yet automated.
- **Complete-sentence chat communication** *[human skill]* — naming rule: each sentence has grammatical spine in ONE language; embedded terms OK as nouns, not load-bearing connectives.

---

## Tier 3 — settled (applying not learning)

- iOS release pipeline (Fastlane + TestFlight) — stable since early ADRs.
- DB DDL via Management PAT — documented, settled.
- Commit hygiene + agent-friendly PR labels — pattern stable across 30 recent PRs.

---

## Productivity baseline — observed, not tracked yet

12 days · 138 commits · pattern:
- **Bimodal work windows** (local time): 01:00–05:00 + 11:00–19:00. Evenings reliably quiet.
- **Burst cadence**: 50-commit days alternating with 0–3-commit days.
- **Friday / Saturday peak chat activity** — consistent with the user being employed full-time, building solo on weekends.
- **Long rolling sessions**: 5 of 7 sessions are 13–43h multi-day threads.

Not Tier 1/2 yet — user hasn't stated whether bimodal split is intentional.

---

## What the skill actually changed in 12 days

- **5 Tier 1/2 items have explicit graduation markers** instead of vague "get better at this" statements
- **2 items moved to Tier 3** via objective marker (iOS release + DB DDL) instead of vibes
- **The user noticed a productivity rhythm** (bimodal + Friday/Saturday peak) they hadn't named before
- **Cross-category interaction**: stats decisions are slow AND the user works statistical problems late at night AND late-night decisions reverse more often. None of the three observations was visible in isolation — the 5-category sweep made the pattern legible.

This is what one pass produced. The next pass (incremental, after 2 PRs) cost ~$0.30 and 5 minutes.
