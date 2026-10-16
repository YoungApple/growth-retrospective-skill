#!/usr/bin/env python3
"""render_quiz_html.py — compile an anchored Growth Retrospective quiz spec (JSON)
into a self-contained interactive HTML verification lab.

Usage:
    python3 scripts/render_quiz_html.py --spec path/to/quiz_spec.json --output path/to/quiz.html
    python3 scripts/render_quiz_html.py --demo --output /tmp/demo_quiz.html

Features:
    - Embeds both In-Agent Deep-Dive Briefing (4 pillars + code snippet) AND
      External Deep Research / NotebookLM copy-paste prompt per theme.
    - Interactive Calibration Bar (Learning Purpose + Default Study Mode).
    - 4-question Anchored MCQ engine with Predict-Then-Reveal gate, per-option
      explanations, and mandatory ground-truth artifact citations (<file>:<line> / ADR).
    - Live mastery scorecard + one-click Copy Mastery Receipt for agent chat.
"""

import argparse
import json
import os
import sys
from pathlib import Path


DEMO_SPEC = {
    "id": "demo-retro-2026",
    "project": "demo-project",
    "date": "2026-10-16",
    "title": "Growth Retrospective · Interactive Verification Lab",
    "subtitle": "Every question is anchored to your own repository files, ADRs, and commits.",
    "purpose": "guardrail",
    "defaultStudyMode": "in-agent",
    "themes": [
        {
            "title": "Zero-Fabrication Data Grounding",
            "tier": "Tier 1",
            "category": "work habit",
            "anchor": "generator.py:27-55",
            "anchorSnippet": "def calculate_trip_metrics(trip_config: dict) -> dict:\n    # Haversine distance across real places coordinates\n    total_dist += haversine(p1['lat'], p1['lng'], p2['lat'], p2['lng'])",
            "briefing": {
                "whyItMatters": "Hardcoded mock numbers masquerading as real telemetry erode user trust and mask missing data pipelines.",
                "failureModes": "Silent deployment of fake stats (e.g. 29,850 km or fake camera EXIF) to production pages.",
                "stackPattern": "Compute derived metrics deterministically in Python/JS from verified schema inputs, and render interactive empty-state dropzones for uncollected user data.",
                "misconceptions": "Thinking 'placeholder copy looks better for demos' — in production tools, honest empty states + functional parsers beat fake numbers every time."
            },
            "researchPrompt": "I'm building an offline-first web app generator. I need to enforce Zero-Fabrication Data Grounding in generator.py:27-55.\n1. What architectural patterns prevent AI-generated templates from leaking mock statistics?\n2. How to design high-utility empty states with client-side file parsers?\n3. What automated lint checks catch ungrounded numbers in CI?",
            "levelUpActions": [
                "Add tests/test_zero_fabrication.py to fail CI if any compiled HTML contains hardcoded mock strings.",
                "Extract reusable client-side GPX/EXIF dropzone component."
            ],
            "questions": [
                {
                    "form": "STATE",
                    "question": "How does generator.py:calculate_trip_metrics compute the route distance?",
                    "options": [
                        "Reads a static distance string from the template",
                        "Applies the Haversine spherical formula across consecutive (lat, lng) pairs in trip_config['places']",
                        "Calls an external Google Maps Directions API at runtime",
                        "Multiplies total days by an average daily mileage constant"
                    ],
                    "correctIndex": 1,
                    "explanation": "calculate_trip_metrics iterates over consecutive places with lat/lng and sums haversine() distances.",
                    "groundTruth": "See generator.py:27-45 (calculate_trip_metrics)"
                },
                {
                    "form": "PREDICT-THEN-REVEAL",
                    "question": "Before revealing the design rationale: why did we replace the static expense table with a localStorage-backed interactive ledger?",
                    "options": [
                        "To reduce HTML file size below 10KB",
                        "Because real post-trip expenses didn't exist in the repo yet; a functional ledger lets the user record/import real data instead of displaying hallucinated numbers",
                        "Because Tailwind CSS tables don't support mobile scrolling",
                        "To require a backend SQL database"
                    ],
                    "correctIndex": 1,
                    "explanation": "When content doesn't exist yet, the system must provide structure and functions (interactive ledger + CSV import/export) rather than fake content.",
                    "groundTruth": "See templates/debrief/index.html:200-310 (Interactive Expense Ledger)"
                }
            ]
        }
    ]
}


def validate_spec(spec: dict) -> list:
    """Return a list of validation warnings/errors."""
    errors = []
    if not isinstance(spec, dict):
        return ["Spec root must be a JSON object."]
    themes = spec.get("themes")
    if not isinstance(themes, list) or len(themes) == 0:
        errors.append("Spec must contain a non-empty 'themes' list.")
        return errors

    for t_idx, theme in enumerate(themes):
        t_title = theme.get("title", f"theme[{t_idx}]")
        if not theme.get("anchor"):
            errors.append(f"Theme '{t_title}' is missing 'anchor' (<file>:<line> or ADR).")
        questions = theme.get("questions", [])
        for q_idx, q in enumerate(questions):
            if not q.get("groundTruth"):
                errors.append(
                    f"Theme '{t_title}' Q{q_idx + 1} is missing mandatory 'groundTruth' citation."
                )
            if "correctIndex" not in q or not isinstance(q.get("options"), list):
                errors.append(
                    f"Theme '{t_title}' Q{q_idx + 1} must define 'options' list and 'correctIndex'."
                )
    return errors


def render_html(spec: dict, template_path: Path) -> str:
    tpl = template_path.read_text(encoding="utf-8")
    title = spec.get("title") or f"{spec.get('project', 'Project')} — Growth Retrospective"
    # Escape closing script tags inside JSON string to prevent premature script termination
    payload_json = json.dumps(spec, ensure_ascii=False, indent=2).replace("</", "<\\/")
    html = tpl.replace("{{TITLE}}", title).replace("{{QUIZ_JSON_PAYLOAD}}", payload_json)
    return html


def main():
    parser = argparse.ArgumentParser(
        description="Compile a Growth Retrospective JSON quiz spec into an interactive HTML app."
    )
    parser.add_argument(
        "--spec",
        help="Path to input JSON quiz specification (use '-' for stdin).",
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Output path for the generated self-contained HTML file.",
    )
    parser.add_argument(
        "--demo",
        action="store_true",
        help="Render using the built-in demo specification (for smoke testing).",
    )
    parser.add_argument(
        "--template",
        help="Optional override path to interactive_quiz.html template.",
    )
    args = parser.parse_args()

    script_dir = Path(__file__).resolve().parent
    skill_root = script_dir.parent
    template_path = (
        Path(args.template)
        if args.template
        else skill_root / "assets" / "templates" / "interactive_quiz.html"
    )

    if not template_path.is_file():
        print(f"Error: template not found at {template_path}", file=sys.stderr)
        sys.exit(1)

    if args.demo:
        spec = DEMO_SPEC
    elif args.spec:
        if args.spec == "-":
            spec = json.load(sys.stdin)
        else:
            with open(args.spec, "r", encoding="utf-8") as f:
                spec = json.load(f)
    else:
        parser.error("Either --spec <path> or --demo is required.")

    errors = validate_spec(spec)
    if errors:
        for err in errors:
            print(f"Validation error: {err}", file=sys.stderr)
        sys.exit(1)

    html = render_html(spec, template_path)
    out_path = Path(args.output)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(html, encoding="utf-8")
    print(f"✅ Generated interactive HTML verification lab: {out_path} ({len(html) // 1024} KB)")


if __name__ == "__main__":
    main()
