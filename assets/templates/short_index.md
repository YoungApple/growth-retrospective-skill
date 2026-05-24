---
name: learning-domains
description: "Short index of domains the user is actively learning while building <PROJECT-NAME>, ranked by decision-velocity signals. Detailed entries (signals, concepts, level-up actions, graduation markers) live in <DETAILED-REFERENCE-PATH> — grep there when a domain needs deepening."
metadata:
  node_type: memory
  type: user
---

User goal: track concepts/domains the user is unfamiliar with, using
**decision velocity** (review rounds, ADR reversals, time between
incident → resolution) as the proxy for challenge level.

**This is the short index.** Each entry is one line: domain · status.
The full reference (signals, concepts-in-play, how-to-level-up,
graduation markers, side-chat mining method) lives at
`<DETAILED-REFERENCE-PATH>`. Grep there when you need depth.

Baseline: **<DATE>**.

## Tier 1 — high challenge

<!-- One bullet per item. Format:
- **<Item name>** — <key concepts list>. Status: <one-sentence current state>.
-->

## Tier 2 — medium challenge (reversed or evidence-tested)

<!-- Same format as Tier 1. -->

## Tier 3 — settled (mostly applying not learning)

<!-- Optional. Can be empty if no items have graduated yet. -->

## Two-layer maintenance rule

When a new learning item is identified in chat:

1. **Add a one-line bullet here** under the right tier — name · status.
2. **Add the full entry to** `<DETAILED-REFERENCE-PATH>` with all five fields: Signal · Concepts in play · Status · How to level up · Graduation marker.
3. **On graduation**: move to Tier 3 in both files, simplify the docs entry to two lines, optionally drop from this index if fully settled.
4. **On reversal**: bump tier up in both files; add the reversal to the docs Signal field.

This index is loaded into every chat session (token cost). The docs
version is grep'd on demand. Keep this file under ~80 lines.

## When to refresh

- Triggers: new ADR, `code-review fixes (max-effort pass)` commits, reopened issue, new `wedge-blocker` label, or a repeated user "啥意思?" on a term not yet listed here.
- Floor: weekly scan even if no trigger fires.
- Method: invoke this skill (`/retrospective` or `/growth-review`) or refer to `<DETAILED-REFERENCE-PATH>` → periodic review notes.

## What NOT to track here

Domains the user is expert in — those come *from* the user, not learned from this project.

Related: <list of related memory files, e.g. [[product-philosophy-r12]], [[decision-velocity-method]]>.
