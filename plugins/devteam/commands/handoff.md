# /handoff — Session Handoff

Write a handoff document to `docs/HANDOFF.md` so the next Claude session can pick up exactly where this one left off.

**Next session's focus:** $ARGUMENTS — if given (e.g. `/devteam:handoff finish the audio fix`), tailor Status, Next actions and Context files to that goal and leave out what doesn't serve it.

Three rules (adapted from mattpocock/skills `handoff`):

- **Point, don't copy.** Anything already in an artifact — acceptance criteria, plan.md, ADRs, PRD, commits, a PR — gets a path or link, not a restatement. The handoff is the map, not the territory.
- **Redact secrets.** No API keys, tokens, passwords or client personal data, even if they came up in the session.
- **Name the commands.** Say which commands or skills the next session should start with.

**Long threads:** when a session gets long or starts drifting, the fix is `/devteam:handoff` → `/clear` → new session that reads `docs/HANDOFF.md`. A fresh session with a good handoff beats a long one dragging stale context.

Gather context from:

- `git log --oneline -10` (recent commits)
- `git status` and `git diff --stat HEAD` (current state)
- `docs/PRD.md` (product context)
- Current task list if tracked in this session
- This conversation (what was worked on, decisions made, issues hit)

Write `docs/HANDOFF.md` with this structure:

---

# Session Handoff

**Date:** [today's date]
**Branch:** [current branch]
**Session summary:** [1–2 sentences: what was the goal of this session]

## Status

**Completed this session:**

- [list of what was finished]

**In progress / partially done:**

- [what's started but not finished, with specific file/state]

**Not started yet:**

- [what's planned but untouched]

## Current state

**Tests:** [passing / failing — which ones if failing]
**Lint:** [clean / issues — what if issues]
**Build:** [verified / unverified]

## Decisions made

[Any architectural or product decisions made this session that aren't captured in ADRs yet]

## Open questions

[Things that need Håkan's input or are unresolved]

## Next actions

1. [First thing the next session should do]
2. [Second thing]
3. [...]

## Start with

[1–3 commands or skills for the next session, e.g. `/devteam:review audio-fix`, and why]

## Context files to read first

- `docs/HANDOFF.md` (this file)
- `docs/PRD.md` (product context)
- `CLAUDE.md` (project rules)
- [any other specific files relevant to the next session]

---

After writing the file, confirm: "Handoff written to docs/HANDOFF.md — safe to end session."
