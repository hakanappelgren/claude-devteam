# claude-devteam

Håkan's Claude Code dev team, packaged as a plugin so every project uses **one** copy.
Before this, the agents and commands were copied into each project and the copies drifted apart.

## What's in it

`plugins/devteam/` — six specialist agents (researcher, designer, builder, test-writer, reviewer,
doc-keeper), the slash commands that run the gated feature process, and the process skills they
call. `TEAM.md` holds the rules of engagement. `hooks/` holds a PR check: `gh pr create` is
blocked when code changed but `docs/ROADMAP.md` / `docs/HANDOFF.md` did not (docs-only branches and
repos without a ROADMAP pass). Its tests: `bash tests/test-check-living-docs.sh`.

## Always on — three layers (2026-11-22)

The plugin used to load only when a session started inside one repo whose settings declared it,
so multi-repo cloud sessions and older projects ran without it. Now:

1. **Cloud (claude.ai app, web/desktop/phone):** the Default environment's setup script installs
   devteam at user scope before Claude starts, in every fresh session, whichever repos are attached:
   `claude plugin marketplace add hakanappelgren/claude-devteam && claude plugin install devteam@hakan-devteam --scope user`.
   Other environments (e.g. `li-whisperer`) need the same script added in Settings.
2. **Mac (VS Code, terminal, desktop app):** run that same pair of commands once in a terminal.
   User scope means every folder, not only repos that declare it.
3. **Each repo:** `.claude/settings.json` declares the marketplace and enables the plugin, and
   CLAUDE.md's `## Process` section has Claude check at session start that `devteam:*` loaded and
   say so if not. All of Håkan's repos were aligned on 2026-11-22.

## Using it in a project

Add to the project's `.claude/settings.json` (the `new-project` and `sync-project` skills do this):

```json
"extraKnownMarketplaces": {
  "hakan-devteam": { "source": { "source": "github", "repo": "hakanappelgren/claude-devteam" } }
},
"enabledPlugins": { "devteam@hakan-devteam": true }
```

Commands are namespaced by the plugin: type `/devteam:feature`, `/devteam:handoff` and so on
(the command menu autocompletes from `/feature`).

## Changing the team

Edit here, never in a project. Then bump `version` in `plugins/devteam/.claude-plugin/plugin.json`,
open a PR and merge. Then refresh the local copy — updating the marketplace alone is **not**
enough, each project keeps its installed version until it is reinstalled:

```bash
claude plugin marketplace update hakan-devteam
for p in ~/dev/projects/active/*/; do
  grep -q devteam@hakan-devteam "$p/.claude/settings.json" 2>/dev/null &&
    (cd "$p" && claude plugin install devteam@hakan-devteam --scope project && git checkout -q .claude/settings.json)
done
```

(`git checkout` undoes the key reordering the installer writes into settings.json.) Start a new
Claude Code session afterwards — plugins load at session start.
Project-specific rules belong in that project's `CLAUDE.md`, not in a fork of a command.

## Adding a third-party skill

Scan it first: `skillspector scan <path-or-url> --no-llm` (installed via `uv tool`).
The verdict is a triage signal, not a judgement — read every HIGH/CRITICAL line it points at.
In the first scans (2026-09-27) all four DO_NOT_INSTALL flags were benign: a debugging example
listing macOS keychains, and a plugin reading its own state file in `.claude/`. Copy only the
files you need, and record the source and licence in `plugins/devteam/THIRD_PARTY_NOTICES.md`.
