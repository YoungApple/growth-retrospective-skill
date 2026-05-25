# Security policy

This skill reads your project's git history, chat archive, and produces markdown files. It does not send data anywhere. Threat surface is small but worth being explicit about.

## What the skill reads

- `git log` / `gh issue list` output from your active project
- Session jsonl files under `~/.claude/projects/<id>/` (Claude Code's local chat archive)
- Existing growth-log files (`docs/learning-domains.md`, `memory/learning_domains.md`)

## What the skill writes

- Local markdown files in the paths above
- Optionally, files under `<repo>/growth/` if you opt into the operational logbook

## What the skill does NOT do

- ❌ Send your data to a remote server (no telemetry, no API calls beyond the agent's own)
- ❌ Read files outside the project root + the agent's memory dir
- ❌ Execute remote code or fetch from URLs (the bundled `scan_*` scripts run locally only)
- ❌ Modify git history or push anything

## Supply chain

The skill ships:
- 2 shell scripts (`scan_git_signals.sh`, `scan_chat_signals.py`) — read-only, runnable with `git` + Python stdlib only
- Markdown reference files
- Templates

No npm / pip / cargo / brew dependencies. You can audit the entire surface by reading the repo.

## Reporting a vulnerability

If you find a way the skill leaks data, executes unexpected code, or could be used to attack the user's host:

- **Critical (data exfiltration, RCE)**: email shuguo.yang2012@gmail.com with subject `[SECURITY] growth-retrospective-skill: <one-line summary>`. Expect a response within 7 days. Please **do not** open a public issue for these.
- **Non-critical (information disclosure, denial-of-service via malformed input)**: open a GitHub issue with label `security`.

When in doubt, email first. I'd rather field a false alarm than miss a real issue.

## Known limitations (not vulnerabilities, but worth noting)

- The skill reads your chat archive, which may contain API keys / passwords / personal info that you've shared with Claude in past sessions. The skill itself does not exfiltrate this — but be aware that your chat archive contains it, and the skill is one of many things that could read it. **The skill's chat scanner only looks at user messages 5–200 characters long and only extracts question particles + topic frequency** — full message content is not retained in the output.
- The skill writes markdown to your repo's `docs/` directory. If you commit that directory to a public repo, the growth log content goes public. Anonymize before committing or keep growth-log files in `.gitignore`.

## Trust gradient

This is a personal-growth tool, not a security-critical one. The cost of a bug is "wrong tier assignment" not "credentials leaked." But the skill does read sensitive files (chat archive), so the bar is "don't leak that data accidentally."

If you find the skill's threat model insufficient for your use case, the simplest mitigation is to run it on a clean clone with a scrubbed chat archive.
