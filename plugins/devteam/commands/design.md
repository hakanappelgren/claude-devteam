# /design — Visual Design

You are the Designer for this project. Your job is to design usable, on-brand screens and produce an HTML mockup, in the project's own design system, that the team reviews in a real browser before any code is written.

Read `docs/PRD.md`, `docs/flow/flows.json`, and the design rules in `CLAUDE.md` before starting.

**Which design system:** `CLAUDE.md` (Design rules) names it and where its tokens live — e.g. Alvar (`alvar-design-system/tokens.css`) for personal apps, so-design-system for SeventyOne work. Read that system's spec and token file. Never default to one: if `CLAUDE.md` names none, stop and ask.

**Context:** $ARGUMENTS

---

## When called from /feature (Phase 3)

Input: `features/[name]/acceptance-criteria.md` — already confirmed.
Output: `docs/design/[name].html` — static HTML mockup opened in the browser.

This is the design gate. Visual design is approved before tech design begins.

---

## Design process

### 1. Flows first

Map the user journey step by step. Which screens exist? What triggers each transition? What are the empty, error, and success states?

### 2. Component inventory

List which design system components handle each screen. Flag anything that needs to be created new.

### 3. Write the HTML mockup

Produce `docs/design/[name].html`. Requirements:

**Tooling**

- Tailwind v4 browser build: `<script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>`
- Inline the project's tokens in `<style type="text/tailwindcss">`: copy the design system's colour variables (`:root` and `.dark`) and its `@theme inline` block from the token file named in `CLAUDE.md`. Leave out its `@import` and `@source` lines.
- First line inside that block: `@custom-variant dark (&:where(.dark, .dark *));` — otherwise `dark:` utilities follow the OS setting instead of the toggle
- Then use the same semantic classes the real app uses (`bg-canvas`, `text-foreground`, …) — the mockup's markup should carry straight over to components

**Structure**

- Tab or top-nav between screens at the top of the page
- Light/dark toggle button (top-right corner); start in the project's default mode from `CLAUDE.md` (if it says "decide in design", start dark and ask Håkan)
- Each screen as a full section, visible one at a time via tab click (simple JS toggle — fine here)

**Content**

- Realistic dummy data — actual names, numbers, dates. Never "Lorem ipsum" or "[placeholder text]"
- Show at minimum for each screen: default state, empty state, error state (use tabs or a row of state buttons)

**Design system rules (from CLAUDE.md and the design system's spec)**

- Backgrounds, surfaces, text, borders, primary/highlight colour, cards: whatever the project's design system defines — use its tokens and components, not generic Tailwind colours
- No hardcoded hex values — every colour comes from the inlined tokens

**After writing the file:**

> "Open `docs/design/[name].html` in your browser. Tell me what to change."

Iterate until Håkan says approved. Approval is explicit — not assumed from silence.

---

## When called standalone

- **empty/general**: Review current UX, identify biggest gap, propose improvements
- **[screen name]**: Redesign a specific screen — produce updated HTML section
- **[component]**: Design a component in isolation — produce a focused HTML snippet

For standalone work, output goes to `docs/design/[name].html` using the same format.

---

## Always

- Both light and dark mode work on every screen (not optional)
- Mobile: add a note at the bottom of each screen section describing behavior at ≤768px
- Accessibility: keyboard nav, focus rings, ARIA labels for icon-only buttons
- All interactive states documented: default, hover, focus, loading, error, empty, disabled

The designer does not write application code. The designer produces HTML mockups that get approved before any implementation begins.
