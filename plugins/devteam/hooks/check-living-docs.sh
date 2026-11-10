#!/usr/bin/env bash
# PreToolUse hook (Bash): before `gh pr create`, check that a branch which changed
# code also updated the living docs (docs/ROADMAP.md or docs/HANDOFF.md).
#
# Why: a PR that ships code with a stale ROADMAP/HANDOFF leaves docs that are
# confidently wrong — worse than none. This only CHECKS; it never writes docs.
# Writing them automatically would be slow and unpredictable.
#
# Exit 0 = let the command run. Exit 2 = block it; stderr is shown to Claude.

input=$(cat)

# Only act on PR creation. Matching the raw hook JSON avoids a jq dependency.
case "$input" in
  *"gh pr create"*) ;;
  *) exit 0 ;;
esac

# Not a git repo, or no remote to compare with → nothing to check, don't block.
top=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$top" || exit 0

# Base is the remote default branch; origin/main unless origin/HEAD says otherwise.
base=$(git symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null)
[ -n "$base" ] || base=origin/main
changed=$(git diff --name-only "$base"...HEAD 2>/dev/null) || exit 0

# A repo without a ROADMAP passes, but gets told to create one. On exit 0 only
# JSON on stdout reaches the session, so the note goes there (user + Claude).
if [ ! -f docs/ROADMAP.md ]; then
  note="This repo has no docs/ROADMAP.md: create one (format in ~/dev/CLAUDE.md) so the portfolio can classify it."
  printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"%s"}}\n' "$note" "$note"
  exit 0
fi

# "Code" = any changed file that isn't documentation (*.md or under docs/).
code=$(printf '%s\n' "$changed" | grep -v -e '^$' -e '\.md$' -e '^docs/')
[ -n "$code" ] || exit 0   # docs-only (or empty) branch

if printf '%s\n' "$changed" | grep -qx -e 'docs/ROADMAP.md' -e 'docs/HANDOFF.md'; then
  exit 0
fi

echo "Blocked: code changed but docs/ROADMAP.md and docs/HANDOFF.md did not. Update ROADMAP/HANDOFF (and ARCHITECTURE if structure changed) before opening the PR." >&2
exit 2
