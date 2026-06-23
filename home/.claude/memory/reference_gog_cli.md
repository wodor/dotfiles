---
name: gog CLI tool
description: User has gog (Google CLI) installed via Homebrew for Gmail, Calendar, Drive, etc. Used for email triage and management.
type: reference
---

`gog` (v0.12.0, Homebrew) is a Google CLI covering Gmail/Calendar/Drive/Docs/Sheets/etc.

Key Gmail commands:
- `gog mail search "<query>"` — search with Gmail query syntax, paginate with `--page <token>`
- `gog mail trash <id> ...` or `--query "<query>"` — trash messages
- `gog mail archive <id> ...` or `--query "<query>"` — archive (remove INBOX label)
- `gog mail mark-read <id> ...` — mark as read
- `gog mail get <id>` — full message details
- `gog mail send` — send email

Config: `~/Library/Application Support/gogcli/config.json`
Flags: `-j` JSON, `-p` plain/TSV, `-n` dry-run, `-y` force (skip confirm), `--max` limit with query mode
