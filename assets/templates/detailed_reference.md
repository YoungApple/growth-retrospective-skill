# Learning domains — detailed reference

**Purpose.** Track concepts, skills, habits, and patterns the user is
actively learning while building <PROJECT-NAME>. Decision velocity is
the proxy for challenge level. Updated periodically via the
`growth-retrospective` skill.

This file is the **detailed reference**. The short index lives at
`<SHORT-INDEX-PATH>` and is loaded into every chat session. New items
identified in chat land in **both** layers — see "Two-layer
maintenance" at the end of this file.

Baseline: **<DATE>**.

---

## Tier 1 — high challenge (slow decisions, ongoing iteration)

<!-- One entry per item, following the 5-field template below. -->

### <Item name>

**Category.** <domain knowledge | human skill | work habit | meta-cognition | productivity / focus>

**Signal.** <The observable evidence that this is a challenge area. Cite specific files, PR numbers, ADRs, dates. The more concrete the signal, the better the tier assignment.>

**Concepts in play.**
- **<Concept 1>** — <one-line definition or context>.
- **<Concept 2>** — <one-line definition or context>.
- (List the actual vocabulary / techniques / patterns the user is engaging with.)

**Status.** <Current state. What's settled, what's open, what's the next move.>

**How to level up.**
1. <Concrete action, ≤4 hours focused work, produces an artifact. Be specific: name the file, the script, the alert.>
2. <Same. 2-3 actions total; don't overload.>
3. <Optional third action.>

**Graduation marker.** <The observable condition under which this item moves to Tier 3. Must be measurable from artifacts or behaviors, not subjective. Bounded in count or time.>

---

## Tier 2 — medium challenge (reversed or evidence-tested decisions)

<!-- Same 5-field template. Tier 2 items often have passive level-up actions ("wait for trigger"). -->

---

## Tier 3 — settled (mostly applying not learning)

<!-- Simplified format: 2 lines. Concepts + signal. No level-up section. -->

### <Item name>

**Concepts.** <Comma-separated key concepts.>
**Signal.** <Why this is settled. Reference the graduation marker that was met, or note "stable since <date>".>

---

## Side-chat signals — mining unfamiliarity from chat directly

Chat-level confusion appears **before** it becomes a decision artifact in ADRs / PRs.

**Channels to mine** in session jsonl files at
`<SESSION-JSONL-PATH>`:

1. **Short user messages with question particles** — `啥意思?` / `为什么?` / `什么是` / explicit `explain`. Filter user messages 5–200 chars and grep for these particles.
2. **In-flight definition probing** — user types their working hypothesis out loud and asks if right: *"X means Y, right?"*. These reveal which mental model is being formed right now.
3. **Topic frequency in short user messages** — count occurrences of domain keywords in short user messages; consistent with ADR-layer signals confirms the signal.
4. **Repeated meta-instructions** — user repeating an already-saved preference is **NOT a domain signal** — it's a memory-loading or tool issue. Don't confuse the two.
5. **Explicit-feedback callouts** — when the user spells out *what to change about behavior*, write a feedback memory (not a growth-log item).

---

## Notes for periodic review

**How to update this file** (run weekly, or on any of the triggers below):

1. Scan `docs/DECISIONS.md` (or equivalent ADR location) for new ADRs since last review → which domain did they touch?
2. Scan `git log` for review-heavy PR series (squash of `code-review fixes (max-effort pass)` is a strong signal).
3. Scan open issues with `quality-debt` or `wedge-blocker` labels — these are open challenge areas.
4. Compare ADR count per domain. New ADR in an existing tier = still active. No movement in 30 days = consider demoting tier.
5. Note any **reversals or evidence-falsified challenges** — these are the highest-information events about challenge level.
6. Run the **side-chat scan** above — grep recent session jsonl for short user messages matching question particles; bucket by domain keyword.

**What NOT to include here.** Domains the user is expert in (whatever those are for this user — product strategy, design taste, etc.). The log is for what's still hard.

---

## Two-layer maintenance

This file (detailed reference) and the short-index memory must stay in
sync. Whenever a new learning item is identified in chat:

1. **Add to short index** at `<SHORT-INDEX-PATH>`: one bullet under the right tier with name + status.
2. **Add full entry here** with all five fields: Category · Signal · Concepts in play · Status · How to level up · Graduation marker.
3. **On graduation**: move to Tier 3 in both files, simplify here to 2 lines (drop the "How to level up" section), drop the bullet from the short index if fully settled.
4. **On reversal**: bump tier up in both files; add the reversal note to the Signal field here.

The short index is what gets loaded into every chat (token cost
matters); this file is what gets grep'd when "what concepts are still
hard for me?" comes up.
