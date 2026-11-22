---
name: branch-per-session
description: Use at the start of every coding session and again just before merging. Håkan runs several sessions in parallel on the same repo (a new idea, fix or story while another session is building). Each session gets its own branch from a fresh default branch, keeps it short-lived, and syncs with the default branch before it merges, so parallel work never forks or overwrites.
---

# Branch per session

**Why this exists.** Håkan starts a new session when he gets an idea instead of waiting for the
current one to finish. That is fine and should stay possible. In 2026-11, without a rule for it,
training-coach got two Claude branches that drifted apart and no `main` at all: 50 commits
that never reached production. The fix is not fewer sessions. It is that every session starts
from, and lands on, the same default branch.

**The unit is the task, not the session.** One task (feature, story, fix) = one branch = one PR.
If a session picks up a second, unrelated task, it finishes or parks the first, then starts again
at step 1.

## 1. Start

1. `git fetch origin` and find the default branch (`git remote show origin | grep HEAD`, usually `main`).
   **No default branch exists, or it isn't `main`** → stop and tell Håkan: the repo needs `main`
   created and set as the GitHub default before parallel work is safe (kickoff Phase 6 does this).
2. Branch **from `origin/main`**, never from another session's branch and never from whatever the
   clone happens to be on. Cloud sessions get a branch name from the harness: reset it onto
   `origin/main` if it isn't already there (`git checkout -B <name> origin/main`) before the first commit.
3. Read `docs/HANDOFF.md` and the open PRs (`list_pull_requests` or `gh pr list`). An open PR
   touching the same files is another session at work: tell Håkan in one line and agree who goes
   first, rather than building on top of it.

**Where the isolation comes from:**
- **Cloud sessions** (claude.ai app on web, desktop or phone): each session is its own container
  with its own clone. Isolation is automatic; this skill only keeps the branches honest.
- **Local sessions in one clone** (VS Code, terminal on the Mac): two sessions in the same folder
  share one working tree and will overwrite each other. Use one git worktree per session:
  start Claude Code with `claude --worktree <task-name>` (or `git worktree add ../<repo>-<task> -b <branch> origin/main`
  and open that folder). Never run two sessions in the same folder.

## 2. While working

- Commit small and push early. The container can disappear; GitHub is the only safe copy.
- Open the PR as a draft as soon as the first commit is pushed, so other sessions can see the work.
- Stay inside the task. A new idea goes to ROADMAP LATER or a new session, not into this branch.

## 3. Before merging — sync, then prove again

Right before the merge (after review passed, inside `ship-when-done`):

1. `git fetch origin` and check whether `origin/main` moved since the branch started
   (`git log HEAD..origin/main --oneline`).
2. **It moved** → `git merge origin/main` into the branch (never rebase or force-push a pushed branch).
   Resolve conflicts, then re-run the project's verify command and build, push, and wait for green CI.
   If the conflict touched code the review covered, the reviewer sees the merged diff again.
3. **It did not move** → go ahead.
4. Squash-merge with the expected head SHA, so a session that pushed in between makes the merge
   fail instead of being overwritten.

### The living docs always conflict — handle them like this

Every session updates `docs/HANDOFF.md` and `docs/ROADMAP.md`, so parallel PRs collide there.

- **ROADMAP.md, changelogs:** keep both sides. They are lists; each session's lines stay.
- **HANDOFF.md:** it is a snapshot of the whole repo, not of one session. Take `main`'s version,
  then rewrite it to describe the state *after* this merge: what main now contains, plus this
  task's decisions and next actions. Never drop another session's open items.

## 4. After merging

Delete the branch, and in a local worktree remove it (`git worktree remove`). The next task starts
again at step 1.

## Red flags

- A branch older than a week with no PR → tell Håkan; it is parked work nobody can see.
- More than one open `claude/*` branch per repo without a PR → list them for Håkan at session start.
- Ever pushing to `main` directly, rebasing a pushed branch or force-pushing: never.
