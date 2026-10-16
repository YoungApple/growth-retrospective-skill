---
name: growth-retrospective
identifier: youngapple-growth-retrospective
version: 0.4.0
description: Personal growth gap retrospective. 5-category sweep ranked by decision-velocity signals, calibrated via a quick 3-question survey (purpose, focused themes, study mode), and launched with Dual-Mode Research (In-Agent Deep-Dive briefing OR External NotebookLM / Deep Research prompt) + an Interactive HTML Verification Quiz grounded in your own codebase (<file>:<line> + ADRs). Step 0 Action Audit refuses new items if prior level-up actions are stuck. Use on `/retrospective`, `/reflect`, `/growth-review`, or "what should I learn", "where am I weak", "review my growth". Cross-agent compatible.
license: MIT
homepage: https://github.com/YoungApple/growth-retrospective-skill
compatibility:
  agents: [claude-code, codex-cli, antigravity, cursor, vscode]
  format: skill-md-open-standard
  install:
    global: [claude-code, codex-cli, antigravity]
    per-project: [cursor, vscode]
---

# Growth Retrospective

A retrospective skill designed so items leave the list. Captures personal growth
gaps across 5 categories, ranks by decision-velocity signals, **calibrates** to
your immediate learning goal, and **launches** interactive learning + verification
directly inside your environment.

North star: **decision velocity × decision quality** trending up over months.
A log that only grows is failure mode.

## When to invoke

- Slash commands: `/retrospective`, `/reflect`, `/growth-review`, `/growth-retrospective`
- Keywords (any language): "what should I learn", "where am I weak", "review my
  growth", "am I improving", "我的 gap 在哪", "需要学什么"
- Proactive: after ≥30 substantive turns in a session, or after PR merged / ADR
  landed / sprint close. Ask once at a natural stopping point; never interrupt
  mid-task.
- First-time setup: full baseline scan across the whole repo + chat history.

If multiple triggers fire together, run ONCE — never double up.

## Core loop — 6 phases

| # | Phase | What |
|---|---|---|
| 0 | **AUDIT** | Did prior level-up actions actually ship? Filesystem check before adding new gaps. |
| 1 | **SWEEP** | Visit all 5 categories explicitly. Missing one is a defect, even if empty. |
| 2 | **RANK** | Tier each gap by decision-velocity signals + mandatory demotion check. |
| 3 | **ANCHOR** | Ground each top gap to a real `<file>:<line>` / `ADR-N` / `<commit-sha>` in the user's repo. |
| 4 | **CALIBRATE** | Quick 3-question survey: pick focused theme(s), learning purpose, and research/test mode. |
| 5 | **LAUNCH** | Emit Dual-Mode Research (In-Agent Deep-Dive OR External Prompt) + Interactive HTML Quiz. |

All 6 phases are mandatory (Phase 4 CALIBRATE may auto-default only if the user
explicitly passes `--auto` or requests non-interactive execution).

---

## Phase 0: AUDIT — the forcing function (anti-busywork)

Before adding ANY new gap, read the prior detailed reference and check:

1. List every prior `How to level up` action across all Tier 1 + Tier 2 items.
2. For each, check the filesystem: does the named artifact exist? (cheatsheet,
   script, diagram, test, alert, ADR entry)
3. Decision rule:
   - **0 completed AND ≥3 pending >14 days** → REFUSE to add new items. Offer:
     - A) Commit to one pending action (mark it active, no new scan)
     - B) Explicitly drop pending actions (note in detailed ref, no new scan)
     - C) Override with a documented reason (new scan proceeds; reason logged)
   - **Anything else** → proceed.

The refusal path is the feature. The skill's value lies in saying "no more new
items until you close the old ones."

---

## Phase 1: SWEEP — visit all 5 categories explicitly

| # | Category | Visible in |
|---|---|---|
| 1 | Domain knowledge | ADRs, PR review rounds, repeated concept lookups |
| 2 | Human skills | Chat patterns over weeks (negotiation, written precision, asking) |
| 3 | Work habits | Git history (ADR discipline, doc follow-through, commit hygiene) |
| 4 | Meta-cognition | Cross-domain patterns (how you decide, when you ask vs push) |
| 5 | Productivity / focus | Commit timestamps, session lengths, interruption signals |

Most users default to (1). The compounding lives in (3), (4), and (5).

**Accelerants** (optional, fall back to manual `git log` / session-jsonl reading):

- `bash scripts/scan_git_signals.sh <repo> [days]`
- `python3 scripts/scan_chat_signals.py --project-id=<ID> --topics=<csv>`
  (Note: `--project-id=` requires `=` because IDs start with `-`.)

---

## Phase 2: RANK — tier each gap by signals

See `references/signal_taxonomy.md` for the full taxonomy.

- **Tier 1 — actively slowing decisions.** Strong signals: ≥3 review rounds on
  same topic, reversed ADRs, evidence-falsified challenges, repeated "what does
  X mean" in same week.
- **Tier 2 — knowledge gap, not yet blocking.** Medium signals: ADR landed after
  challenge, decided-but-not-automatic, looked up rather than recalled.
- **Tier 3 — settled.** Decisions stick. Demote here when the graduation marker
  is met. Graduating off the list is the success state.

**Mandatory demotion check:** every pass, walk all Tier 1 + Tier 2 items and
ask whether the graduation marker has quietly been met. Demote if yes.

---

## Phase 3: ANCHOR — ground each top gap to user's real artifacts

For each Tier 1 + Tier 2 gap (max 3 surfaced per retro):

1. Grep the user's repo for related symbols, error messages, ADR references.
2. Find a concrete `<file>:<line>` / `ADR-N` / `<commit-sha>` the user can open
   in under 2 minutes, plus a 3–8 line code/ADR snippet.
3. If no anchor found in ≤2 min of searching, mark the gap **abstract** and
   warn — Phase 5 verification will be weaker.

---

## Phase 4: CALIBRATE — quick survey for purpose, themes & mode

Before generating the deep-dive and quiz, run a **30-second Quick Calibration
Survey** grounded in the retro findings. Use the host agent's structured
question tool (`ask_question` / `AskUserQuestion`) when available; otherwise
present a compact 3-question prompt in chat:

| # | Question | Options (grounded in retro findings) |
|---|---|---|
| 1 | **Focused Theme(s)** | Multi-select from the top 1–3 anchored gaps surfaced in Phase 1–3 (`[Tier 1] <Theme A> (<anchor>)`, `[Tier 2] <Theme B> (<anchor>)`, or `All surfaced themes`). |
| 2 | **Learning Purpose** | • `unblock`: Unblock an immediate coding/architecture decision (focus on trade-offs & implementation)<br>• `mental-model`: Build a deep first-principles mental model (focus on specs, internals & edge cases)<br>• `guardrail`: Prevent recurring team/AI regressions (focus on invariants, linters & tests)<br>• `articulate`: Prepare for tech sharing / ADR defense / interview (adds Explain-Back Feynman sandbox) |
| 3 | **Research & Test Mode** | • `in-agent-html` **(Recommended)**: In-Agent Deep-Dive Briefing + Interactive HTML Verification Lab<br>• `external-html`: External NotebookLM / Deep Research Prompt + Interactive HTML Verification Lab<br>• `chat-inline`: In-Agent Deep-Dive + Lightweight Inline Markdown MCQ |

If the user passes `--auto` or is away/in-flight ("just make the best judgment"),
auto-select all top themes, infer Purpose from the strongest Tier 1 signal, and
default to `in-agent-html` (which embeds *both* the In-Agent Briefing and the
copyable External Research Prompt inside the HTML lab).

---

## Phase 5: LAUNCH — Dual-Mode Research + Interactive HTML Verification

### Why Dual-Mode Research? (Pressure-tested design)

Self-growth does **not** require context-switching out to NotebookLM every time:

| Mode | When it wins | What the agent does |
|---|---|---|
| **Mode A: In-Agent Deep-Dive (Default)** | Gap is tied to your repo architecture, stack semantics, or workflow habits (80%+ of engineering gaps). | Agent uses its direct access to `<file>:<line>`, ADRs, git history, and web search to synthesize a **4-Pillar Deep-Dive Briefing** right inside the session & HTML lab: *(1) Why it matters at `<anchor>`, (2) Production failure modes, (3) Idiomatic stack pattern, (4) Misconception vs reality*. |
| **Mode B: External Research / NotebookLM Pack (Opt-in)** | Broad literature survey across 15+ external papers/RFCs, or generating an Audio Overview podcast for a flight/commute. | Agent emits a portable copy-paste research prompt + lists exact local repo files/ADRs to upload as NotebookLM sources. |

In the Interactive HTML Lab, **both modes are embedded side-by-side** so the
user can read the In-Agent Briefing immediately and still one-click copy the
NotebookLM prompt anytime.

### Interactive HTML Verification Lab (Default test format)

Instead of static markdown text, compile an interactive, self-contained HTML
application at `<repo>/.growth-log/quiz-<YYYY-MM-DD>.html` using:

```bash
python3 <skill-dir>/scripts/render_quiz_html.py \
  --spec <repo>/.growth-log/quiz-<YYYY-MM-DD>.json \
  --output <repo>/.growth-log/quiz-<YYYY-MM-DD>.html
```

**What the Interactive HTML Lab provides**:
1. **Live Calibration Bar**: Switch Learning Purpose (`unblock` / `mental-model` /
   `guardrail` / `articulate`) and toggle between `🧠 In-Agent Briefing` and
   `🔬 External Research Prompt`.
2. **4 Anchored MCQs per theme (2–3 min total)**:
   - Mix forms: **State** (`<file>:<line>` behavior), **Consequence** (what
     breaks if reversed), **Compare** (Run/Design A vs B), and **Predict-then-reveal**
     (predict ADR/commit rationale before unlocking).
   - **Predict-Then-Reveal Gate**: Locks options on predict questions until the
     user commits a hypothesis (maximizing prediction-error retention).
   - **Instant Diagnostic Feedback**: Clicking an option reveals green/red state,
     why that choice is right/wrong, and the exact **Ground-Truth Artifact
     Citation** (`See <file>:<line>`).
3. **Explain-Back Sandbox** (auto-enabled for `articulate` purpose or taste gaps)
   + **Mastery Receipt Generator** (one-click copies verification score +
   committed `≤4h` level-up action back to the agent chat).

**Constraints**:
- Ground truth MUST come from the user's own files, ADRs, or commits — never
  AI-hallucinated trivia. `render_quiz_html.py` fails validation if `groundTruth`
  or `anchor` is missing.
- Skip MCQ for pure muscle memory (vim, shell fluency); use deliberate practice.

---

## Storage — two mandatory layers + interactive quiz artifact

| Layer | Path | Lifecycle |
|---|---|---|
| **Short index** | `~/.claude/projects/<id>/memory/learning_domains.md` (Claude Code)<br>`<repo>/AGENTS.md` (Codex) · `<repo>/.agents/agents.md` (Antigravity)<br>`<repo>/.growth-log/short-index.md` (Fallback) | Auto-loaded each session; ≤80 lines / 4 KB; one bullet per active item |
| **Detailed ref** | `<repo>/docs/learning-domains.md` | Grep'd on demand; 5 fields per item: `Signal · Concepts · Status · How-to-level-up · Graduation marker` |
| **Interactive Lab** | `<repo>/.growth-log/quiz-<YYYY-MM-DD>.html` (and `.json` spec) | Self-contained HTML study + test app opened in browser |

**Both text layers MUST stay in sync.** Templates: `assets/templates/short_index.md`,
`assets/templates/detailed_reference.md`, `assets/templates/interactive_quiz.html`.

---

## Output to the user (chat reply)

1. **Phase 0 verdict** — if AUDIT refused, show this FIRST and stop.
2. **One-paragraph summary** — graduations / new items / stuck items across the 5 categories.
3. **Phase 4 Quick Calibration Survey** — ask via native `ask_question` tool (or compact chat block) before generating the final launchpad; once calibrated (or in `--auto` mode), emit:
4. **File paths** — short index + detailed ref + **clickable link to the Interactive HTML Verification Lab** (`quiz-<YYYY-MM-DD>.html`).
5. **Concise In-Agent Deep-Dive summary** (or External Prompt if requested) inline.

Do NOT dump the full detailed reference or raw HTML into chat.

### Communication discipline (HARD)

Scan memory/rules for `language_preference.md` or `feedback_*.md`. For
Chinese-primary users: Chinese primary (`中文为主，英文为辅`), clear markdown
subheadings (`### Subheading`), technical identifiers in backticks.

---

## Anti-patterns

| Don't | Why |
|---|---|
| Force external NotebookLM when in-agent works | Unnecessary context-switch; agent already has repo context |
| Launch without calibrating purpose & theme | Wastes user attention on lower-priority gaps |
| Emit static text quizzes when HTML is supported | Passive text lacks prediction locks and instant feedback |
| Hand-wave MCQ ground truth | Every correct answer must cite `<file>:<line>` / `ADR-N` |
| Skip Phase 0 AUDIT | Turns the log into a hoarder list |

---

## Cross-references

- `references/signal_taxonomy.md`, `references/growth_categories.md`, `references/learning_journey.md`, `references/examples.md`
- `assets/templates/short_index.md`, `assets/templates/detailed_reference.md`, `assets/templates/interactive_quiz.html`
- `scripts/scan_git_signals.sh`, `scripts/scan_chat_signals.py`, `scripts/render_quiz_html.py`
