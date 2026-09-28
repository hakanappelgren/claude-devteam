# claude-devteam

Håkan's Claude Code dev team, packaged as a plugin so every project uses **one** copy.
Before this, the agents and commands were copied into each project and the copies drifted apart.

## What's in it

`plugins/devteam/` — six specialist agents (researcher, designer, builder, test-writer, reviewer,
doc-keeper), the slash commands that run the gated feature process, and the process skills they
call. `TEAM.md` holds the rules of engagement.

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
