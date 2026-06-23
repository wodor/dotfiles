#!/usr/bin/env python3
"""Logs skill invocations to ~/.claude/hooks-logs/skills.jsonl.

Catches two sources:
- PreToolUse with tool_name==Skill (Claude-initiated via Skill tool)
- UserPromptSubmit with prompt starting with / (user-initiated slash commands)
"""

import sys
import json
from datetime import datetime
from pathlib import Path


def main():
    data = {}
    try:
        raw = sys.stdin.read()
        if raw:
            data = json.loads(raw)
    except (json.JSONDecodeError, ValueError):
        pass

    event = data.get("hook_event_name", "")
    entry = None

    if event == "PreToolUse" and data.get("tool_name") == "Skill":
        entry = {
            "ts": datetime.now().isoformat(),
            "source": "agent",
            "session_id": data.get("session_id", ""),
            "cwd": data.get("cwd", ""),
            "skill": data.get("tool_input", {}).get("skill", ""),
            "args": data.get("tool_input", {}).get("args", ""),
        }
    elif event == "UserPromptSubmit":
        prompt = data.get("prompt", "")
        # Claude Code requires prompt to start with / (XdH function in binary)
        if prompt.strip().startswith("/"):
            parts = prompt.strip()[1:].split(None, 1)
            if parts:
                entry = {
                    "ts": datetime.now().isoformat(),
                    "source": "slash_command",
                    "session_id": data.get("session_id", ""),
                    "cwd": data.get("cwd", ""),
                    "skill": parts[0],
                    "args": parts[1] if len(parts) > 1 else "",
                }

    if entry:
        log_file = Path.home() / ".claude" / "hooks-logs" / "skills.jsonl"
        log_file.parent.mkdir(parents=True, exist_ok=True)
        with open(log_file, "a") as f:
            f.write(json.dumps(entry) + "\n")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"[skill-logger] Error: {e}", file=sys.stderr)
