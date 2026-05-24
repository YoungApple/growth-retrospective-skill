#!/usr/bin/env bash
# scan_git_signals.sh — extract decision-velocity signals from git history.
#
# Usage:
#   bash scan_git_signals.sh [<repo-path>] [<since>]
#
# Examples:
#   bash scan_git_signals.sh .                    # current repo, all history
#   bash scan_git_signals.sh ~/projects/foo 30    # last 30 days
#
# Output: structured signal summary on stdout (markdown).
# This is an accelerant — if it fails or the repo doesn't fit the
# expected shape, fall back to manual `git log` / `gh` inspection.

set -e

REPO_PATH="${1:-.}"
SINCE_DAYS="${2:-365}"
SINCE="$(date -v-${SINCE_DAYS}d '+%Y-%m-%d' 2>/dev/null || date -d "${SINCE_DAYS} days ago" '+%Y-%m-%d')"

cd "$REPO_PATH"

echo "# Git signal scan — $(basename "$(pwd)")"
echo
echo "Period: since $SINCE (last $SINCE_DAYS days)"
echo "Generated: $(date '+%Y-%m-%d %H:%M')"
echo

# --- ADR count ---
ADR_FILE="docs/DECISIONS.md"
if [[ -f "$ADR_FILE" ]]; then
    ADR_COUNT=$(grep -c '^## ADR-' "$ADR_FILE" || echo 0)
    echo "## ADR layer"
    echo
    echo "- Total ADRs: $ADR_COUNT"
    echo "- Recent ADR titles:"
    grep '^## ADR-' "$ADR_FILE" | tail -10 | sed 's/^## /  - /'
    echo
fi

# --- Multi-round review docs ---
echo "## Multi-round review docs (strong signal — Tier 1 candidate)"
echo
ROUND_DOCS=$(find docs -name '*review-round*.md' 2>/dev/null | sort)
if [[ -n "$ROUND_DOCS" ]]; then
    echo "$ROUND_DOCS" | while read -r doc; do
        LINES=$(wc -l < "$doc")
        echo "- \`$doc\` ($LINES lines)"
    done
else
    echo "(none found)"
fi
echo

# --- Multi-version research docs ---
echo "## Multi-version research docs"
echo
RESEARCH_V2=$(find docs -name '*research*-v2*.md' -o -name '*research*v2*.md' 2>/dev/null)
if [[ -n "$RESEARCH_V2" ]]; then
    echo "$RESEARCH_V2" | while read -r doc; do
        BASE=$(echo "$doc" | sed 's/-v2//' | sed 's/v2//')
        if [[ -f "$BASE" ]]; then
            V1_LINES=$(wc -l < "$BASE")
            V2_LINES=$(wc -l < "$doc")
            echo "- \`$BASE\` ($V1_LINES lines) + \`$doc\` ($V2_LINES lines) = $((V1_LINES + V2_LINES)) lines total"
        fi
    done
else
    echo "(none found)"
fi
echo

# --- Code-review fixes commits ---
echo "## Multi-pass review commits (medium signal — second/third pass caught more)"
echo
git log --since="$SINCE" --oneline --grep='code-review fixes\|max-effort pass\|code-review max-effort' 2>/dev/null | head -20 || true
echo

# --- Stacked PR patterns ---
echo "## Stacked PR patterns (focused ramp on one domain)"
echo
git log --since="$SINCE" --oneline --grep='PR-[A-Z]:\|Lane [A-Z]:' 2>/dev/null | head -20 || true
echo

# --- Reversal markers in commit messages ---
echo "## Reversal markers (strong signal)"
echo
git log --since="$SINCE" --oneline --grep='supersede\|reverse\|not planned\|deprecate\|abandon' -i 2>/dev/null | head -10 || true
echo

# --- Issue / PR archaeology via gh (if available) ---
if command -v gh >/dev/null 2>&1; then
    echo "## Reopened or closed-then-reissued issues (reversal signal)"
    echo
    gh issue list --state closed --search "closed:>${SINCE} reopened" --json number,title,labels --limit 10 2>/dev/null \
        | python3 -c "import json,sys
data = json.load(sys.stdin)
if not data:
    print('(none)')
for i in data:
    labels = ','.join(l['name'] for l in i.get('labels',[]))
    print(f\"- issue #{i['number']}: {i['title']}  [{labels}]\")" 2>/dev/null || echo "(gh query failed)"
    echo

    echo "## Open wedge-blocker / quality-debt issues (Tier 2 signal)"
    echo
    gh issue list --state open --label "wedge-blocker,quality-debt" --json number,title,labels --limit 20 2>/dev/null \
        | python3 -c "import json,sys
data = json.load(sys.stdin)
if not data:
    print('(none)')
for i in data:
    labels = ','.join(l['name'] for l in i.get('labels',[]))
    print(f\"- issue #{i['number']}: {i['title']}  [{labels}]\")" 2>/dev/null || echo "(gh query failed)"
    echo
fi

# --- Commit timestamp pattern (productivity signal) ---
echo "## Commit timestamp distribution (productivity signal)"
echo
echo "Hour-of-day commit count (UTC):"
git log --since="$SINCE" --pretty='%aI' 2>/dev/null | awk -F'T' '{print substr($2,1,2)}' | sort | uniq -c | awk '{printf "  %02d:00  %s\n", $2, $1}' || true
echo

echo "## End of scan"
