#!/usr/bin/env bash
# Tests for plugins/devteam/hooks/check-living-docs.sh.
# Each case builds a throwaway repo with a local bare "origin", makes a branch,
# then feeds the hook a fake PreToolUse payload. Run: bash tests/test-check-living-docs.sh

HOOK="$(cd "$(dirname "$0")/.." && pwd)/plugins/devteam/hooks/check-living-docs.sh"
PR_CMD='{"tool_name":"Bash","tool_input":{"command":"gh pr create --title x --body y"}}'
fails=0

# new_repo <with_roadmap:yes|no> — fresh repo on main, pushed to a bare origin.
new_repo() {
  local dir; dir=$(mktemp -d)
  git init -q --bare "$dir/origin.git"
  git init -q -b main "$dir/work"
  cd "$dir/work" || exit 1
  git config user.email t@t; git config user.name t
  git remote add origin "$dir/origin.git"
  echo app > app.js
  if [ "$1" = yes ]; then mkdir docs; echo roadmap > docs/ROADMAP.md; fi
  git add -A; git commit -qm init; git push -q origin main
  git checkout -qb feature
}

commit() { for f in "$@"; do mkdir -p "$(dirname "$f")"; echo change >> "$f"; done; git add -A; git commit -qm change; }

# expect <name> <exit-code> [payload]
expect() {
  local out code
  out=$(printf '%s' "${3:-$PR_CMD}" | bash "$HOOK" 2>&1); code=$?
  if [ "$code" = "$2" ]; then echo "PASS  $1"; else echo "FAIL  $1 (exit $code, want $2): $out"; fails=$((fails+1)); fi
  LAST_OUT=$out
}

new_repo yes; commit app.js
expect "code-only branch is blocked" 2
case "$LAST_OUT" in *"update ROADMAP/HANDOFF"*|*"Update ROADMAP/HANDOFF"*) echo "PASS  block message names ROADMAP/HANDOFF" ;; *) echo "FAIL  block message: $LAST_OUT"; fails=$((fails+1)) ;; esac

new_repo yes; commit app.js docs/ROADMAP.md
expect "code + ROADMAP passes" 0

new_repo yes; commit app.js docs/HANDOFF.md
expect "code + HANDOFF passes" 0

new_repo yes; commit README.md docs/ARCHITECTURE.md
expect "docs-only branch passes" 0

new_repo no; commit app.js
expect "repo without ROADMAP passes" 0
case "$LAST_OUT" in *"no docs/ROADMAP.md"*) echo "PASS  no-ROADMAP note tells you to create one" ;; *) echo "FAIL  no-ROADMAP note missing: $LAST_OUT"; fails=$((fails+1)) ;; esac

new_repo yes; commit app.js
expect "non-PR commands are ignored" 0 '{"tool_name":"Bash","tool_input":{"command":"git push"}}'

cd "$(mktemp -d)" || exit 1
expect "outside a git repo passes" 0

echo; [ "$fails" = 0 ] && echo "All tests passed." || { echo "$fails test(s) failed."; exit 1; }
