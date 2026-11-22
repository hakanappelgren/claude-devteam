# /feature — Build a Feature

## Size check first — this decides everything downstream

| Size               | Examples                          | Who does it                       | Process                              |
| ------------------ | --------------------------------- | --------------------------------- | ------------------------------------ |
| **Tiny**           | Typo, one-liner, config           | Lead, directly                    | Just do it — no process, no dispatch |
| **Small**          | Bug fix, minor addition           | Lead, directly                    | Describe → fix → test → commit (bugs: **systematic-debugging** skill first — root cause before any fix) |
| **Medium / Large** | New screen, endpoint, domain area | Lead orchestrates, agents execute | Full sequence below. No skipping.    |

Dispatching agents for tiny/small work is overkill — don't. The full machinery below exists for medium/large only.

---

## The sequence

```
Phase 1:  Understand      → problem statement, for whom, why now
Phase 2:  Acceptance      → what "done" looks like in testable terms
Phase 2b: Tech discovery  → only if new platform capabilities involved
                            researcher agent + /spike               ← GATE if triggered
Phase 3:  Visual design   → designer agent in the design system; lead checks it
                            large UI change: 3–5 alternatives, Håkan picks  ← GATE (large UI only)
Phase 4:  Tech design     → lead: architecture + layers + plan.md
                            large only: Håkan approves the plan     ← GATE (large only)
Phase 5:  Build           → builder agent: TDD → implement → green
Phase 6:  Review          → reviewer agent, fresh context            ← GATE
Phase 7:  Close           → doc-keeper: living docs, archive → lead ships (ship-when-done)
```

**Håkan's gates (v1.7.0, his decision 2026-11-22):** he takes part in Phase 1 (bouncing the idea — keep this, it is the part he values most) and approves the acceptance criteria. He picks a design only when the UI change is large (a new screen, a changed main flow or navigation) — then from 3–5 alternatives. He approves the plan only for large work (new domain area, integration, data model change). Everything else is the lead's job, held by the design system, the reviewer and CI.

Each gate that applies is a real stop. Move forward only on explicit approval. Never merge before review passes.

**Before Phase 1 and before the merge:** run the **branch-per-session** skill — branch from a fresh `origin/main`, and sync with it again before merging. Håkan runs parallel sessions; this is what keeps them from forking. After review passes, the lead ships it (skill `ship-when-done`): merge, verify production, clean up, report. Håkan is asked only for the skill's exceptions.

The lead runs Phases 1, 2, 2b (dispatch), and 4 itself — understanding and architecture are never delegated. Phases 3, 5, 6, 7 are dispatched; the artifacts written in earlier phases are the dispatch payload.

---

### Phase 1 — Understand the problem

If the feature is fuzzy, open with:

> "Tell me about this feature. What problem does it solve, for whom?"

Stay in problem space — no solutions yet. One question at a time.

Produce before moving on:

- **The real problem** (not the surface request)
- **For whom** and in what situation
- **Why now** — what's the trigger
- **What it's NOT** — explicit exclusions

Take time here — this is where Håkan wants to be. Then run the **grilling** skill to settle every open decision (behaviour, edge cases, what's in and out) in numbered rounds with a recommended answer for each. Its "Settled" list is the raw material for the acceptance criteria — nothing in Phase 2 should be a decision Håkan hasn't seen.

---

### Phase 2 — Acceptance criteria

Before screens. Before tech. What does "done" look like in observable, testable terms?

Write to: `features/[name]/acceptance-criteria.md`

```
# Acceptance criteria — [feature name]

## Must work
- [ ] [what the user sees / does when it works — specific, testable]
- [ ] [edge case 1]
- [ ] [edge case 2]

## Error states
- [ ] [what happens when X fails]

## Out of scope (explicit)
- [thing 1 not being built]
- [thing 2 not being built]
```

Don't move on until Håkan confirms this file.

---

### Phase 2b — Technical discovery (conditional)

Scan the confirmed criteria: does this feature depend on a **platform capability not already proven in this codebase**? (Audio, background execution, notifications, sensors, offline, file access, real-time, third-party auth — full list in `/spike`.)

**No → skip to Phase 3.** Most features skip this.

**Yes →**

1. Dispatch the **researcher agent**, one question per capability. Output: `features/[name]/research-brief.md` with verdict — PROVEN / CONDITIONAL / BLOCKED / UNKNOWN
2. CONDITIONAL or UNKNOWN → `/spike` on the real target device
3. BLOCKED → back to Phase 2, adjust the criteria with Håkan now — not after the mockup is approved

**GATE (when triggered): no unproven capability enters the plan.** "We can't do X" is a hypothesis until the researcher or a spike settles it — two projects stalled on unverified impossibility claims before this rule existed.

---

### Phase 3 — Visual design

Dispatch the **designer agent** (or run `/design [feature name]`). It produces `docs/design/[name].html` from the confirmed acceptance criteria, the project's design system and the research brief if one exists.

**Which mode** (the lead decides, from the criteria):

- **Normal (most features):** one design, in the design system, following its UX rules. No gate. The lead opens it (screenshots, light + dark), checks it against the acceptance criteria and the design system's rules, and moves on. Håkan sees the result in the PR preview and can still say "change this".
- **Large UI change** (new screen, changed main flow or navigation, a new pattern the design system doesn't have): the designer produces **3–5 genuinely different alternatives** side by side, each with one line on what it optimises for and what it gives up, plus the designer's recommendation. Say: "Open `docs/design/[name].html` — which one, or which parts of which?" **GATE: no tech work until he picks.**

### Phase 4 — Tech design

The lead runs this — architecture is never delegated down. Work from the acceptance criteria, approved design, and research brief.

**DDD first** — Which bounded context? New entity/value object/aggregate? Name things in the ubiquitous language before writing code.
**Tech Lead** — How does this fit the existing codebase? New dependencies (justify each)? Risks?
**Architect** — Layers touched. Data model changes. Layer violations to fix? ADR needed?
**QA** — Test strategy per acceptance criteria. First failing tests (TDD starting point). Definition of done.

Write to: `features/[name]/plan.md` (see `/plan` for format — including the Capability risks section).

**Medium:** the lead approves its own plan and goes on to build; the plan is in the PR for Håkan to read. **Large** (new domain area, new integration, data model change): wait for Håkan's approval.

---

### Phase 5 — Build

Dispatch the **builder agent**. Its inputs — nothing else needed:

- `features/[name]/acceptance-criteria.md`
- `features/[name]/plan.md`
- `docs/design/[name].html`
- `features/[name]/research-brief.md` (if it exists)

The builder follows TDD rules and build order defined in `${CLAUDE_PLUGIN_ROOT}/agents/builder.md`, and ends with a **finish loop**: it keeps going until `npm run verify` passes and every acceptance criterion is proven, for at most 10 rounds. This is why acceptance criteria must be testable — the loop is only as good as its done-condition. It reports back: criteria coverage, test results, loop rounds, deviations, deferred items.

If the builder escalates (ambiguous plan, missing input, needed dependency), the lead resolves it — with Håkan if it changes scope or architecture. Deferred tests in the report → dispatch the **test-writer agent** before review.

---

### Phase 6 — Review

Dispatch the **reviewer agent** — fresh context, by design. Give it only:

- The feature name (it runs the diff itself)
- Nothing else. **Not the build conversation, not the builder's report, not rationale.** Independence is the whole point.

Not approved → blockers in `features/[name]/review-blockers.md` → lead dispatches fixes to the builder → re-dispatch the reviewer (fresh again).
No merging over blockers. Ever.

---

### Phase 7 — Close

Dispatch the **doc-keeper agent** to run `/close-feature [name]`: PRD current state, ARCHITECTURE if changed, archive feature artifacts.

Done.
