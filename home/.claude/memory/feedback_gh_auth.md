---
name: gh auth via 1Password
description: Use `op run -- gh auth status` (and op run -- gh ...) for all gh CLI calls requiring auth
type: feedback
---

Use `op run -- gh` prefix for all `gh` CLI commands that require authentication (e.g. `op run -- gh auth status`, `op run -- gh pr create`).

**Why:** gh credentials stored in 1Password; `op run --` injects them into the environment so gh can authenticate.

**How to apply:** Any time you'd run a `gh` command, prefix with `op run -- `. E.g. `op run -- gh pr list`, `op run -- gh pr create ...`.
