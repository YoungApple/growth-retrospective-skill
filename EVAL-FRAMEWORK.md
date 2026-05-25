# How to eval growth-retrospective skill quality

Draft framework — 4 layers of quality, each measurable.

## Layer 1: Output quality (single-invocation)

What we already measure with iteration-1/2 evals.

| Metric | How | Status |
|---|---|---|
| 5-category coverage | Auditable `category_coverage.md` per eval run | v2 PASS |
| Demotion check ran | Auditable `demotion_audit.md` per eval run | v2 PASS |
| Language-rule compliance | Auditable `language_check.md` (4-char gloss + complete sentences) | v2 PASS |
| Anti-pattern refusal | Boolean check on `decision.md` | v2 PASS |
| Token cost | timing.json | v2 75K avg (−19% vs v1) |
| Wall time | timing.json | v2 258s avg (−31% vs v1) |

**Verdict**: this layer is solid. We know skill produces correct outputs.

## Layer 2: Acceptance quality (would users adopt it?)

The Layer 1 evals don't tell us this. **This is what the persona interviews measure.**

| Metric | How | Status |
|---|---|---|
| First-impression survival rate | Persona report: did they keep reading past line 50 of README? | Pending |
| SKILL.md glaze rate | Where did the persona's eyes glaze? | Pending |
| Bail point | What specific concept made them close the tab? | Pending |
| Random-Tuesday adoption | Would they actually type `/retrospective` on a random Tuesday? | Pending |
| Stickiness (2nd-run rate) | Of users who used once, % who use again within 30 days | Needs telemetry |
| Diminishing returns curve | Does retro #5 still produce new signal, or busywork? | Needs longitudinal data |

**Verdict**: this layer is unverified. The persona simulation is the cheapest proxy we can run *today*.

## Layer 3: Outcome quality (does it actually help?)

The deepest layer. Does the skill produce the promised "gap shrinking" outcome?

| Metric | How | Difficulty |
|---|---|---|
| **Gap shrinkage** | Average time a domain stays in Tier 1 before demoting to Tier 3 | Hard — needs 3+ months of usage |
| **Same-gap recurrence rate** | % of Tier 3 items that bump back to Tier 1 within 6 months | Hard — same |
| **Action conversion rate** | % of level-up actions completed within their stated effort window | Medium — auditable by greppging `git log` for the cheatsheet / script the action mandated |
| **Surprise rate** | When skill surfaces a Tier 1 item, % of cases where user reacts "I didn't realize this was a gap" vs "I knew" | Medium — needs user-facing thumbs-up/down on each surfaced item |
| **Decision velocity delta** | Same-domain decision: how many review rounds before skill vs after using it for N months | Hard — needs the user to instrument timings (a level-up action the skill already proposes) |

**Verdict**: this layer is the real promise. We have ZERO data on it. The skill itself proposes `docs/decision-timings.md` as the instrumentation — eating its own dog food.

## Layer 4: Cost quality (overhead vs value)

| Metric | Current | Target |
|---|---|---|
| Time to first useful output (Day-0) | ~14 min on `squishy-platypus` (eval-1 v1 first-time) | <5 min |
| Token cost per incremental retro | ~65K (eval-2 v2) | <30K |
| Storage maintenance load | 3 files to keep in sync | Should be 0 — automate sync |
| Mental model entry cost | 240-line SKILL.md to grok | <100 lines |
| Required CLI tools | `git` + `gh` + `jq` + Python 3 + bash | `git` only (rest optional) |

## Recommendation: a quality eval rollout

To eval quality holistically — not just one-shot output — we need:

1. **Layer 1 (output) — keep current evals.** They protect against regression. Don't change.
2. **Layer 2 (acceptance) — run persona interviews quarterly.** Cheap proxy for real users until the repo gets actual users.
3. **Layer 3 (outcome) — add 3 numeric trackers to the skill itself**:
   - `growth-retrospective-stats.json` at the skill root, updated each invocation with: items demoted this run, items bumped up, actions completed since last run, surprise count.
   - User adds a one-line `--surprise` / `--known` flag when accepting / rejecting surfaced items.
   - At 90 days of usage, the skill produces an "is this working?" self-report.
4. **Layer 4 (cost) — set hard budget gates in SKILL.md**:
   - "If incremental retro >10 minutes, you're holding the skill wrong — open an issue."
   - "If SKILL.md grows past 150 lines, refactor or split."
   - Make these visible.

## The honest test

The skill is high quality iff: **a stranger installs it today, uses it once, comes back next week, and after 3 months says "I make X-shaped decisions noticeably faster than before."**

We can't measure that until the repo has strangers. Until then, the persona interviews + Layer 1 evals are our best proxy.

The trap is using Layer 1 success (output looks good) as evidence of Layer 3 success (outcome is real). They're correlated but not the same.
