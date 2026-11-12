---
status: active
value: [me]
vault:
horizon:
size: S
---

# Roadmap — claude-devteam

_Last updated: 2026-11-10_

## NOW — Active sprint
- [ ] Migrate research-pod, workout-app, change-engine-app, playbook-portal and `_template` to the plugin

## NEXT — Queued
- Verify the plugin loads in cloud / mobile Claude Code sessions (private repo access)

## LATER — Horizon
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
| Security-patch autoship rule (TEAM.md rule 8 + skill) | 2026-11-12 |

## Changelog
- 2026-11-12: v1.4.0 — skill `security-patch-autoship` + TEAM.md rule 8: high/critical prod-dependency advisories with a lockfile-only patch bump ship without asking once 8 conditions are proven; production is smoke-checked after merge, reverted on failure, and reported.
- 2026-11-10: v1.3.0 — PreToolUse hook blocks `gh pr create` when code changed without a ROADMAP/HANDOFF update; TEAM.md rule: finished work = docs updated, pushed, PR open; merge on Håkan's word.
- 2026-10-08: v1.2.0 — screenshot + visual check required before UI work counts as done; style-applied E2E guard.
- 2026-09-27: v1.1.0 — grilling, debugging/verification skills, builder finish loop, handoff upgrades.
- 2026-09-27: Created — team imported from research-pod (the most current copy).
