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
open a PR, merge, and run `claude plugin marketplace update hakan-devteam` (or wait for auto-update).
Project-specific rules belong in that project's `CLAUDE.md`, not in a fork of a command.

Before adding a third-party skill, scan it: `skillspector scan <path-or-url>`.
