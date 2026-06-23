---
name: Always archive whole threads
description: When archiving emails with gog, always use thread-level operations instead of individual message IDs
type: feedback
---

Always archive whole threads, not individual messages.

**Why:** Archiving individual message IDs leaves other messages in the same thread still in the inbox, so the thread keeps showing up.

**How to apply:** Use `gog mail thread modify <threadId> --remove INBOX` instead of `gog mail archive <messageId>`. Similarly for trashing multi-message threads, operate at the thread level.
