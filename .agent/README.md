# `.agent/` (Local Ralph State)

This folder is used by `ralph.sh` for lightweight, cross-iteration state that should **not** be committed.

Files:
- `scratchpad.md` - short, high-signal notes that help the next iteration (ignored by git)
- `last-session` - tracks the previous `RALPH_SESSION_ID` to populate `RALPH_PARENT_SESSION_ID` (ignored by git)
