#!/usr/bin/env python3
"""scan_chat_signals.py — extract decision-velocity signals from chat history.

Usage:
    python scan_chat_signals.py --project-id <ID> [--days N] [--topics topic1,topic2,...]

Examples:
    python scan_chat_signals.py --project-id=-Users-youngapple-claude-workspace-foo
    python scan_chat_signals.py --project-id=<ID> --days 30 --topics eval,memory,gemini

Note: project IDs in ~/.claude/projects/ start with '-' (they encode the
absolute path with slashes replaced by dashes). MUST use the `=` form
(`--project-id=-...`) since argparse otherwise treats the leading dash
of the project ID as a new flag.

Project ID is the directory name under ~/.claude/projects/. The script
reads all *.jsonl files there, extracts user messages, and surfaces:

  1. Question-particle frequency (啥意思? / 为什么? / what is / explain ...).
  2. In-flight definition probing (X means Y, right? patterns).
  3. Per-topic frequency in short user messages (for keywords you supply).
  4. Repeated meta-instruction count (language preference, GH prefix, etc.).
  5. Short user message sample for human review.

Output: markdown to stdout.

This is an accelerant — if it fails or jsonl format changes, fall back
to manual grep on the session files.
"""
import json
import sys
import re
import os
import argparse
from collections import Counter
from pathlib import Path
from datetime import datetime, timedelta, timezone


QUESTION_PATTERNS = [
    # Chinese
    r'为什么', r'什么意思', r'什么是', r'不懂', r'不太懂', r'不明白', r'没懂',
    r'再说一遍', r'再解释', r'展开', r'怎么理解', r'怎么回事',
    r'我不熟悉', r'没听过', r'啥意思',
    r'举个例子', r'类比', r'通俗', r'用人话',
    # English
    r'\bwhat\s+is\b', r'\bexplain\b', r'\bclarify\b', r'\bdon\'t understand\b',
    r'\bconfused\b', r'\bnot sure what\b',
]
QRE = re.compile('|'.join(QUESTION_PATTERNS), re.IGNORECASE)

# In-flight definition probing: "X means Y" / "X is Y, right?"
PROBE_PATTERNS = [
    r'\bmeans\b.*\?', r'\bis\s+\w+,?\s*right\b', r'是不是.*\?',
    r'对不对', r'是这样吗',
]
PROBE_RE = re.compile('|'.join(PROBE_PATTERNS), re.IGNORECASE)


def extract_text(msg):
    if not msg:
        return ''
    if isinstance(msg, str):
        return msg
    if isinstance(msg, list):
        out = []
        for block in msg:
            if isinstance(block, dict):
                if block.get('type') == 'text':
                    out.append(block.get('text', ''))
                elif 'text' in block:
                    out.append(block.get('text', ''))
        return '\n'.join(out)
    if isinstance(msg, dict):
        return msg.get('content', '') or msg.get('text', '')
    return ''


def iter_user_messages(jsonl_path, since_dt=None):
    """Yield (timestamp_str, text) for user messages in one jsonl file."""
    try:
        with open(jsonl_path, encoding='utf-8', errors='replace') as f:
            for line in f:
                try:
                    d = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if d.get('type') != 'user':
                    continue
                ts = d.get('timestamp', '')
                if since_dt and ts:
                    try:
                        msg_dt = datetime.fromisoformat(ts.replace('Z', '+00:00'))
                        if msg_dt < since_dt:
                            continue
                    except ValueError:
                        pass
                msg = d.get('message', {})
                content = msg.get('content') if isinstance(msg, dict) else None
                text = extract_text(content)
                if not text:
                    continue
                # Skip synthetic / tool result / command messages.
                if text.startswith('<') or 'tool_use_id' in text[:100]:
                    continue
                if 'system-reminder' in text[:200] or '<command-' in text[:50]:
                    continue
                yield ts, text
    except (IOError, OSError):
        return


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    parser.add_argument('--project-id', dest='project_id', required=True,
                        help='Project dir name under ~/.claude/projects/ (often starts with "-")')
    parser.add_argument('--days', type=int, default=None,
                        help='Look only at messages from the last N days.')
    parser.add_argument('--topics', default='',
                        help='Comma-separated topic keywords to count per-topic frequency.')
    parser.add_argument('--limit-samples', type=int, default=30,
                        help='How many short-user-message samples to print.')
    args = parser.parse_args()

    project_dir = Path.home() / '.claude' / 'projects' / args.project_id
    if not project_dir.is_dir():
        print(f"Error: project dir not found: {project_dir}", file=sys.stderr)
        sys.exit(1)

    since_dt = None
    if args.days:
        since_dt = datetime.now(timezone.utc) - timedelta(days=args.days)

    jsonl_files = sorted(project_dir.glob('*.jsonl'))
    if not jsonl_files:
        print(f"No .jsonl files in {project_dir}", file=sys.stderr)
        sys.exit(1)

    topic_keys = [t.strip() for t in args.topics.split(',') if t.strip()]

    # Counters
    n_user_total = 0
    n_clarify = 0
    n_probe = 0
    n_short = 0
    clarify_samples = []
    probe_samples = []
    short_samples = []
    topic_counts = Counter()

    for jf in jsonl_files:
        short_name = jf.name[:8]
        for ts, text in iter_user_messages(jf, since_dt):
            n_user_total += 1
            short_text = text.strip()
            if len(short_text) > 600:
                continue
            tl = short_text.lower()
            # Clarification signal
            if QRE.search(short_text):
                n_clarify += 1
                clarify_samples.append((short_name, ts[:10], short_text[:200]))
            # In-flight probe signal
            if PROBE_RE.search(short_text):
                n_probe += 1
                probe_samples.append((short_name, ts[:10], short_text[:200]))
            # Short user messages
            if 5 < len(short_text) < 200:
                n_short += 1
                short_samples.append((short_name, ts[:10], short_text))
                # Per-topic frequency
                for topic in topic_keys:
                    if topic.lower() in tl:
                        topic_counts[topic] += 1

    # --- Output ---
    print("# Chat signal scan")
    print()
    print(f"Project: {args.project_id}")
    print(f"Sessions scanned: {len(jsonl_files)}")
    print(f"User messages total: {n_user_total}")
    if since_dt:
        print(f"Period: last {args.days} days (since {since_dt.date()})")
    print()

    print("## Clarification-style messages")
    print()
    print(f"Count: **{n_clarify}** ({n_clarify*100//max(n_user_total,1)}% of user msgs)")
    if clarify_samples:
        print()
        print("Recent samples:")
        for f, d, t in clarify_samples[-15:]:
            print(f"- `[{d} {f}]` {t[:160]}")
    print()

    print("## In-flight definition probing")
    print()
    print(f"Count: **{n_probe}** ({n_probe*100//max(n_user_total,1)}% of user msgs)")
    if probe_samples:
        print()
        print("Recent samples:")
        for f, d, t in probe_samples[-10:]:
            print(f"- `[{d} {f}]` {t[:160]}")
    print()

    if topic_keys:
        print("## Per-topic frequency in short user messages")
        print()
        for topic, count in sorted(topic_counts.items(), key=lambda x: -x[1]):
            print(f"- **{topic}**: {count}")
        print()

    print("## Short user message sample")
    print()
    print(f"Total short msgs: {n_short}")
    seen = set()
    n_shown = 0
    print()
    for f, d, t in short_samples:
        key = t[:60]
        if key in seen:
            continue
        seen.add(key)
        n_shown += 1
        if n_shown > args.limit_samples:
            break
        print(f"- `[{d}]` {t[:160]}")


if __name__ == '__main__':
    main()
