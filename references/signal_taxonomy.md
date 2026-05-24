# Signal taxonomy — how to read decision velocity

The user's own framing: **decision speed is a proxy for challenge level.** A slow decision means the user is stretching. A fast decision means they're applying expertise (good) or being reckless (bad — see "anti-signals" at the bottom).

Use this taxonomy to translate raw observations into tier assignments.

## Strong signals (Tier 1 — high challenge)

These are the most information-dense events. One of these on a topic = put it in Tier 1.

1. **Decision reversal.** A pre-merge `/plan-ceo-review` flips a spec'd plan. An ADR supersedes a recent ADR on the same topic. An issue closes as `not planned` and is reissued in a different shape. Example: Langfuse #76 → ADR-0013 Supabase reversal in one day.
2. **Multi-round review series.** `docs/<topic>-review-round{1,2,3,4,5}.md` files. 5 rounds = top of the pile. The topic was reviewed five times before the user felt confident.
3. **Multi-version research docs.** `<topic>-research.md` + `<topic>-research-v2.md`. Total line count is a rough proxy for time spent.
4. **Evidence-falsified challenge.** A subagent or reviewer challenges the plan ("fold X into Y, the split is premature"), and the user goes to check the dashboard / measure / instrument before deciding. The fact that the user couldn't dismiss the challenge from gut means the territory was unfamiliar enough to require evidence.

## Medium signals (Tier 2 — medium challenge)

One of these alone is Tier 2; combined with a strong signal, push to Tier 1.

5. **Open `wedge-blocker` issues** in a domain — there's a known unresolved problem after the main implementation landed. (Example: voice resilience shipped a 4-PR stack, but `#106 silence-watchdog loop` still open.)
6. **`needs-human` label density** — issues that `/spec-iterate` flagged as requiring taste / strategy judgment.
7. **Stacked PRs same day** (PR-A/B/C/D pattern) — focused ramp on a single domain. Speed is high, but the density of focus says "this needed concentrated learning."
8. **`code-review fixes (max-effort pass)` commits** after the main PR — first pass missed things; second / third pass caught more. Translates to "decision was incomplete on first attempt."
9. **Repeated `啥意思?` / "what does X mean" in chat on the same concept across sessions** — the user is still building the mental model.

## Weak signals (don't over-weight)

These can falsely flag — use only as tie-breakers, not primary evidence.

10. **PR open-to-merge time** — confounded by CI flakiness, reviewer availability, scope.
11. **Number of ADRs touching a topic** — naturally grows with time in well-understood areas too.
12. **File churn** — touched files counts refactors and feature work and exploration all the same.
13. **Long PR descriptions** — could be thoroughness or could be confusion. Read the description; if it's flat-out explaining the problem to themselves, that's a signal.

## Anti-signals (do NOT count as challenge)

These look like signals but mean something else.

- **User typing speed in chat** — orthogonal to topic difficulty.
- **Issues opened with `nice-to-have` label** — explicit deprioritization, not difficulty.
- **Repeated meta-instructions** ("remember to use Chinese", "use issue # prefix") — these are loading / hook problems, NOT growth gaps. Route them to a feedback memory, not the growth log.
- **Reading lots of docs** — input volume doesn't equal learning. Look for output artifacts (the user PRODUCED something) to confirm.

## How to translate signals → tier

| Signal mix | Tier |
|---|---|
| 1 strong signal (any) | Tier 1 |
| 2+ strong signals on the same topic | Tier 1, urgent |
| 1 medium signal alone | Tier 2 |
| 2+ medium signals, no strong | Tier 2 |
| Topic stable for 30 days with no new signals + active level-up actions completed | Demote to Tier 3 |
| Topic in Tier 3 + new strong signal | Bump back to Tier 1, note the reversal |

When in doubt, prefer Tier 2 over Tier 1 — over-categorizing as Tier 1 makes the index noisy.

## Update cadence

- **Trigger-driven**: any new ADR, any `max-effort` review fixes commit, any closed-then-reopened issue, any explicit user invocation of this skill.
- **Floor**: weekly scan even if no trigger fires.
- **Don't double-count**: a strong signal from a milestone scan + the same signal showing up in next week's full scan = one update, not two.
