---
name: growth-retrospective
description: Capture, organize, and act on a user's personal growth gaps across a project — domain knowledge, human skills, work habits, meta-cognition, and productivity patterns. Maintains a two-layer storage (short index in agent memory + detailed reference in repo docs) ranked by decision-velocity signals. Generates concrete learning journeys with graduation markers. Use this skill whenever the user asks "what do I need to learn", "review my growth", "reflect on the project", "where am I weak", "retrospective", "what are my gaps", "am I improving", or runs `/retrospective` / `/reflect` / `/growth-review`. Also use proactively at the end of long sessions (≥30 turns of substantive work) or after major milestones (PR merged, ADR landed, sprint closed) — the goal is that the same gap should not be re-discovered next quarter. Decision velocity AND decision quality are the north-star metrics. Cross-agent compatible — works in Claude Code, Codex CLI, and Google Antigravity (same SKILL.md format, agent-specific storage paths).
compatibility:
  agents: [claude-code, codex-cli, antigravity]
  format: skill-md-open-standard
---

# Growth Retrospective

## Why this skill exists

The user is building a real project and wants to grow as a person, not just ship features. Every project leaves a trail of evidence — slow decisions, multi-round reviews, repeated chat questions, reversed ADRs, recurring bugs — about where the user is stretching versus operating from expertise. Without a deliberate practice of capturing and surfacing those gaps, the same struggles recur on the next project.

This skill operates the loop: **capture signals → categorize → prioritize → produce learning journeys → measure if gaps shrink over time**. The north-star metric is the user's **decision velocity × decision quality** on each tracked domain. Velocity alone is reckless; quality alone is paralysis; together they say "I make better calls faster than I did three months ago."

## When to invoke

Five trigger pathways. The skill works the same in all five — only the entry context differs.

1. **Explicit slash commands**: `/retrospective`, `/reflect`, `/growth-review`. User wants a deliberate sit-down.
2. **Keyword detection in chat**: phrases like "what do I need to learn", "am I improving", "where am I weak", "reflect on this project", "review my growth", "我需要学什么", "我做得怎么样", "我的 gap 在哪". Treat as if the user typed `/retrospective`.
3. **Session-end proactive**: at the end of a session with ≥30 substantive turns (real work, not just chat), offer: "want me to capture what we learned for the growth log?" Do not interrupt mid-task; ask once at natural stopping points.
4. **Milestone hooks**: after PR merge, ADR landed, sprint closed, or release shipped, the skill can be invoked to scan the delta and update the growth log incrementally. Recommended cadence: weekly minimum.
5. **First-time setup**: when the user has no existing growth log for a project, do a one-time baseline scan across the whole repo + chat history.

If multiple triggers fire close together (e.g. session-end immediately after a milestone), do ONE retrospective covering both — never run two passes back-to-back.

## What "growth" covers — five categories

Capture across all five. Most users default to category 1 only; this skill is unusual in tracking all five together because they compound.

1. **Domain knowledge** — technical / scientific concepts the user is learning while building (e.g. eval statistics, LiveKit data channels, multi-tenant API quotas). Most visible in ADRs and PR review rounds.
2. **Human skills** — judgment, abstraction, decision-making, communication clarity, asking precise questions. Less visible per-PR; visible in chat patterns over weeks.
3. **Work habits** — ADR discipline, PR review cadence, commit hygiene, documentation follow-through, when to ask for help vs push through. Visible in git history.
4. **Meta-cognition** — how the user learns ("I learn fastest by writing a one-page cheatsheet"), when decisions feel slow vs fast, what kinds of problems they avoid. Visible in patterns across multiple domains.
5. **Productivity / focus / energy patterns** — when in the day is the user most productive? What workflows keep them in flow? When do they context-switch and lose hours? Visible in commit timestamps + session lengths + interruption signals in chat.

Categories 4 and 5 are the ones humans most often skip because they're harder to instrument. The scripts in `scripts/` help.

## The two-layer storage

This is the canonical pattern. Every project gets:

- **Short index** — loaded into every chat session by the host agent. One bullet per tracked item: name, current tier, one-line status. Keep under ~80 lines / 4 KB.
- **Detailed reference** at `<repo>/docs/learning-domains.md` (or another canonical path the user picks) — grep'd on demand. Five fields per item: **Signal · Concepts in play · Status · How to level up · Graduation marker**.

Both layers MUST stay in sync. When you add a new item, add to both. When an item graduates (meets its graduation marker), simplify or remove from the index but keep in the detailed reference for posterity.

### Where the short index lives — pick by host agent

The detailed reference is repo content (same path everywhere). The short index is **agent-state** — different agents auto-load from different paths. Detect which agent is running this skill and write to the matching path:

| Host agent | Short index path |
|---|---|
| **Claude Code** | `~/.claude/projects/<project-id>/memory/learning_domains.md` — auto-loads in every chat. Project ID encodes the absolute path (slashes → dashes), e.g. `-Users-foo-work-myproject`. |
| **Codex CLI** | `~/.codex/skills/growth-retrospective/state/<project-slug>/learning_domains.md` OR append a `## Learning domains` section to the repo's `AGENTS.md`. AGENTS.md is read at session start, so appending there gives the same auto-load behavior. |
| **Antigravity** | `~/.gemini/antigravity/skills/growth-retrospective/state/<project-slug>/learning_domains.md` OR append to the repo's `.agents/agents.md`. Same logic as Codex — agents.md is read at session start. |
| **Unknown / generic agent** | `<repo>/.growth-log/short-index.md` — loses auto-load but stays grep-able. |

Project-slug is a short, filesystem-safe name for the project (e.g. `squishy-platypus`). Generate from the repo's directory name if the user hasn't picked one.

The skill itself lives at one canonical location with symlinks for each agent:
- Canonical: `~/.claude/skills/growth-retrospective/`
- Symlinks: `~/.agents/skills/growth-retrospective`, `~/.codex/skills/growth-retrospective`, `~/.gemini/antigravity/skills/growth-retrospective` (all point to canonical)

This means edits to the skill body propagate to all three agents automatically.

See `assets/templates/short_index.md` and `assets/templates/detailed_reference.md` for the exact format. See `references/examples.md` for a real worked example from the `squishy-platypus` project (Claude Code-based).

## Tiers — how to rank what the user is learning

Three tiers, based on **decision velocity signals** (see `references/signal_taxonomy.md` for the full taxonomy).

- **Tier 1 — high challenge.** Decisions are slow: 3+ review rounds, reversed ADRs, multi-version research docs, evidence-falsified challenges, repeated `啥意思?` / `what does X mean` in chat on the same concept.
- **Tier 2 — medium challenge.** A decision was made but tested by reality: ADR landed after challenge, incident-driven design, decision held under pressure but not yet automatic.
- **Tier 3 — settled.** Decisions stick. The user is applying knowledge, not learning it. Demote items here when they meet their graduation marker.

A graduated item (Tier 3 → removed from index) is the success state. Items are NOT supposed to live in Tier 1 forever — the level-up actions should move them toward graduation.

## The capture process

Run this sequence whenever invoked. Adapt for incremental (single milestone) vs full (first-time / weekly) modes — see below.

### Step 0: Action audit (the forcing function)

**Before scanning for new gaps, audit what the user committed to last time.** This is the skill's anti-busywork mechanism. A retrospective that doesn't check whether prior commitments produced anything is just noise.

1. Read the current detailed reference (`docs/learning-domains.md` or the path the user picked). Extract every **How to level up** action across all Tier 1 and Tier 2 items. Each action will name a concrete artifact — `STATS-CHEATSHEET.md`, `pnpm gemini:probe`, `docs/entity-erd.md`, a budget alert, a unit test, etc.
2. For each named artifact, check whether it exists:
   - Markdown files / docs → `git log --all -- <path>` or `find . -name <basename>`
   - CLI flags / scripts → `grep -r "<flag>" .` or `find . -name "<script>"`
   - Tests → check the corresponding test file
   - Config / alerts → ask the user if the only check is "did you go set this up in the vendor console"
3. Produce a one-table status report:

   ```
   Action                                    | Status        | Days since proposed
   ──────────────────────────────────────────|───────────────|────────────────────
   Write backend/evals/STATS-CHEATSHEET.md  | ✅ Done       | 14d
   Add pnpm eval --explain-stats flag       | ❌ Not started | 14d
   Write pnpm gemini:probe script           | ❌ Not started | 14d
   Generate docs/entity-erd.md              | 🟡 Partial    | 14d
   Spec-vs-impl checklist for ADR PRs       | ❌ Not started | 10d
   ```

4. **Decision rule**:
   - If **≥1 action completed since last retro** AND <60% pending → proceed to Step 1 (new scan).
   - If **0 actions completed** AND ≥3 actions pending more than 14 days → **push back**. Do not add new items. Tell the user:

     > "Last retro proposed N actions. M are still untouched after K days. Adding new items now would just grow the list. Three options:
     >
     > A) **Commit** — pick one pending action and we mark it active. New scan after that's done.
     > B) **Deprioritize** — name the actions you're explicitly killing. We update Tier or remove the item.
     > C) **Override** — explain why a new scan matters more than closing old loops. I'll proceed but flag this in the run log."

5. If user picks A or B in step 4, update the detailed reference and stop. The retro **completed without a new scan** — that's correct behavior. The forcing function did its job.
6. If user picks C, proceed to Step 1 but write the override reason into the new retro under a `## Override notes` section.

**Why this exists.** The biggest stickiness defect found in persona review: users who run `/retrospective` twice see nearly-identical output because no level-up action was completed between runs — which makes the skill feel like busywork. This step turns the skill from "another retro tool" into "an accountability loop where new items don't appear until old ones close or get killed."

**Cost**: ~30 seconds for the file checks. The push-back path takes 1 turn of the user's time. The completed-actions path is free.

### Step 1: Scan signal sources

Run the scripts in `scripts/`:

- `bash scripts/scan_git_signals.sh <repo-path> [days]` — extracts ADR count, review round counts (looks for `code-review fixes (max-effort pass)` or similar commit patterns), reversal events (closed-then-reissued issues), and stacked PR patterns. Default lookback: 365 days.
- `python3 scripts/scan_chat_signals.py --project-id=<ID> --topics=<csv> [--days N]` — greps the user's session jsonl files for question particles (`啥意思?`, `why?`, `what is`, `不懂`, `explain`), tracks topic frequency in short user messages, and surfaces in-flight mental models ("X means Y, right?"). **Important**: must use `--project-id=<value>` with the `=` form — project IDs start with `-` and argparse mis-parses positional `-`-strings as flags. Topics is a comma-separated list of keywords; supply the ones relevant to the project (e.g. `eval,memory,gemini,voice`).

The project-id is the directory name under `~/.claude/projects/`; for a repo at `/Users/foo/work/myproject` the ID is typically `-Users-foo-work-myproject`.

Combine the outputs. If the scripts can't run (missing access, no git history, no chat archive), do the same work manually with `git log` / `gh issue list` / `Read` on session files. The scripts are an accelerant, not a hard dependency.

### Step 2: Categorize by growth category × tier

For each signal, ask:
- Which of the five categories does this belong to? (domain / human skill / work habit / meta / productivity)
- What tier? (use `references/signal_taxonomy.md` to translate signals to tiers)

**Important — actively consider ALL 5 categories, not just domain knowledge.** Iteration-1 evals showed that without an explicit category checklist, the default bias is to over-index on category 1 (technical domains) and miss the other four. Before finalizing the tier table, sweep:

- Did anything in this scan period reveal a **human skill** gap (decision-making, abstraction, communication clarity, asking precise questions)? Visible in chat patterns over weeks, not single PRs.
- Did anything reveal a **work-habit** gap (ADR discipline, PR review cadence, doc follow-through)? Visible in git history.
- Did anything reveal a **meta-cognitive** pattern (the user noticed something about how they themselves learn or decide)? Visible across multiple domains.
- Did anything reveal a **productivity / focus / energy** pattern (commit timestamp distribution, session lengths, energy-time correlation)? Visible in timestamps.

If any of these comes up empty after a careful look, that's fine — but the question must be asked explicitly each pass. Don't skip categories silently.

Build a working table — see `references/examples.md` for what this looks like.

### Step 3: Update both storage layers

Read the existing short index (if any). For each new or changed item:

1. **New item** — add a bullet to the short index under the correct tier; add a full five-field entry to the detailed reference.
2. **Graduated item** — meets its graduation marker (e.g. "3 consecutive PRs without needing a stats consult") → move to Tier 3 in both, simplify detailed entry to 2 lines, optionally remove from index entirely.
3. **Reversed item** — was Tier 3, now back to Tier 2 because something broke → bump up in both, note the reversal in the Signal field.
4. **Unchanged item** — no signal change → leave alone, but note last-reviewed date.

**Mandatory demotion check.** Every retrospective pass, walk each existing Tier 1 and Tier 2 item and ask: *"Does the current evidence still justify this tier, or has the graduation marker been quietly met?"* Items don't graduate on their own — the skill must actively check. Common cases:

- A Tier 3-candidate (e.g. "iOS release pipeline") has been stable for the marker period AND the marker is a no-incident type — demote.
- A Tier 1 item has had no level-up actions completed AND no fresh signal AND no incident — leave at Tier 1 but flag in Step 5 as "stuck."
- A Tier 2 passive item is past its revisit trigger — surface to user, don't demote automatically.

Iteration-1 evals showed both with- and without-skill runs spontaneously demoted iOS release + Supabase DDL — make this an explicit step so it doesn't depend on luck.

**Incremental discipline.** Before editing, READ the current state of both files. If they were updated since the last retro (e.g. by a different session, a linter, or another agent), prefer **append-only updates** (a `## Update log` section, or a new Tier entry) over in-place edits of existing entries — you may not have the full context that produced the recent change. In-place edits are fine when YOU are the only writer this session.

Use the templates in `assets/templates/`. Use `scripts/render_storage.py` if it helps, or write the files directly with the templates as guidance.

### Step 4: Generate the learning journey

For every Tier 1 and Tier 2 item, the detailed reference needs a **"How to level up"** section with 2-3 concrete actions, and a **graduation marker** that defines what "done" looks like.

See `references/learning_journey.md` for principles. The short version:

- **Each action must be doable in under 4 hours** of focused work. If it's bigger, decompose.
- **Actions externalize the knowledge** — write a cheatsheet, build a probe script, add a telemetry alert, draw a diagram. Reading more rarely shrinks gaps; producing artifacts does.
- **The graduation marker is observable**, not subjective. "3 PRs without consulting `/codex` on stats" beats "feel confident with stats".
- **Tier 2 items often need passive markers** — "revisit when sessions/mo > 500" — instead of active practice. Don't force level-up actions on a decided-and-paused item.

### Step 5: Surface the gap-shrinking signal

After updating, compute and show the user:

- **Items graduated since last review** — these are wins, name them.
- **Items still in Tier 1 from N weeks ago** — these are the stuck spots; investigate why level-up actions didn't fire.
- **New items added** — what surfaced this period? Is the user picking up a new domain or did an old gap re-emerge?
- **Velocity delta on tracked items** — for any item with measurable signal (review rounds, decision time, side-chat question frequency), show the trend. The target is monotone-decreasing.

A single one-paragraph summary at the end is enough. Don't write a long retrospective doc unless the user explicitly asks. The artifacts (short index + detailed reference) ARE the retrospective.

## Incremental vs full mode

**Incremental** (default for milestone / session-end triggers): scan ONLY the delta since last review. Look at the most recent N commits, the most recent session's chat, the most recent ADR. Update what changed; don't rewrite untouched entries. Should take ≤ 5 minutes.

**Full** (default for explicit slash command, weekly cadence, or first-time setup): scan the entire repo history + all chat sessions. Useful for catching slow drift that incremental misses. Should take ≤ 20 minutes.

If the user doesn't specify, infer from context — explicit slash command = full unless they said otherwise; everything else = incremental.

## Anti-patterns

Things this skill should NOT do:

- **Track expertise**, only gaps. If the user is fluent in product strategy, that doesn't belong in the growth log. The log is for what's still hard.
- **Pad with vague items.** "Be a better engineer" is not a tracked item. "Land 3 stats PRs without `/codex` consult" is.
- **Generate inspirational content.** No "you got this!" headers, no journey-of-a-thousand-steps framing. Terse and signal-dense.
- **Re-run on every session.** The proactive trigger fires AT MOST once per session, and only if ≥30 turns of substantive work. Otherwise it becomes noise.
- **Block on missing scripts.** If a script fails or doesn't exist for this project setup, fall back to manual signal extraction via `git log`, `gh`, and reading session files. The scripts speed things up; they don't define the skill.
- **Insist on a particular file path.** The detailed reference defaults to `<repo>/docs/learning-domains.md`, but if the user's repo uses a different docs convention, follow theirs. The short index path inside `~/.claude/projects/<project-id>/memory/` is more stable — keep it consistent.
- **Violate the user's loaded communication rules.** If the user has `feedback_*` or `user_language_preference.md` memories about how to talk in chat (Chinese-primary, jargon glosses, GH issue/PR prefixes, sentence completeness), the skill's chat reply MUST satisfy them. See the "Chat output discipline" section below.

## Output discipline

### What to include in the user-facing reply

After running, the user should see:

1. A one-paragraph summary of what changed.
2. The file paths of the short index and detailed reference (so they can open them).
3. The top 1-3 level-up actions for this period (if any new ones added).
4. Any graduations or reversals, named explicitly.

That's it. Don't dump the full updated files in the chat. They're files; the user can open them.

### Chat output discipline — follow the user's loaded language rules

The chat reply you produce is subject to **the user's existing language / communication memories**, not just this skill's instructions. Before sending the reply, scan whatever files are loaded under `~/.claude/projects/<project-id>/memory/` that look like communication or style rules (typical filenames: `user_language_preference.md`, `feedback_complete_sentences.md`, `feedback_gh_reference_prefix.md`, anything starting with `feedback_*`). Apply their checklists.

For Chinese-primary users specifically, iteration-1 evals revealed a real defect: the skill's `with_skill` run on the keyword-trigger test produced an evidence-rich answer but **forgot the user's "4-character Chinese gloss on first-mention of new jargon" rule** — the same rule the `without_skill` baseline naturally followed. This is unacceptable: the skill must not regress communication discipline. If you see a `feedback_complete_sentences.md` (or equivalent) memory, treat its self-check as a hard precondition to sending the reply — at minimum:

- First sentence and section headers in the user's primary chat language.
- No fragmented code-switch sentences (Chinese particles glued around English shorthand, or vice versa).
- New jargon terms get a short gloss in the user's primary language on first mention, per the rules in their memory.

This applies to every reply this skill generates, including incremental updates, level-up action narratives, and graduation announcements. The skill's value-add must NEVER cost the user the language discipline they've trained.

## Cross-references

- `references/signal_taxonomy.md` — full taxonomy of decision-velocity signals (strong / medium / weak / anti-signals).
- `references/growth_categories.md` — deeper guidance on each of the 5 growth categories with examples.
- `references/learning_journey.md` — how to write effective level-up actions and graduation markers.
- `references/examples.md` — a real worked example from `squishy-platypus`, showing what the index and detailed reference look like after a year of use.
- `assets/templates/short_index.md` — the exact format for the memory-loaded short index.
- `assets/templates/detailed_reference.md` — the exact format for the repo-side detailed reference.
- `scripts/scan_git_signals.sh` — automated git-history signal extraction.
- `scripts/scan_chat_signals.py` — automated chat / side-chat signal extraction.
- `scripts/render_storage.py` — helper to render a category × tier table into both layers.

If any reference file is missing for the user's project (e.g. no session jsonl archive), use the templates as guidance and produce the layers by hand. The skill works without the scripts; it's faster with them.
