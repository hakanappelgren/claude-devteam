---
status: active
value: [me]
vault:
horizon:
size: S
---

# Roadmap — claude-devteam

_Last updated: 2026-11-22_

## NOW — Active sprint
- [ ] Fresh cloud session: confirm `devteam:*` loads from the setup script (unproven until a new container starts)
- [ ] Decide on the local agents/commands left in change-engine-app (`.claude/agents`, kickoff-quick/full) and pulse (`.claude/commands`)

## NEXT — Queued

## LATER — Horizon
- Two-axis review (standards vs spec) as parallel reviewer subagents
- Weekly architecture-health scheduled task (dead modules, layer breaks, docs that disagree with code)
- Impeccable as a mockup reviewer (scan with skillspector first)
- Plugin evals (`claude plugin eval`) for the core commands

## Done
| Feature | Shipped |
| ------- | ------- |
| Grilling in /feature, /explore, /plan | 2026-09-27 |
| systematic-debugging + verification-before-completion skills | 2026-09-27 |
| Builder finish loop (verify + acceptance criteria, max 10 rounds) | 2026-09-27 |
| Handoff: next-session focus, point-don't-copy, redaction | 2026-09-27 |
| Visual check required for UI work (builder, reviewer, verification) | 2026-10-08 |
| Living-docs PR check hook + "finished = PR open" rule | 2026-11-10 |
| Designer uses the project's design system (Alvar / SO) instead of hardcoded SO teal | 2026-11-15 |
| Security-patch autoship rule (TEAM.md rule 8 + skill) | 2026-11-12 |
| Ship-when-done: lead merges finished work, verifies, cleans up | 2026-11-12 |
| Always-on: setup script (cloud), user scope (Mac), all 11 repos aligned | 2026-11-22 |
| Process review; size-based gates, design alternatives, branch-per-session, one review | 2026-11-22 |

## Changelog
- 2026-11-22: Always-on — cloud setup script installs devteam at user scope; every repo declares it and checks it loaded at session start; README documents the three layers.
- 2026-11-22: v1.7.0 — Håkan's gates cut to idea + acceptance criteria; design gate only for large UI changes, then 3–5 alternatives; plan gate only for large work. New skill `branch-per-session` (parallel sessions branch from fresh `main`, sync before merge, HANDOFF/ROADMAP conflict rule; worktrees locally). TEAM.md rule 8: one review (reviewer agent), no CI review bot; old rule 8 is now 9. Grilling asks the verification question; plan.md slices are tracer bullets; kickoff creates `main` first. Process review in `docs/2026-11-22 process-review.md`.
- 2026-11-22: plugin verified loading in cloud sessions since the repo went public (2026-11-20).
- 2026-11-12: v1.5.0 — skill `ship-when-done`; TEAM.md rule 7 and /feature: after review passes and CI/preview are green, the lead merges, verifies production, cleans up and reports. Håkan's word is still needed for hard-to-undo, schedule, cost/access changes, and open choices.
- 2026-11-12: v1.4.0 — skill `security-patch-autoship` + TEAM.md rule 8: high/critical prod-dependency advisories with a lockfile-only patch bump ship without asking once 8 conditions are proven; production is smoke-checked after merge, reverted on failure, and reported.
- 2026-11-10: v1.3.0 — PreToolUse hook blocks `gh pr create` when code changed without a ROADMAP/HANDOFF update; TEAM.md rule: finished work = docs updated, pushed, PR open; merge on Håkan's word.
- 2026-10-08: v1.2.0 — screenshot + visual check required before UI work counts as done; style-applied E2E guard.
- 2026-09-27: v1.1.0 — grilling, debugging/verification skills, builder finish loop, handoff upgrades.
- 2026-09-27: Created — team imported from research-pod (the most current copy).
