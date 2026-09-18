# model-thrift

Saves the expensive model's tokens: the session model thinks, cheaper helper subagents do the bulky routine work. The full rule is in `rule.md`.

What it contains:
- the rule is injected into every new session, after `/clear` and after context compaction;
- a guard that rejects any helper launched without an explicit model (otherwise it silently runs on the expensive one);
- a context hint: once a session passes 200k tokens (and at every further 100k), Claude suggests saving notes and starting a new session. It only suggests; nothing is closed.

## Install

Easiest: tell Claude Code

```
Read https://raw.githubusercontent.com/Dastashka/model-thrift/main/INSTALL.md and follow it
```

It installs the plugin, finds old model/subagent rules in your CLAUDE.md and memory, and removes them after you confirm. Manual steps below.

Needs `bash` (on Windows: Git for Windows). Without it both hooks fail silently: no rule, no guard.

1. In a terminal:
   ```bash
   claude plugin marketplace add Dastashka/model-thrift
   ```
   ```bash
   claude plugin install model-thrift@model-thrift --scope user
   ```
2. Remove any section about model choice or subagents from your `~/.claude/CLAUDE.md`; the plugin replaces it.
3. Start a new session.

Sessions opened before the install (or resumed ones) do not get the rule automatically; the guard still works there. To bring the rule into such a session without losing its history, send it once:

```
Read <path to plugin>/rule.md and follow it for the rest of this session
```

The installed copy lives in `~/.claude/plugins/cache/model-thrift/model-thrift/<version>/rule.md`.

How to tell it works: before launching a helper, Claude writes a line like `🔀 sonnet: find where the store map widget lives`.

Update: `claude plugin marketplace update model-thrift`. Disable: `claude plugin disable model-thrift@model-thrift`.

## Maintenance

- Any change to `rule.md` or `hooks/` needs a higher `version` in `.claude-plugin/plugin.json`; without it `claude plugin update` reports "already at the latest version" and nobody gets the change.
- Run `bash tests/check.sh` before every push; it must end with `all green`. It also fails when a rule or hook change is missing the version bump.
- Never rename the plugin or the marketplace (both `model-thrift`): every existing install would stop updating.
- Roll back with `git revert`, then bump the version and push; the revert ships like any other update.
- Users with auto-update on get new versions within minutes of starting a session and a prompt to run `/reload-plugins`; everyone else runs `claude plugin marketplace update model-thrift` and `claude plugin update model-thrift@model-thrift`.
