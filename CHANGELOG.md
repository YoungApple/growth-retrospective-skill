# Changelog

All notable changes to this skill. Format inspired by [Keep a Changelog](https://keepachangelog.com/), versioning by [SemVer](https://semver.org/).

## [Unreleased]

## [v0.4.0] — 2026-10-16

### Added
- **Phase 4 CALIBRATE (Quick Survey)** in `SKILL.md` — 30-second interactive calibration survey right after `ANCHOR`: (1) Focused Theme(s) multi-select from the retro findings, (2) Learning Purpose (`unblock` immediate decision | `mental-model` | `guardrail` against regressions | `articulate` for sharing/ADR defense), and (3) Delivery Mode (`in-agent-html` | `external-html` | `chat-inline`). Uses the host agent's native `ask_question` / `AskUserQuestion` modal when available.
- **Dual-Mode Research Execution** in Phase 5 `LAUNCH` — pressure-tested the assumption that self-growth must happen externally in NotebookLM. **Mode A: In-Agent Deep-Dive Briefing (Default)** synthesizes a 4-pillar code-anchored briefing (*Why it matters here*, *Production failure modes*, *Idiomatic stack pattern*, *Misconception vs reality*) directly inside the agent and HTML lab with zero context-switching. **Mode B: External Research / NotebookLM Pack (Opt-in)** remains available for multi-paper literature reviews or commute audio podcasts.
- **Interactive HTML Verification Lab (`scripts/render_quiz_html.py` + `assets/templates/interactive_quiz.html`)** — compiles a structured JSON quiz spec into a self-contained, zero-dependency interactive HTML app (`<repo>/.growth-log/quiz-<YYYY-MM-DD>.html`). Features live purpose/mode switcher, side-by-side In-Agent Briefing & 1-click NotebookLM prompt, 4-question Anchored MCQ engine with a **Predict-Then-Reveal commitment gate**, per-option diagnostic feedback citing `<file>:<line>` / `ADR-N`, Feynman Explain-Back sandbox, and a 1-click **Mastery Receipt** generator.

### Changed
- Core loop expanded from 5 to 6 explicit phases (`AUDIT → SWEEP → RANK → ANCHOR → CALIBRATE → LAUNCH`), keeping `SKILL.md` at 240 lines (well under the 350-line budget).

## [v0.3.0] — 2026-05-26

### Added
- **Phase 4 LAUNCH** in `SKILL.md` — every top gap now emits two artifacts: (a) a portable research prompt for Deep Research / NotebookLM / ChatGPT, (b) an anchored MCQ (4 questions, 2-3 min) grounded in the user's own codebase. Closes the verification loop: external research → anchored test → tier transition. Ground truth comes from the user's files / ADRs / commits, not the AI's knowledge — defends against hallucinated answer keys.
- Predict-then-reveal MCQ form — at least one of the 4 questions asks the user to predict a past ADR's actual rationale before revealing it. Highest-retention question form (prediction-error feedback in learning science).
- Explicit skip rules for MCQ — taste gaps (design opinion) use Explain-back; muscle memory (vim, shell) uses practice. Skill is honest about what verification mechanisms can and can't cover.
- `FAQ.md` — preempt persona-review pushback (framework allergy, 5-category skepticism, 3-layer concern, forcing-function annoyance, Layer 3 verification horizon, team use, uninstall)
- `docs/comparisons.md` — detailed side-by-side vs `/retro`, `/learn`, `claude-mem`, `nessie` across 5 dimensions, with "when to install which" recommendations
- `examples/dogfood-audit-2026-05-25.md` — first real Layer 3 evidence: ran Step 0 Action Audit on creator's own project (138 commits / 14 days, 0/11 actions completed). Single-user 30-day experiment with verifiable predictions.
- `.github/workflows/validate.yml` — CI checks SKILL.md frontmatter, required files, ShellCheck, Python syntax, evals.json structure, SKILL.md line budget (≤350)

### Changed
- **Full SKILL.md refactor to meta-prompt form.** ~260 lines of prose → ~190 lines of principles + invariant tables. Five phases (AUDIT → SWEEP → RANK → ANCHOR → LAUNCH) explicit and table-driven. Reads like a specification, not a tutorial.
- Description in frontmatter trimmed and updated to mention Phase 4 LAUNCH + ground-truth MCQ.

### Notes
- The v0.3.0 refactor is a structural change to the skill body, not just additive. Behavior under existing triggers should be the same except for the addition of Phase 4 LAUNCH output. Worked examples from v0.2.0 are still valid as baseline.

## [v0.2.0] — 2026-05-25

### Added
- **Step 0 Action Audit** in `SKILL.md` — the forcing function. Skill now refuses a new scan if ≥3 level-up actions are pending >14 days AND 0 completed since last run. Pushes back with 3 options: commit / deprioritize / override. Addresses the #1 stickiness defect from persona review.
- `CONTRIBUTING.md` — high-value contribution targets ranked. Worked examples > new agent support > references > scripts.
- `.github/ISSUE_TEMPLATE/bug.md`, `worked-example.md`, `agent-support.md` — three issue templates. The worked-example one surfaces graduation events and stickiness data (the L3 outcome data the skill needs to validate the shrinking-gap claim).
- `.github/PULL_REQUEST_TEMPLATE.md` — enforces cross-agent testing checklist + line-count discipline.

### Notes
- Cross-agent symlinks (Claude Code / Codex CLI / Antigravity) tested in Claude Code only. Codex + Antigravity verification welcome via PR.
- v2.5 quality jump is documented but not re-validated against a third iteration of evals — running another full eval round is deferred until there's signal from real users.

## [v0.1.0] — 2026-05-25 (initial release)

### Added
- Initial `SKILL.md` (v2) — cross-agent skill spec following the [agensi.io SKILL.md open standard](https://www.agensi.io/learn/skill-md-specification-open-standard). Validated via iteration-1 → iteration-2 evals; v1 had 3 defects (language compliance, 5-category sweep, deliberate demotion) — all fixed in v2.
- `references/signal_taxonomy.md` — full classification of decision-velocity signals (strong / medium / weak / anti-signal). Anti-signal section explicitly excludes repeated meta-instructions and other proxy noise.
- `references/growth_categories.md` — 5 categories with cross-category interaction notes (the cross-category insight is the underrated part of multi-dimensional tracking).
- `references/learning_journey.md` — how to write effective level-up actions (≤4h, artifact-producing, externalize practice) and graduation markers (observable + bounded + reversible).
- `references/examples.md` — worked example template.
- `assets/templates/short_index.md` + `detailed_reference.md` — exact format for the two-layer storage model.
- `scripts/scan_git_signals.sh` — ADRs, multi-round review docs, reversal markers, stacked PR patterns, commit timestamp distribution.
- `scripts/scan_chat_signals.py` — session jsonl scan for question particles, in-flight definition probing, per-topic frequency. Must use `--project-id=<value>` form due to argparse + leading-dash interaction.
- `evals/evals.json` — 4 test cases including the anti-pattern test (skill must refuse to add meta-instructions to growth log).
- `EVAL-FRAMEWORK.md` — 4-layer quality model (Output / Acceptance / Outcome / Cost). Documents which layers are validated and which aren't.
- `examples/anonymized-worked-example.md` — full anonymized run on a real 12-day project (138 commits, 7 sessions, 15 ADRs). 5 Tier 1/2 items, 2 demoted to Tier 3, one cross-category insight.
- README + README.zh-CN.md — bilingual install + design rationale.
