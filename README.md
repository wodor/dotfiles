# Private Dotfiles

Personal dotfiles for macOS and Coder (Linux) workspaces.

## Quick Start

```bash
# Clone and apply
git clone https://github.com/wodor/dotfiles ~/dotfiles
cd ~/dotfiles
bash install.sh
```

Or, in a Coder workspace via the dotfiles module:

```
coder dotfiles https://github.com/wodor/dotfiles
```

---

## Claude Code Context Overlay

The `home/.claude/` directory contains personal Claude Code context files that
are automatically overlaid into `~/.claude/` when the dotfiles are applied.

### What gets installed

| Path | Purpose |
|---|---|
| `~/.claude/CLAUDE.md` | Global instructions injected into every session |
| `~/.claude/RTK.md` | RTK tool reference (referenced from CLAUDE.md) |
| `~/.claude/memory/*.md` | Personal memory: procedural corrections + tool references |
| `~/.claude/skills/*/` | Portable skill directories (cua-driver, gh-cli, python-development, codebase-memory) |
| `~/.claude/hooks/rtk-rewrite.sh` | Hook: rewrites Bash commands via rtk for token savings |
| `~/.claude/hook-scripts/event-logger.py` | Hook: logs lifecycle events to ~/.claude/hooks-logs/ |
| `~/.claude/hook-scripts/skill-logger.py` | Hook: logs skill invocations |
| `~/.claude/policy-limits.json` | Auto-approval/block policy |
| `~/.claude/.mcp.json` | MCP server config (paths expanded to $HOME at install time) |
| `~/.claude/settings.json` | Workspace-safe settings (installed only if no settings.json present) |

### Overlay behaviour

- **Idempotent**: files that already exist in `~/.claude/` are skipped — local
  workspace overrides win. Re-running `install.sh` never clobbers existing
  local config.
- **Additive**: new files from dotfiles are installed; existing ones are left alone.
- **Safe defaults**: `settings.json` is only installed if `~/.claude/settings.json`
  does not already exist, so workspace-level config is never wiped.

### What is NOT committed

These are intentionally excluded from version control:

- `~/.claude/history.jsonl` — session history (~3MB, personal, machine-specific)
- `~/.claude/projects/` — per-project session state, path-keyed to local filesystem
- `~/.claude/sessions/`, `session-env/`, `shell-snapshots/` — active session state
- `~/.claude/telemetry/`, `cache/`, `paste-cache/`, etc. — ephemeral runtime data
- `~/.claude.json` — instance-specific state and cached feature flags
- Any file matching `*secret*`, `*token*`, `*.key` — safety net

### macOS vs Linux / Coder workspaces

The `notify.py` hook (macOS desktop notifications via AppleScript) is
intentionally excluded from dotfiles — it's macOS-only and not meaningful in a
headless Coder workspace. All other hooks are portable; the `rtk-rewrite.sh`
hook gracefully no-ops if `rtk` or `jq` are not installed.

### Configuring your personal Claude context path

By default, `install.sh` reads Claude files from `home/.claude/` inside the
dotfiles repo. To point it at a different source (e.g. a separate private repo):

1. Set `CLAUDE_CONTEXT_REPO` before running:
   ```bash
   export CLAUDE_CONTEXT_REPO=/path/to/your/private-claude-context
   bash install.sh
   ```
   *(install.sh will check this env var if present — see the script for details)*

2. Or maintain a separate private repo and run both:
   ```bash
   bash ~/dotfiles/install.sh            # public dotfiles (git, zsh, etc.)
   bash ~/private-claude/install.sh      # private Claude context (if separate)
   ```

### Opting out

To skip the Claude overlay entirely:

```bash
SKIP_CLAUDE=1 bash install.sh
```

To opt out of a specific file, create an empty placeholder before running:

```bash
touch ~/.claude/settings.json   # install.sh will see it exists and skip
```

### Secrets and sensitive context

Never commit secrets to this repo. Use:

- **Coder User Secrets** — inject API tokens as env vars at workspace start
- **1Password CLI** (`op run --`) — inject secrets at runtime without storing them
- **Coder `~/personalize`** — run secret-fetching logic on workspace boot

Example in `~/personalize`:
```bash
#!/bin/bash
# Fetch private Claude memory from a private source (never stored in dotfiles)
op read "op://Personal/claude-private-memory/notes" > ~/.claude/memory/private_context.md
```

---

## Coder Template Integration

If your Coder workspace template uses the dotfiles module, add to your Terraform:

```hcl
module "dotfiles" {
  source              = "registry.coder.com/modules/dotfiles/coder"
  version             = "~> 1.0"
  agent_id            = coder_agent.main.id
  default_dotfiles_uri = "https://github.com/wodor/dotfiles"
}
```

Users can also override with their own fork at workspace creation time.

---

## Structure

```
dotfiles/
├── install.sh              # Coder/machine setup script (entry point)
├── home/
│   ├── .gitconfig          # Git config
│   ├── .gitignore          # Global gitignore
│   ├── .zshrc              # Zsh config
│   ├── .zsh/               # Zsh modules (aliases, completion, history...)
│   └── .claude/            # Claude Code context overlay
│       ├── CLAUDE.md
│       ├── RTK.md
│       ├── policy-limits.json
│       ├── .mcp.json
│       ├── workspace_settings.json
│       ├── memory/
│       ├── skills/
│       ├── hooks/
│       └── hook-scripts/
└── README.md
```
