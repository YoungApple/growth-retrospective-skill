# Worked example — squishy-platypus growth log

This is the project that motivated the skill. Use it as a reference for what a real growth log looks like at one snapshot in time (2026-05-24).

## Background

`squishy-platypus` is a voice-first memory companion. iOS app + Node.js backend on Fly.io + Supabase Postgres + Gemini Live for voice. The user is a solo founder. The growth log captures what they're learning while building, not what they already know.

## Short index (~80 lines, lives in memory)

Path: `~/.claude/projects/-Users-youngapple-claude-workspace-squishy-platypus/memory/learning_domains.md`

```markdown
User goal: track concepts/domains the user is unfamiliar with, using
decision velocity (review rounds, ADR reversals, time between incident
→ resolution) as the proxy for challenge level.

This is the short index. Full reference at docs/learning-domains.md.

Baseline: 2026-05-24.

## Tier 1 — high challenge

- **Eval methodology + statistical rigor** — McNemar / Wilson CI / multi-seed / MVFR. Status: framework converging; per-category regression hunts open (#85).
- **Memory / entity graph architecture** — 9-type taxonomy, Contacts grounding, HITL correction. Status: taxonomy locked; emotion/who/themes write-path open (#82).

## Tier 2 — medium challenge (reversed or evidence-tested)

- **LLM Observability tooling** — Langfuse / Phoenix / OTEL evaluated, reversed to Supabase-native (ADR-0013). Status: decided, passive until ~1000 sessions/mo.
- **Gemini API multi-tenancy / budget isolation** — 4-bucket env split, 429 quota-vs-rate. Status: shipped (PR #98), incident-validated.
- **Voice resilience / iOS state machine + LiveKit data channel** — error envelope, silence watchdog. Status: error channel shipped, #106 still open.

## Tier 3 — settled

- **iOS release pipeline (Fastlane + TestFlight)** — stable since ADR-0006/0007.
- **Supabase DDL with Management PAT** — settled.
```

## Detailed reference (~12 KB, lives in repo docs/)

Path: `<repo>/docs/learning-domains.md`

Each entry follows the 5-field template (Signal · Concepts · Status · Level-up · Graduation). Excerpt of one Tier 1 entry:

```markdown
### Eval methodology + statistical rigor

**Signal.** 5 sequential review rounds (`docs/eval-mechanism-review-round{2,3,4,5}`)
+ 482-line `eval-framework-audit` + separate `eval-mechanism-audit`. Most-reviewed
topic in the repo.

**Concepts in play.**
- McNemar paired test (PR #80) — paired binary outcomes between two model runs
- Wilson confidence interval — small-sample binomial CI
- Multi-seed evaluation — N seeds to estimate variance
- MVFR (Minimum Viable Fixture-Replay) — self-coined; fixture corpus + idempotent seeder (#79)
- Drift findings — categorical regressions between prompt versions
- Gold set lock vs experimental promotion (ADR-0005)

**Status.** Framework converging; per-category regression hunts still open (#85).

**How to level up.**
1. Write `backend/evals/STATS-CHEATSHEET.md` — 1 page, 3 concepts × 1 example each.
2. Add `pnpm eval --explain-stats` that prints plain-language verdict per run.
3. **Graduation marker**: 3 consecutive PRs land a stats decision without `/codex consult`.
```

## How this got built — the trail

This is the chronological sequence that led to the snapshot above. Use this as a model for how to build a growth log from scratch.

### Day 1 (2026-05-24 morning): Baseline scan

User invoked `/goal "review my conversations and history, capture concepts and domains I don't understand"`.

Skill scanned:
- 16 ADRs in `docs/DECISIONS.md` — identified 4 with reversal / multi-round / incident patterns (Tier 1/2 candidates).
- git log — found 5-round eval review series, multi-version memory research docs, PR-A/B/C/D voice stacks.
- 7 session jsonl files — extracted 60 short user messages, found question particles + topic frequency: `eval-method=5, gemini-keys=5, why-this=3`.

Produced first-pass tier ranking → 5 domains in Tier 1/2, 2 in Tier 3.

### Day 1 afternoon: Side-chat scan added

User added: "side chat 反复解释的部分也是 gap 信号." Skill scanned chat for jargon-density complaints, explicit feedback, and in-flight definition probing ("429 means the frequency is too high" when actually budget cap).

Findings:
- Explicit feedback → spun off into feedback memories, NOT growth-log items (right call: feedback ≠ growth).
- In-flight definition probing on 429 → added to Gemini multi-tenancy item as Signal evidence.
- Repeated meta-instruction on language preference → flagged as memory-loading issue, NOT growth gap.

### Day 1 evening: Level-up actions + graduation markers added

User requested "actionable suggestions, not just inventory." Skill produced 2-3 level-up actions per Tier 1/2 item, all under 4 hours, all artifact-producing. Added explicit graduation markers.

Examples produced:
- Eval methodology → `STATS-CHEATSHEET.md`, `--explain-stats` flag, "3 PRs without consult" marker.
- Gemini → 70%/90% budget alerts, `pnpm gemini:probe`, "3 months zero 429" marker.
- Voice state machine → Talk-tab debug overlay, silence-watchdog unit test, "#106 closed + 2 weeks no new bug" marker.

### Day 1 night: Two-layer split

User requested split (memory was 11.6 KB, too heavy to load every chat). Skill split:
- Short index → 3.7 KB, loaded every chat
- Detailed reference → 12.2 KB, at `docs/learning-domains.md`, grep'd on demand

Maintenance rules written into both files: add to both on new item, sync on graduation, sync on reversal.

## Gap-shrinking, observed over time

The skill is too new to show long-term gap-shrinking on this project yet — that data accumulates over weeks/months. But the structure is in place to measure:

- **Eval methodology**: in 4 weeks, count `/codex consult` invocations on stats questions. Target: 0. Baseline: ~3-5 per week pre-skill.
- **Gemini**: in 12 weeks, count 429 incidents. Target: 0. Baseline: 1 incident in 2 weeks pre-skill.
- **Voice state machine**: time to close `#106` is the first measurable beat.

If after 3 months any Tier 1 item hasn't moved, the retrospective should investigate why — bad action, wrong marker, or genuinely persistent learning curve.

## What surprised the user during the build

These are useful patterns to look for in other projects:

- **Decision reversal was the highest-information signal.** A single reversal told us more about the user's learning state than 10 PRs of normal work.
- **Side-chat signals matched ADR-layer signals.** The frequency of `啥意思?` on a topic in chat lined up exactly with the multi-round review depth in docs. Either layer alone is sufficient; both together is confirmation.
- **The user repeated meta-instructions (language preference) was NOT a growth gap.** It was a tool / loading bug. Routing it correctly (to a feedback memory, not growth log) preserved signal integrity.
- **Cross-category interactions were not yet visible** at the baseline — they need months of data. Watch for them in future retrospectives.
