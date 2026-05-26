---
name: growth-retrospective
identifier: youngapple-growth-retrospective
version: 0.3.0
description: Personal growth gap retrospective. 5-category sweep ranked by decision-velocity signals; each top gap launched with a Deep Research / NotebookLM prompt + 4 multiple-choice questions grounded in your own codebase (your files + ADRs are the ground truth, not the AI's knowledge). Step 0 Action Audit refuses new items if prior level-up actions are stuck — designed so items leave the list. Use when slash commands `/retrospective`, `/reflect`, `/growth-review`, or keywords like "what should I learn", "where am I weak", "am I improving", "review my growth". Also proactive after long sessions (≥30 substantive turns) or milestones (PR merged, ADR landed, sprint closed). Cross-agent compatible — Claude Code, Codex CLI, Antigravity, Cursor, VS Code, same SKILL.md format, agent-specific storage paths.
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
gaps across 5 categories, ranks by decision-velocity signals, and **launches**
learning — not just lists it.

North star: **decision velocity × decision quality** trending up over months.
A log that only grows is failure mode.

## When to invoke

- Slash commands: `/retrospective`, `/reflect`, `/growth-review`
- Keywords (any language): "what should I learn", "where am I weak", "review my
  growth", "am I improving", "我的 gap 在哪", "需要学什么"
- Proactive: after ≥30 substantive turns in a session, or after PR merged / ADR
  landed / sprint close. Ask once at a natural stopping point; never interrupt
  mid-task.
- First-time setup: full baseline scan across the whole repo + chat history.

If multiple triggers fire together, run ONCE — never double up.

## Core loop — 5 phases

| # | Phase | What |
|---|---|---|
| 0 | **AUDIT** | Did prior level-up actions actually ship? Filesystem check before adding new gaps. |
| 1 | **SWEEP** | Visit all 5 categories explicitly. Missing one is a defect, even if empty. |
| 2 | **RANK** | Tier each gap by decision-velocity signals. |
| 3 | **ANCHOR** | Ground each top gap to a real `file:line` / ADR / commit in the user's repo. |
| 4 | **LAUNCH** | Per top gap: research prompt + anchored MCQ. |

All 5 phases are mandatory. Skipping AUDIT turns the log into a hoarder list.
Skipping SWEEP biases toward domain knowledge. Skipping ANCHOR weakens
verification. Skipping LAUNCH leaves gaps decorating the log forever.

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

Most users default to (1). The compounding lives in (4) and (5).

**Accelerants** (optional, fall back to manual `git log` / session-jsonl reading
if scripts can't run):

- `bash scripts/scan_git_signals.sh <repo> [days]`
- `python3 scripts/scan_chat_signals.py --project-id=<ID> --topics=<csv>`
  (Note: `--project-id=` requires the `=` form — IDs start with `-` and argparse
  mis-parses positional `-` strings as flags.)

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
ask whether the graduation marker has quietly been met. Demote if yes. Items
don't graduate on their own.

---

## Phase 3: ANCHOR — ground each top gap to user's real artifacts

For each Tier 1 + Tier 2 gap (max 3 surfaced per retro):

1. Grep the user's repo for related symbols, error messages, ADR references.
2. Find a concrete `<file>:<line>` / `ADR-N` / `<commit-sha>` the user can open
   in under 2 minutes.
3. If no anchor found in ≤2 min of searching, mark the gap **abstract** and
   warn — Phase 4 MCQ will be weaker.

Anchoring is what makes the next phase work. AI-native skills can read the user's
code; traditional learning apps can't. This is the unique leverage point.

---

## Phase 4: LAUNCH — emit a learning launchpad per top gap

For each top gap (max 3), produce TWO artifacts:

### (a) Research prompt (copy-paste to Deep Research / NotebookLM / ChatGPT)

```
I'm building [project, 1 line]. I need to understand [gap concept] in the
context of [anchor — <file>:<line> or ADR-N].

Questions:
1. When does this matter in practice?
2. What are the failure modes I should worry about?
3. Real-world examples in [user's stack]?
4. Common misconceptions?

Output: deep-dive report with citations to primary sources (docs, RFCs, post-mortems).
```

The prompt is portable. The user picks the external tool. The skill doesn't bind
to one vendor.

### (b) Anchored MCQ (4 questions, 2-3 min total)

Generate 4 multiple-choice questions verifying the user learned the concept.
**Ground truth comes from the user's own artifacts, not the AI's knowledge** —
this is the defense against AI-hallucinated answers.

Use a mix of question forms:

| Form | Example | Ground truth |
|---|---|---|
| **State** | "Your `<file>:<line>` uses isolation level X. Which?" | `grep` the file |
| **Consequence** | "If ADR-N's choice were reversed, what breaks first?" | ADR-N body |
| **Compare** | "Run A vs Run B — which is more likely to regress on category X?" | Eval output |
| **Predict-then-reveal** | "Before I show you ADR-M's actual rationale, predict: (a)(b)(c)(d)" | ADR-M body |

The predict-then-reveal form is highest-retention (prediction-error feedback in
learning science). Use it for ≥1 of the 4 questions when a relevant ADR or commit
rationale exists.

**Constraints**:
- Each question ≤30 sec to answer.
- 4 questions = 2-3 min total.
- Answer key MUST cite the ground-truth artifact: `Correct: (b). See <file>:<line>`.
- Skip MCQ for **taste gaps** (design opinion, product judgment). Use
  Explain-back instead: "Describe in 5 sentences why X over Y."
- Skip MCQ for **muscle memory** (vim, shell fluency). Verification mechanism
  doesn't solve those — only practice does.

The skill's job is to make starting trivially easy. Whether the user follows
through is their choice.

---

## Storage — two layers, both mandatory

| Layer | Path (Claude Code) | Lifecycle |
|---|---|---|
| **Short index** | `~/.claude/projects/<project-id>/memory/learning_domains.md` | Auto-loaded each session; ≤80 lines / 4 KB; one bullet per active item |
| **Detailed ref** | `<repo>/docs/learning-domains.md` | Grep'd on demand; 5 fields per item: `Signal · Concepts · Status · How-to-level-up · Graduation marker` |

Cross-agent short-index paths (write to whichever the host agent auto-loads):

| Host | Short-index path |
|---|---|
| Claude Code | `~/.claude/projects/<id>/memory/learning_domains.md` |
| Codex CLI | Append `## Learning domains` section to repo's `AGENTS.md` |
| Antigravity | Append to repo's `.agents/agents.md` |
| Unknown | `<repo>/.growth-log/short-index.md` |

The detailed reference is repo content (same path everywhere); the short index
is agent-state.

**Both layers MUST stay in sync.** Adding to one only is a defect. When an item
graduates, simplify in detailed ref + remove from index.

Templates: `assets/templates/short_index.md`, `assets/templates/detailed_reference.md`.

---

## Output to the user (chat reply)

After running, the user sees ONLY:

1. **Phase 0 verdict** — if AUDIT refused, show this FIRST and stop.
2. One-paragraph summary: graduations / new items / stuck items.
3. File paths: short index + detailed ref.
4. Top 1-3 launchpads (research prompt + MCQ block) — inline, ready to copy-paste.

Do NOT dump the full updated detailed reference. It's a file; the user opens it.

### Communication discipline (HARD)

Before sending the chat reply, scan `~/.claude/projects/<id>/memory/` for files
matching `user_language_preference.md` or `feedback_*.md`. Apply their checklists.

For Chinese-primary users: first sentence + section headers in Chinese, no
fragment-by-code-switch, jargon glossed on first mention. The skill MUST NOT
cost the user the communication discipline they trained.

---

## Incremental vs full mode

- **Incremental** (default for milestones / session-end): scan only the delta
  since last review. ≤5 min.
- **Full** (explicit slash command, weekly cadence, first-time): full repo +
  chat-history scan. ≤20 min.

Infer from context if unspecified. Explicit slash command → full unless user
says otherwise; everything else → incremental.

---

## Anti-patterns

| Don't | Why |
|---|---|
| Track expertise | The log is for what's still hard, not what's mastered |
| Pad with vague items ("be a better engineer") | Vague = unverifiable = never graduates |
| Generate inspirational content | Terse and signal-dense only |
| Re-run on every session | Proactive trigger fires AT MOST once per session |
| Skip Phase 0 | Bypassing the forcing function turns the log into a hoarder list |
| Skip Phase 4 LAUNCH | Identifying gaps without launching is decoration |
| Generic MCQ ("explain X") | MCQ must be anchored to user's own files |
| Hand-wave the MCQ ground truth | Every correct answer cites a verifiable artifact |
| Re-introduce a graduated item as new | Check the log first; escalate, don't duplicate |
| Block on missing scripts | Scripts are accelerants; manual extraction always works |

---

## Cross-references

- `references/signal_taxonomy.md` — full decision-velocity signal list
- `references/growth_categories.md` — deeper guidance on the 5 categories
- `references/learning_journey.md` — level-up actions + graduation markers
- `references/examples.md` — worked example from `squishy-platypus`
- `assets/templates/short_index.md` + `assets/templates/detailed_reference.md`
- `scripts/scan_git_signals.sh`, `scripts/scan_chat_signals.py`, `scripts/render_storage.py`

If any reference file is missing for the user's project, use templates as
guidance and produce the layers by hand. The skill works without the scripts.
