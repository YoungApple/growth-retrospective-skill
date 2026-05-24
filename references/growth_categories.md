# Growth categories — 5 things worth tracking

Most "learning logs" track only category 1 (domain knowledge). This skill tracks all five because they compound — a stuck work habit can mask a domain gap, an unprocessed meta-cognitive pattern can keep recreating the same productivity drag.

Each category has different signal sources and different shapes of level-up action. Read this when you're unsure which category an item belongs to, or when an item feels like it doesn't fit anywhere.

## 1. Domain knowledge

What it is — technical concepts the user is acquiring while building. The knowledge is external (textbooks exist, vendors document it, papers cover it) but the user is internalizing it firsthand.

**Examples**: eval statistics (McNemar test, Wilson CI), API multi-tenancy patterns, LiveKit data channel protocols, vector embedding semantics, iOS state machine design.

**Signal sources**:
- ADR count on the topic
- Multi-round review docs
- Vendor evaluation phases ("which observability platform")
- Concepts list growing in detailed reference

**Level-up actions tend to be**: write a cheatsheet, build an explain-stats CLI flag, draw an ERD, run a confusion matrix, set a revisit trigger.

**Graduation looks like**: applying the knowledge without consulting reference material, making correct calls under pressure (incidents), being able to teach someone else.

## 2. Human skills

What it is — durable cross-domain capabilities the user is developing through deliberate practice. Less about facts, more about how the user thinks and operates.

**Examples**:
- **Decision-making speed under uncertainty** (the user's stated north star)
- **Abstraction** — recognizing when 3 concrete cases share an underlying pattern
- **Asking precise questions** — distinguishing "what does X mean" from "is X the right tool here"
- **Communication clarity** — explaining a complex tradeoff in 3 sentences
- **Saying no to scope creep**
- **Reading code you didn't write**

**Signal sources**:
- Chat patterns over weeks (not single sessions): are the user's questions getting more precise?
- PR descriptions: are they shorter and tighter over time?
- `/codex consult` / `/plan-eng-review` frequency: is it dropping for similar-shaped problems?

**Level-up actions tend to be**: structured practice rituals, working out loud with a sparring partner (codex, Gemini), writing a thinking checklist, deliberate slow-thinking sessions.

**Graduation looks like**: doing the skill instinctively without conscious effort.

## 3. Work habits

What it is — procedural disciplines the user practices through repetition. Habits stick or break; they're not "learned" once.

**Examples**:
- ADR discipline (every reversible decision documented)
- PR review cadence (review within 24h)
- Commit hygiene (atomic, well-messaged)
- Documentation follow-through (docs updated in same PR as code)
- Backup / disaster recovery practice
- Daily standup ritual (even solo)
- Sprint planning at consistent cadence

**Signal sources**:
- git history (commit message quality, PR description quality, ADR cadence)
- `gh pr list` time-to-merge distribution
- docs/ freshness vs code freshness (drift = habit broken)

**Level-up actions tend to be**: automate the habit (pre-commit hook, scheduled task), reduce friction (template, snippet), tie to existing routine.

**Graduation looks like**: habit holds even under stress / time pressure / context switch.

## 4. Meta-cognition

What it is — the user's awareness of their own thinking patterns. This is the second-derivative category — knowing *how you learn* and *when you decide well*.

**Examples**:
- "I learn fastest by writing a one-page cheatsheet, not by reading more papers."
- "I make worse decisions late at night."
- "When I feel resistance to writing an ADR, that's a signal the decision is half-baked."
- "When a subagent challenges me and I bristle, the challenge is often correct."
- "I overweight novelty in early-stage planning."

**Signal sources**:
- Patterns across MULTIPLE domains, not single-domain signals
- The user's own retrospective notes (this skill's output, over time)
- Failures attributed to consistent root causes

**Level-up actions tend to be**: name the pattern, build a checklist or guardrail that catches it, expose the pattern in chat preamble.

**Graduation looks like**: the pattern is named and the guardrail is automatic — the user no longer falls into the trap.

## 5. Productivity / focus / energy

What it is — when, how long, and under what conditions the user does their best work. This is the most underinvested category for most engineers.

**Examples**:
- **Time-of-day**: peak focus 9am-12pm, recovery needed after lunch, second wind 3pm-6pm
- **Session length**: depth work tops out at 3h, after that error rate climbs
- **Flow conditions**: phone in another room, single-tab browser, music or silence
- **Context-switch tax**: average 23min to recover after an interruption
- **Energy management**: not just time; what kinds of work drain vs restore
- **Sleep / exercise / food impact on decision quality**

**Signal sources**:
- Commit timestamps (when does code actually get written?)
- Session length distributions
- Self-reports in chat ("I'm tired", "I'm in flow", "let me come back to this")
- Quality of decisions made at different times of day (correlate with commit timestamps)

**Level-up actions tend to be**: instrument the pattern (rescuetime, screen time), redesign the day around the pattern, eliminate identified energy sinks.

**Graduation looks like**: the user reliably operates in their best conditions for the highest-leverage work.

## Cross-category interactions

Watch for these — they're where the biggest leverage is.

- **Domain × productivity**: "I keep trying to do statistical reasoning in the afternoon when I'm tired, and that's why eval methodology feels harder than it is."
- **Habit × meta**: "I skip ADRs when the decision feels obvious, but my retrospective shows the 'obvious' decisions are the ones I reversed most."
- **Human skill × habit**: "I want to make decisions faster, but I never write down my reasoning, so I can't tell if my speed is improving."

When you find a cross-category interaction, add it to the detailed reference under whichever category seems primary, and note the link.

## When something fits no category

If you can't place an item, ask:
- Is this a knowledge gap (don't know X)? → category 1
- Is this a skill gap (can't yet do X reliably)? → category 2
- Is this a habit gap (know how, don't do it consistently)? → category 3
- Is this a pattern about how I learn / decide? → category 4
- Is this about when / where / how long I work? → category 5

If still none — it might be a feedback item (something to change about Claude's behavior or the tool chain), not a growth item. Route to a feedback memory instead.
