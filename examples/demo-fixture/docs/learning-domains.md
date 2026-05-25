# Learning domains — detailed reference (demo fixture, prior pass)

**Baseline: 2026-05-15.** Last updated: 2026-05-15. Two weeks have passed since this pass; today's run should test the Step 0 Action Audit against these actions.

## Tier 1 — high challenge

### Eval methodology + statistical rigor

**Category.** Domain knowledge.

**Signal.** Round-1 and round-2 review docs exist; round-3 is in progress. Multi-week unresolved questions on McNemar / Wilson / continuity correction.

**Status.** Framework still converging.

**How to level up.**
1. Write `docs/STATS-CHEATSHEET.md` — one page, three concepts × one example each.
2. Add `--explain-stats` CLI flag for non-stats readers.
3. **Graduation marker**: 3 consecutive stats decisions without re-deriving Wilson vs Clopper-Pearson.

---

### Memory entity graph design

**Category.** Domain knowledge.

**Signal.** Two versions of memory-research doc, 4 stacked PRs, ongoing debate about compound entities.

**Status.** Taxonomy decided (9 types); compound-mention rules still open.

**How to level up.**
1. Generate `docs/entity-erd.md` from schema.
2. Add per-type confusion matrix to eval.
3. **Graduation marker**: 2 sprints with no new entity type added.

---

## Tier 2 — medium challenge

### Late-night decision quality

**Category.** Meta-cognition.

**Signal.** Session-3 chat shows late-night reversal pattern (user noticed at 02:30 that rejected proposal was right).

**Status.** Pattern named, not yet automated.

**How to level up.**
1. Add a git pre-commit hook that warns if commit time is after 23:00.
2. Schedule next-morning code-review for late-night commits.
3. **Graduation marker**: 4 weeks with no late-night reversal.

---

### Caching architecture decision-making

**Category.** Domain knowledge.

**Signal.** ADR-0003 reversed by ADR-0005 within 5 days. Highest-information signal in the project history.

**Status.** Reversed and stable. May come back if scale changes.

**How to level up.**
1. Write `docs/triggers.md` — note that LLM caching is revisitable if cache hit rate could exceed 30% at scale.
2. **Graduation marker**: 60 days without re-considering the caching layer → demote to Tier 3.

---

## Tier 3 — settled

### TypeScript everywhere
ADR-0001, stable. Applying not learning.

### Managed Postgres choice
ADR-0002, no controversy.
