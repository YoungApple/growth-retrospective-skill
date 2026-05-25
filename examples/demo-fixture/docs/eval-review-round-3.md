# Eval mechanism review — round 3

Round 2 deferred 3 questions. Resolving here.

## Resolutions

### What threshold counts as a "significant" delta?

Decision: 2pp absolute change AND non-overlapping Wilson CIs. Stricter than p<0.05 alone.

### Wilson vs Clopper-Pearson?

Decision: Wilson. Tighter at our sample size, and good enough for monitoring purposes (not publication-grade).

### How to communicate CI to non-stats reader?

Decision: ship `--explain-stats` CLI flag that prints plain-language verdict: "delta of 3.2pp is statistically significant at p<0.05 with n=42; CIs do not overlap."

## What's still open

- Multi-seed: does our 3-seed default catch all relevant variance? Round 4 will run a 10-seed comparison to validate.
- McNemar: we're using the standard form; check if continuity correction matters at small n.

**Defer to round 4.**
