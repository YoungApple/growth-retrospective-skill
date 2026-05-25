#!/usr/bin/env bash
# demo.sh — runs the growth-retrospective skill's signal extraction on a synthetic fixture.
# This is a fixture demo, not a live LLM run. It shows what the skill scripts would extract
# and what a Step 0 Action Audit + Step 2 categorization would conclude.

set -euo pipefail

FIXTURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$FIXTURE_DIR"

bold() { printf "\033[1m%s\033[0m\n" "$1"; }
dim()  { printf "\033[2m%s\033[0m\n" "$1"; }
green(){ printf "\033[32m%s\033[0m" "$1"; }
red()  { printf "\033[31m%s\033[0m" "$1"; }
ylw()  { printf "\033[33m%s\033[0m" "$1"; }

echo
bold "════════════════════════════════════════════════════════════════"
bold "  growth-retrospective demo fixture — synthetic 14-day project"
bold "════════════════════════════════════════════════════════════════"
echo
dim "Fixture contents:"
dim "  $(wc -l < docs/git-log.txt | tr -d ' ') git log entries"
dim "  $(grep -c '^## ADR-' docs/DECISIONS.md) ADRs (1 reversed)"
dim "  $(ls docs/eval-review-round-*.md 2>/dev/null | wc -l | tr -d ' ') multi-round review docs"
dim "  $(ls chat-archive/session-*.txt 2>/dev/null | wc -l | tr -d ' ') synthetic chat sessions"
dim "  Existing growth log from 2 weeks ago"
echo
sleep 1

bold "▸ Step 0 — Action Audit (the forcing function)"
echo "  Extracting level-up actions from docs/learning-domains.md..."
ACTIONS=$(grep -E "^[0-9]+\. (Write|Add|Generate|Run|Schedule)" docs/learning-domains.md | head -10)
ACTION_COUNT=$(echo "$ACTIONS" | wc -l | tr -d ' ')
echo "  Found $ACTION_COUNT actions in prior retro."
echo
echo "  Checking filesystem for named artifacts..."
PENDING=0
COMPLETED=0

check_artifact() {
  local name="$1"
  local path="$2"
  if [ -f "$path" ] || [ -d "$path" ]; then
    printf "    %s  %s\n" "$(green '✓')" "$name (exists)"
    COMPLETED=$((COMPLETED + 1))
  else
    printf "    %s  %s\n" "$(red '✗')" "$name (not started)"
    PENDING=$((PENDING + 1))
  fi
}

check_artifact "docs/STATS-CHEATSHEET.md" "docs/STATS-CHEATSHEET.md"
check_artifact "--explain-stats CLI flag in code" "<no code in fixture>"
check_artifact "docs/entity-erd.md" "docs/entity-erd.md"
check_artifact "per-type confusion matrix in eval" "<no code in fixture>"
check_artifact "Git pre-commit hook (late-night warning)" ".git/hooks/pre-commit"
check_artifact "docs/triggers.md (caching revisit conditions)" "docs/triggers.md"

echo
ylw "  Verdict: $COMPLETED completed, $PENDING pending. Days since proposed: 10."
echo
if [ "$PENDING" -ge 3 ] && [ "$COMPLETED" -eq 0 ]; then
  # 10 days is under the 14-day threshold — would hold off push-back
  ylw "  Step 0 rule: ≥3 pending AND 0 completed AND ≥14 days → push back."
  ylw "  Current: 10 days. Push-back HELD OFF (will fire at day 14 if state unchanged)."
  echo
  dim "  → Demo: skill correctly does NOT block scan yet. At day 14 it would block."
else
  green "  Step 0 PASS — proceeding to Step 1."
fi
echo
sleep 1

bold "▸ Step 1 — Scan signal sources"
echo
echo "  Multi-round review docs (strong signal — Tier 1 candidate):"
ls docs/eval-review-round-*.md | sed 's/^/    /'
echo
echo "  ADR reversals (strong signal — highest information):"
grep -E '^## ADR-' docs/DECISIONS.md | grep -E 'superseded|reverse' | sed 's/^/    /'
echo
echo "  Multi-version research docs:"
grep -i "research-2026-05\|research-2026-05-v2" docs/git-log.txt | head -3 | sed 's/^/    /'
echo
echo "  Chat archive — question-particle frequency:"
TOTAL_USER=$(cat chat-archive/session-*.txt | wc -l | tr -d ' ')
PARTICLES=$(grep -cE '什么是|啥意思|wait|forget|what is|怎么' chat-archive/session-*.txt | awk -F: '{s+=$2} END {print s}')
echo "    $PARTICLES question-particle hits across $TOTAL_USER user messages"
echo
echo "  Late-night session signal:"
grep -h "late\|02:30\|23:" chat-archive/session-*.txt | head -3 | sed 's/^/    /'
echo
sleep 1

bold "▸ Step 2 — Categorize signals (5-category sweep)"
echo
printf "  %-10s %s\n" "Category" "Items found"
printf "  %-10s %s\n" "──────────" "───────────"
printf "  %-10s %s\n" "Domain" "$(green '2 strong')"  "" ; echo
printf "  %-10s %s\n" "  " "  • Eval stats methodology (3 review rounds, repeated questions in chat)"
printf "  %-10s %s\n" "  " "  • Memory entity taxonomy (2 research-doc versions, 4-PR stack)"
echo
printf "  %-10s %s\n" "Human" "$(ylw '0') (no decision-velocity signal yet — needs more weeks)"
printf "  %-10s %s\n" "Habits" "$(ylw '1')"
printf "  %-10s %s\n" "  " "  • code-review fixes (max-effort pass) appears 2x — second-pass review pattern"
echo
printf "  %-10s %s\n" "Meta" "$(green '1 strong')"
printf "  %-10s %s\n" "  " "  • Late-night decision quality (named in session-3, reversal pattern)"
echo
printf "  %-10s %s\n" "Product." "$(ylw '1')"
printf "  %-10s %s\n" "  " "  • Late-night work pattern (3 sessions, self-identified)"
echo
sleep 1

bold "▸ Step 5 — Sample graduation marker proposed"
echo
echo "  For 'Eval stats methodology' (Tier 1):"
echo "    Graduation marker: 3 consecutive stats decisions land in PRs without"
echo "    re-deriving Wilson vs Clopper-Pearson in the same chat session."
echo "    Observable: grep chat archive for 'Wilson' or 'Clopper'. Bounded: 3 PRs."
echo "    Reversible: if 4th PR re-derives, item bounces back to Tier 1."
echo
sleep 1

bold "════════════════════════════════════════════════════════════════"
green "  ✓ "; echo "Demo complete."
dim "    A real /retrospective run on a real project would produce the full"
dim "    growth-log file with all 5 categories, action proposals, and"
dim "    graduation markers — see examples/anonymized-worked-example.md."
echo
dim "    To install:"
dim "      git clone https://github.com/YoungApple/growth-retrospective-skill \\"
dim "          ~/.claude/skills/growth-retrospective"
dim "      # Then: /retrospective in any Claude Code session"
echo
