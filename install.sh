#!/usr/bin/env bash
#
# growth-retrospective-skill installer
#
# One-line install across Claude Code / Codex CLI / Antigravity:
#   curl -fsSL https://raw.githubusercontent.com/YoungApple/growth-retrospective-skill/main/install.sh | bash
#
# Or clone-first if you want to inspect before running (recommended):
#   git clone https://github.com/YoungApple/growth-retrospective-skill /tmp/grs
#   cat /tmp/grs/install.sh   # audit
#   bash /tmp/grs/install.sh
#
# What it does:
#   1. Clones (or updates) the repo into ~/.claude/skills/growth-retrospective/ as canonical
#   2. Detects which agents you have installed (Claude Code, Codex CLI, Antigravity)
#   3. Creates symlinks from each agent's skills directory to the canonical install
#   4. Prints a one-liner showing what to type next

set -euo pipefail

REPO_URL="https://github.com/YoungApple/growth-retrospective-skill.git"
CANONICAL="$HOME/.claude/skills/growth-retrospective"

# ── colours (degrade gracefully on dumb terminals) ───────────────────────────
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
  BOLD=$(printf '\033[1m'); DIM=$(printf '\033[2m')
  GREEN=$(printf '\033[32m'); YLW=$(printf '\033[33m'); RED=$(printf '\033[31m')
  RESET=$(printf '\033[0m')
else
  BOLD=''; DIM=''; GREEN=''; YLW=''; RED=''; RESET=''
fi

say()  { printf '%s\n' "$*"; }
ok()   { printf '%s✓%s %s\n' "$GREEN" "$RESET" "$*"; }
warn() { printf '%s⚠%s %s\n' "$YLW" "$RESET" "$*"; }
err()  { printf '%s✗%s %s\n' "$RED" "$RESET" "$*" >&2; }
hdr()  { printf '\n%s%s%s\n' "$BOLD" "$*" "$RESET"; }

# ── pre-flight ───────────────────────────────────────────────────────────────
hdr "growth-retrospective installer"
say "${DIM}Repo: $REPO_URL${RESET}"

if ! command -v git >/dev/null 2>&1; then
  err "git is required but not installed. Install git first, then re-run."
  exit 1
fi

# ── canonical install / update ───────────────────────────────────────────────
mkdir -p "$(dirname "$CANONICAL")"

if [ -d "$CANONICAL/.git" ]; then
  hdr "Updating existing install"
  cd "$CANONICAL"
  CURRENT_REMOTE=$(git config --get remote.origin.url || echo "unknown")
  if [ "$CURRENT_REMOTE" != "$REPO_URL" ]; then
    warn "$CANONICAL has remote=$CURRENT_REMOTE (expected $REPO_URL)"
    warn "Keeping existing remote. To override, rm -rf $CANONICAL and re-run."
  fi
  git fetch origin --quiet
  git pull --ff-only --quiet || warn "Could not fast-forward (uncommitted changes? local branch ahead?). Skipping update."
  ok "Updated $CANONICAL"
elif [ -e "$CANONICAL" ]; then
  err "$CANONICAL exists but is not a git repo. Refusing to overwrite."
  err "Move or remove it first, then re-run."
  exit 1
else
  hdr "Cloning canonical install"
  git clone --depth 1 --quiet "$REPO_URL" "$CANONICAL"
  ok "Cloned to $CANONICAL"
fi

# ── agent detection + symlink ────────────────────────────────────────────────
hdr "Setting up agent integrations"

INSTALLED_AGENTS=()
SKIPPED_AGENTS=()

link_for_agent() {
  local agent_name="$1"
  local target_dir="$2"
  local link_path="$target_dir/growth-retrospective"

  if [ ! -d "$target_dir" ]; then
    SKIPPED_AGENTS+=("$agent_name (no $target_dir — agent not installed?)")
    return
  fi

  if [ -L "$link_path" ]; then
    local existing
    existing=$(readlink "$link_path")
    if [ "$existing" = "$CANONICAL" ]; then
      ok "$agent_name: symlink already points to canonical install"
      INSTALLED_AGENTS+=("$agent_name")
      return
    else
      warn "$agent_name: symlink exists but points to $existing. Replacing."
      rm "$link_path"
    fi
  elif [ -e "$link_path" ]; then
    warn "$agent_name: $link_path exists and is NOT a symlink. Skipping (move it if you want to install here)."
    SKIPPED_AGENTS+=("$agent_name (path exists, not symlink)")
    return
  fi

  ln -s "$CANONICAL" "$link_path"
  ok "$agent_name: symlinked $link_path -> $CANONICAL"
  INSTALLED_AGENTS+=("$agent_name")
}

# Claude Code (always — the canonical install IS here)
INSTALLED_AGENTS+=("Claude Code (canonical)")

# Codex CLI
link_for_agent "OpenAI Codex CLI" "$HOME/.codex/skills"

# Google Antigravity
mkdir -p "$HOME/.gemini/antigravity/skills" 2>/dev/null || true
link_for_agent "Google Antigravity" "$HOME/.gemini/antigravity/skills"

# Agent-neutral location (gstack convention)
link_for_agent "Agent-neutral (~/.agents/skills)" "$HOME/.agents/skills"

# ── summary ──────────────────────────────────────────────────────────────────
hdr "Installation complete"
say ""
say "${BOLD}Installed for:${RESET}"
for agent in "${INSTALLED_AGENTS[@]}"; do
  say "  ${GREEN}✓${RESET} $agent"
done

if [ ${#SKIPPED_AGENTS[@]} -gt 0 ]; then
  say ""
  say "${BOLD}Skipped:${RESET}"
  for agent in "${SKIPPED_AGENTS[@]}"; do
    say "  ${DIM}-${RESET} $agent"
  done
fi

say ""
say "${BOLD}Next steps:${RESET}"
say "  1. Try the demo (5 sec, no LLM call):"
say "     ${DIM}bash $CANONICAL/examples/demo-fixture/demo.sh${RESET}"
say ""
say "  2. Run on your own project (in any of the installed agents above):"
say "     ${DIM}/retrospective${RESET}"
say "     or speak keywords: ${DIM}'what are my gaps' / 'review my growth' / 'am I improving'${RESET}"
say ""
say "  3. Read what to expect:"
say "     ${DIM}$CANONICAL/README.md${RESET}"
say "     ${DIM}$CANONICAL/examples/anonymized-worked-example.md${RESET}"
say ""

VERSION=$(cd "$CANONICAL" && git describe --tags --always 2>/dev/null || echo "main")
say "${DIM}Version: $VERSION${RESET}"
say ""
