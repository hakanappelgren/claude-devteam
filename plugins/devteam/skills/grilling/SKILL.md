---
name: grilling
description: Settle every open decision in a feature, plan or idea by questioning Håkan in numbered rounds, each question with a recommended answer. Use in /feature Phase 1 before acceptance criteria, at the end of /explore, as a light pass in /plan before the approval gate, or when Håkan says "grill me", "stress-test this", or "what haven't I decided".
---

# Grilling — settle the decisions before building

Adapted from Matt Pocock's `grilling` skill (MIT, github.com/mattpocock/skills).

Håkan is a product person, not a developer, and does his best thinking by reacting to a concrete
proposal rather than generating answers from scratch. So every question comes with your
recommendation. Your job is to make the decisions visible and easy to make — not to quiz him.

## The method

Treat the work as a **decision tree**: every decision branches into the decisions that depend on it.

Work in **rounds**. The **frontier** is every decision whose prerequisites are already settled —
the questions you can ask now without guessing at answers you haven't heard. Ask the whole
frontier in one round, numbered, then wait. A question that depends on another question still open
in this round belongs to a later round.

Format a round like this:

```
❓ **Q1 — <short title>**: <the question in plain language; options if there are real options>

➡️ Recommended: <your answer> — <one line of why>

---

❓ **Q2 — <short title>**: ...
```

After each round, recompute the frontier from his answers and ask the next round.

## Rules

- **Facts are your job, decisions are his.** Never ask something you can look up in the codebase,
  the docs or the web — look it up (dispatch a sub-agent for anything broad). Don't block the whole
  round on a lookup: only the questions that depend on it wait.
- **Plain language.** Technical choices are framed by their consequence for the product ("works
  offline but costs a day more" — not "IndexedDB vs. service-worker cache").
- **Max 5 questions per round.** If the frontier is bigger, ask the 5 that unblock the most.
- **"You decide" is an answer.** Take your recommendation and mark it as delegated.
- **Done when the frontier is empty** — every branch visited, nothing silently assumed.

## Finish

End with a short list, then stop and wait for confirmation that it's right:

```
## Settled
- <decision> — <answer> (Håkan / delegated)

## Explicitly out of scope
- <thing>
```

This list is the input to whatever comes next — acceptance criteria in /feature, the "Still open"
section in /explore, the plan in /plan. Do not act on it until Håkan confirms.
