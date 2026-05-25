# Demo fixture — try the skill without bringing your own project

A self-contained synthetic project that lets you see what the skill produces in under 30 seconds, without installing it on a real codebase first.

The fixture simulates a 14-day-old solo-dev project with:
- A `git log`-style history (`docs/git-log.txt` — 47 commits, including reversal markers, max-effort review fixes, stacked PRs)
- A synthetic chat archive (`chat-archive/session-*.txt` — 3 sessions with question particles and topic frequency)
- 2 multi-round review docs (`docs/eval-review-round-2.md`, `eval-review-round-3.md`)
- An ADR file with one reversal (`docs/DECISIONS.md`)

Running `bash demo.sh` produces what the skill would output on this fixture — both the Step 0 Action Audit and the Step 2 Categorize pass — without needing Claude Code installed.

## Run it

```bash
cd examples/demo-fixture
bash demo.sh
```

Expected output: ~20 lines showing tier candidates, identified signals, and a graduation marker example. About 5 seconds.

## What's intentionally NOT in the demo

- Real LLM calls. The demo runs deterministic shell logic that mirrors what the skill scripts would extract, then prints what the skill body would conclude. It's a fixture, not a live run.
- A perfectly realistic chat archive. Real chat archives are noisy; this one is curated to make signals visible in <50 lines per session.

## What the demo proves

Plumbing works: the skill's scripts can extract signals from `git log` + chat archive on a fresh checkout with only `git` + Python stdlib available. No external dependencies.

If you want to see the skill make actual judgment calls (Tier assignment, level-up actions, graduation markers), install it in Claude Code and run `/retrospective` on a project you've been on for ≥2 weeks. See [the main README](../../README.md) for that.
