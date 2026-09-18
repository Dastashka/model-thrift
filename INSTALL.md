# Install model-thrift (instructions for Claude)

The user asked you to set up the model-thrift plugin. Do these steps in order and report the result of each in one line.

1. **Prerequisite.** Run `bash -c "echo ok"`. If it fails, stop: on Windows the user must install Git for Windows first. Tell them and wait.
2. **Install or update the plugin.**
   ```bash
   claude plugin marketplace add Dastashka/model-thrift
   ```
   ```bash
   claude plugin install model-thrift@model-thrift --scope user
   ```
   If it is already installed, run `claude plugin marketplace update model-thrift` and `claude plugin update model-thrift@model-thrift` instead.
3. **Find conflicting instructions.** Read `~/.claude/CLAUDE.md`, plus `CLAUDE.md`, `CLAUDE.local.md` and the auto-memory index (`MEMORY.md`) of the current project if they exist. Look for passages that decide which model subagents use or when to delegate to them. Read the installed rule at `~/.claude/plugins/cache/model-thrift/model-thrift/<version>/rule.md` to compare.
   - A passage that contradicts the rule, or duplicates it: a conflict.
   - A project-specific refinement (a minimum model for some code, code marked as sensitive): keep it, not a conflict.
4. **Clean up with consent.** Show the user every conflicting passage with its file path and propose removing it. Remove only the passages the user approves, and nothing else. Never edit files you were not asked about.
5. **Auto-update.** Third-party marketplaces do not auto-update by default. Ask the user to run `/plugin` in Claude Code once, open **Marketplaces → model-thrift** and choose **Enable auto-update**, so rule fixes reach them without manual commands.
6. **Finish.** Tell the user to restart Claude Code. In a new session the rule is active: before launching a helper, Claude writes a line like `🔀 sonnet: <task>`.
