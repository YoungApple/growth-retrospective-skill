# Contributing to growth-retrospective

Thanks for considering a contribution. This skill is small enough that PRs land fast. The bar is honest signal, not polish.

## What's most useful

If you only do one thing, **add a worked example** to `examples/`. Real numbers from a real project beat any theoretical improvement. The skill claims gaps shrink over time — every additional data point either confirms or falsifies that claim.

Format: anonymize project name + domain specifics, keep tier counts + signal numbers + graduation markers exact. See `examples/anonymized-worked-example.md` for the template.

## Other high-value contributions

| Contribution | Why it matters |
|---|---|
| Worked example from a real project | The "shrinking gap" claim needs >1 data point |
| New agent platform support (Cursor, Aider, Windsurf, etc.) | Open an issue with the symlink path convention; we add to install docs |
| `references/` improvement — sharpening signal taxonomy or growth categories | Reduces noise in tier assignment |
| Script: better git/chat scanner (e.g. CI integration) | Lowers run cost; expands what counts as evidence |
| Translation of `README.zh-CN.md` to another language | Solo founders in non-English regions are an underserved audience |
| Bug report on a specific eval scenario where v2 outputs wrong tier | Directly improves output quality |

## What's NOT a useful contribution

Per the skill's own anti-patterns:

- "Make 5 categories into 7" — the framework is debated; adding more dimensions to compete on completeness misses the point. The 5 are picked for *coverage of leverage*, not exhaustiveness.
- New SKILL.md prose for the sake of polish — every byte added loads into every chat session
- Removing the forcing function (Step 0 action audit) — that's the anti-busywork mechanism; without it the skill becomes another learning-log
- Inspirational content additions (emoji headers, motivational framing) — the skill's voice is terse + evidence-driven, on purpose

## PR checklist

- [ ] The change has a one-sentence "why" — what failure mode does it prevent?
- [ ] If you touched `SKILL.md`, line count stayed roughly the same or shrunk
- [ ] If you added a worked example, it's anonymized (project name + product specifics)
- [ ] If you added a script, it works on a fresh clone with only `git` installed (skills should degrade gracefully without `gh` / `jq` / Python)
- [ ] Frontmatter `name` + `description` in `SKILL.md` still match repo name

## How decisions get made

This skill follows the **6-axis ADR pressure test** (premise / bootstrap / drift / conflict / footprint / sell-by) for design changes. Skim `references/signal_taxonomy.md` if you want context on how new signals are evaluated.

For small / mechanical changes: open a PR, no issue first.
For structural changes (new sections in SKILL.md, new reference files, new categories): open an issue first with a one-paragraph proposal. Avoids you writing a big PR I have to ask you to undo.

## Cross-agent compatibility

Any change that risks breaking compatibility across Claude Code / Codex CLI / Antigravity should be tested in all three (or at least two). The `SKILL.md` open standard at agensi.io is what makes the three-agent symlink trick work — don't add fields the standard doesn't include.

## License + attribution

MIT. PRs imply you've authored the change and you're OK with MIT licensing it.

If you used Claude / Codex / another AI to draft the change, please say so in the PR description — not because it's disqualifying, but because it changes how I review (more focus on whether the change matches actual repo style vs autocomplete inertia).
