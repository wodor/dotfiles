#!/usr/bin/env bash
# install.sh — Dotfiles setup script for Coder workspaces (and any new dev machine).
#
# Idempotent: safe to run multiple times.
# Handles missing source files gracefully (warns, does not abort).
# Secrets: never committed here. Use Coder User Secrets or op run for tokens/keys.
#
# What this does:
#   1. Overlays ~/.claude/ context files (memory, skills, hooks, config)
#   2. Fixes paths in settings.json hooks to use $HOME (not hardcoded /Users/...)
#   3. Symlinks home/.* dotfiles (git, zsh, etc.) into $HOME
#   4. Skips macOS-only and binary-dependent features when missing

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SRC="$DOTFILES_DIR/home/.claude"
CLAUDE_DST="$HOME/.claude"

log()  { echo "[dotfiles] $*"; }
warn() { echo "[dotfiles] WARNING: $*" >&2; }
skip() { echo "[dotfiles] SKIP: $*" >&2; }

# ---------------------------------------------------------------------------
# 1. Claude Code context overlay
# ---------------------------------------------------------------------------

overlay_claude() {
  if [ ! -d "$CLAUDE_SRC" ]; then
    skip ".claude source directory not found in dotfiles — skipping Claude overlay"
    return 0
  fi

  log "Overlaying Claude Code context into $CLAUDE_DST ..."
  mkdir -p "$CLAUDE_DST"

  # --- Top-level instruction files ---
  for f in CLAUDE.md RTK.md policy-limits.json; do
    src="$CLAUDE_SRC/$f"
    dst="$CLAUDE_DST/$f"
    if [ -f "$src" ]; then
      if [ ! -f "$dst" ]; then
        cp "$src" "$dst"
        log "  installed: $f"
      else
        log "  skip (exists): $f"
      fi
    else
      skip "$f not found in dotfiles — skipping"
    fi
  done

  # --- .mcp.json — MCP server config ---
  # We ship a template with $HOME placeholder; expand it on install.
  if [ -f "$CLAUDE_SRC/.mcp.json" ]; then
    if [ ! -f "$CLAUDE_DST/.mcp.json" ]; then
      # Expand $HOME and ~/ in the template to the actual home path
      sed "s|\$HOME|$HOME|g; s|~/|$HOME/|g" "$CLAUDE_SRC/.mcp.json" > "$CLAUDE_DST/.mcp.json"
      log "  installed: .mcp.json (paths expanded)"
    else
      log "  skip (exists): .mcp.json"
    fi
  fi

  # --- Memory files ---
  if [ -d "$CLAUDE_SRC/memory" ]; then
    mkdir -p "$CLAUDE_DST/memory"
    for f in "$CLAUDE_SRC/memory/"*.md; do
      [ -f "$f" ] || continue
      fname="$(basename "$f")"
      dst="$CLAUDE_DST/memory/$fname"
      if [ ! -f "$dst" ]; then
        cp "$f" "$dst"
        log "  installed: memory/$fname"
      else
        log "  skip (exists): memory/$fname"
      fi
    done
  fi

  # --- Skills ---
  if [ -d "$CLAUDE_SRC/skills" ]; then
    mkdir -p "$CLAUDE_DST/skills"
    for skill_dir in "$CLAUDE_SRC/skills"/*/; do
      [ -d "$skill_dir" ] || continue
      skill_name="$(basename "$skill_dir")"
      dst_skill="$CLAUDE_DST/skills/$skill_name"
      if [ ! -d "$dst_skill" ]; then
        cp -r "$skill_dir" "$dst_skill"
        log "  installed: skills/$skill_name"
      else
        log "  skip (exists): skills/$skill_name"
      fi
    done
  fi

  # --- Hook scripts (Python) ---
  if [ -d "$CLAUDE_SRC/hook-scripts" ]; then
    mkdir -p "$CLAUDE_DST/hook-scripts"
    for f in "$CLAUDE_SRC/hook-scripts/"*.py; do
      [ -f "$f" ] || continue
      fname="$(basename "$f")"
      dst="$CLAUDE_DST/hook-scripts/$fname"
      if [ ! -f "$dst" ]; then
        cp "$f" "$dst"
        chmod +x "$dst"
        log "  installed: hook-scripts/$fname"
      else
        log "  skip (exists): hook-scripts/$fname"
      fi
    done
  fi

  # --- Hook shell scripts ---
  if [ -d "$CLAUDE_SRC/hooks" ]; then
    mkdir -p "$CLAUDE_DST/hooks"
    for f in "$CLAUDE_SRC/hooks/"*.sh; do
      [ -f "$f" ] || continue
      fname="$(basename "$f")"
      dst="$CLAUDE_DST/hooks/$fname"
      if [ ! -f "$dst" ]; then
        cp "$f" "$dst"
        chmod +x "$dst"
        log "  installed: hooks/$fname"
      else
        log "  skip (exists): hooks/$fname"
      fi
    done
  fi

  # --- settings.json ---
  # Install a workspace-safe settings template if no settings exist yet.
  # The workspace_settings.json in this repo has path placeholders replaced.
  src_settings="$CLAUDE_SRC/workspace_settings.json"
  dst_settings="$CLAUDE_DST/settings.json"
  if [ -f "$src_settings" ] && [ ! -f "$dst_settings" ]; then
    sed "s|\$HOME|$HOME|g; s|~/|$HOME/|g" "$src_settings" > "$dst_settings"
    log "  installed: settings.json (paths expanded)"
  elif [ ! -f "$src_settings" ]; then
    log "  no workspace_settings.json found — skipping settings install"
  else
    log "  skip (exists): settings.json"
  fi

  log "Claude overlay complete."
}

# ---------------------------------------------------------------------------
# 2. Home dotfiles symlinks (git, zsh)
# ---------------------------------------------------------------------------

link_home_dotfiles() {
  local home_src="$DOTFILES_DIR/home"
  if [ ! -d "$home_src" ]; then
    skip "home/ directory not found — skipping dotfile symlinks"
    return 0
  fi

  log "Linking home dotfiles ..."
  # Traverse files in home/, create relative symlinks in $HOME
  find "$home_src" -maxdepth 1 -name ".*" -not -name ".claude" | while read -r src; do
    fname="$(basename "$src")"
    dst="$HOME/$fname"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      log "  skip (already linked): $fname"
    elif [ -f "$dst" ] || [ -d "$dst" ]; then
      warn "$fname already exists in \$HOME (not a symlink to dotfiles) — skipping to avoid overwrite"
    else
      ln -sf "$src" "$dst"
      log "  linked: $fname -> $src"
    fi
  done
}

# ---------------------------------------------------------------------------
# 3. Binary dependency hints (non-fatal)
# ---------------------------------------------------------------------------

check_deps() {
  log "Checking optional tool dependencies ..."

  command -v rtk >/dev/null 2>&1 \
    && log "  rtk: found ($(rtk --version 2>/dev/null | head -1 || echo 'version unknown'))" \
    || warn "rtk not found — rtk-rewrite.sh hook will self-disable gracefully. Install: https://github.com/rtk-ai/rtk"

  command -v jq >/dev/null 2>&1 \
    && log "  jq: found" \
    || warn "jq not found — rtk hook requires it. Install: sudo apt install jq / brew install jq"

  command -v python3 >/dev/null 2>&1 \
    && log "  python3: found" \
    || warn "python3 not found — hook scripts require it"

  if [[ "$(uname)" == "Darwin" ]]; then
    log "  Platform: macOS — all features available"
  else
    log "  Platform: $(uname) — macOS-only hooks (notify.py) not installed (by design)"
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

log "=== Dotfiles install start ==="
log "Dotfiles dir: $DOTFILES_DIR"
log "Home: $HOME"

overlay_claude
link_home_dotfiles
check_deps

log "=== Dotfiles install complete ==="
