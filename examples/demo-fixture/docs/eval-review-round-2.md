# Eval mechanism review — round 2

Following round-1 feedback, this pass focuses on the statistical claims in the eval framework.

## Open questions from round 1

1. Is paired McNemar the right test for our eval delta?
2. What's the Wilson confidence interval at n=42?
3. How many seeds for multi-seed evaluation?

## Round-2 conclusions

- McNemar is correct for paired binary outcomes on the same eval set. Standard.
- Wilson at n=42, p=0.7 gives CI roughly [0.55, 0.82]. Tighter than normal-approximation.
- 3 seeds is the minimum; we observe variance within ±2pp at 3 seeds.

## Still unsettled

- What threshold counts as a "significant" delta? p<0.05 is arbitrary at our sample size.
- Should we use Wilson or Clopper-Pearson? Both are valid.
- How to communicate the CI to a non-stats reader.

**Defer to round 3.**
