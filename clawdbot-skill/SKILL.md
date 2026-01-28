---
name: claude-code-wingman
description: Your Claude Code wingman - dispatch coding tasks via tmux for free/work-paid coding while keeping Clawdbot API costs minimal
metadata: {"clawdbot":{"emoji":"🎯","requires":{"anyBins":["claude","tmux"]}}}
---

# Claude Code Wingman

Automate Claude Code sessions from Clawdbot - leverage free/work Claude Code API while keeping your Anthropic budget for conversations.

**GitHub:** https://github.com/yossiovadia/claude-code-wingman

## CRITICAL: You Are The Orchestrator

**YOU DO NOT WRITE CODE.** You are an orchestrator that:
1. **Spawns** Claude Code sessions in tmux to do the actual coding
2. **Monitors** those sessions by capturing their tmux output
3. **Approves** permission requests when the user replies
4. **Reports** status and progress back to the user

**Claude Code runs inside tmux sessions and does all the coding work.**
**You just manage and monitor those sessions.**

When user asks to "see what's in a session" or "show the output":
- Use `tmux capture-pane -t <session-name> -p -S -50` to get the terminal output
- NEVER read files or write code yourself

## What It Does

Spawns Claude Code in tmux sessions with automatic approval of permission prompts. Perfect for when you have free/work Claude Code access but limited Anthropic API budget.

**Cost Comparison:**
- **Without:** Clawdbot does all coding → uses your $20/month API
- **With:** Clawdbot spawns Claude Code → uses work's free API ✅

## Skill Location

**IMPORTANT:** This SKILL.md is located in the `clawdbot-skill/` subdirectory.
The executable scripts are in the **parent directory** of this file.

When you read this skill from location `/path/to/claude-code-wingman/clawdbot-skill/SKILL.md`,
the scripts are at `/path/to/claude-code-wingman/`.

**To find the script directory**, derive it from this SKILL.md's location:
- Remove `/clawdbot-skill/SKILL.md` from the end of the path
- Example: If SKILL.md is at `~/.clawdbot/skills/claude-code-wingman/clawdbot-skill/SKILL.md`
- Scripts are at: `~/.clawdbot/skills/claude-code-wingman/`

## First-Time Setup (Automatic)

The `claude-wingman.sh` script automatically:
1. Starts the `master-monitor.sh` daemon on first use (sends WhatsApp notifications for approvals)
2. Creates necessary state directories in `/tmp/claude-orchestrator/`
3. No manual setup required!

## Usage from Clawdbot

When a user asks for coding work, spawn Claude Code.

**First, determine the skill root directory** from this SKILL.md's location, then run:

```bash
<SKILL_ROOT>/claude-wingman.sh \
  --session <session-name> \
  --workdir <project-directory> \
  --prompt "<task description>"
```

Where `<SKILL_ROOT>` is the parent directory of the `clawdbot-skill/` folder containing this file.

### Example Patterns

**User:** "Fix the bug in api.py"

**Clawdbot Response:**
```
Spawning Claude Code for this...

bash:<SKILL_ROOT>/claude-wingman.sh \
  --session vsr-bug-fix \
  --workdir ~/code/semantic-router \
  --prompt "Fix the bug in src/api.py - add proper error handling for null responses"
```

Then report:
- Session name (so user can attach)
- Monitor command
- Auto-approver is running

**User:** "What's the status?"

**Clawdbot:** Capture tmux output and summarize:
```bash
tmux capture-pane -t vsr-bug-fix -p -S -50
```

## Commands

### Spawn Session
```bash
<SKILL_ROOT>/claude-wingman.sh \
  --session <name> \
  --workdir <dir> \
  --prompt "<task>"
```

### Handle Approval Requests

When the user receives a WhatsApp notification about an approval request and replies, parse their response and run the appropriate command:

| User Reply | Command |
|------------|---------|
| `approve <session>` | `<SKILL_ROOT>/lib/handle-approval.sh approve <session>` |
| `always <session>` | `<SKILL_ROOT>/lib/handle-approval.sh always <session>` |
| `deny <session>` | `<SKILL_ROOT>/lib/handle-approval.sh deny <session>` |
| `1` or `yes` (after notification) | `<SKILL_ROOT>/lib/handle-approval.sh approve <last-notified-session>` |

**Examples:**
- User: "approve hello-world-task" → Run: `<SKILL_ROOT>/lib/handle-approval.sh approve hello-world-task`
- User: "always vsr-bugfix" → Run: `<SKILL_ROOT>/lib/handle-approval.sh always vsr-bugfix`

**After running, respond with the command output** (e.g., "✓ Session 'hello-world-task' approved (once)")

### Monitor Progress / View Session Content

**To see what a Claude Code session is currently showing (its terminal output):**
```bash
tmux capture-pane -t <session-name> -p -S -50
```

This captures the last 50 lines of the tmux pane. Use `-S -100` for more history.

**To check ALL sessions at once:**
```bash
for session in $(tmux ls -F '#{session_name}'); do
  echo "=== $session ==="
  tmux capture-pane -t "$session" -p -S -20
  echo ""
done
```

**IMPORTANT:** When user asks "what's in the session" or "show me the output" or "capture the content":
- ALWAYS use `tmux capture-pane` - this shows the terminal output
- NEVER read files from disk - that's not what they're asking for

### View Auto-Approver Log
```bash
cat /tmp/auto-approver-<session-name>.log
```

### Kill Session
```bash
tmux kill-session -t <session-name>
```

### List All Sessions
```bash
tmux ls
```

To see only Claude Code wingman sessions (prefixed with session names you created):
```bash
tmux ls
```

**Note:** Wingman sessions are named by you (e.g., `vsr-bugfix`, `hello-world-task`). They don't have a special prefix.

## Workflow

1. **User requests coding work** (fix bug, add feature, refactor, etc.)
2. **Clawdbot spawns Claude Code** via wingman script
3. **Auto-approver handles permissions** in background
4. **Clawdbot monitors and reports** progress
5. **User can attach anytime** to see/control directly
6. **Claude Code does the work** on work's API ✅

## Trust Prompt (First Time Only)

When running in a new directory, Claude Code asks:
> "Do you trust the files in this folder?"

**First run:** User must attach and approve (press Enter). After that, it's automatic.

**Handle it:**
```
User, Claude Code needs you to approve the folder trust (one-time). Please run:
tmux attach -t <session-name>

Press Enter to approve, then Ctrl+B followed by D to detach.
```

## Best Practices

### When to Use Wingman

✅ **Use wingman for:**
- Heavy code generation/refactoring
- Multi-file changes
- Long-running tasks
- Repetitive coding work

❌ **Don't use wingman for:**
- Quick file reads
- Simple edits
- When conversation is needed
- Planning/design discussions

### Session Naming

Use descriptive names:
- `vsr-issue-1131` - specific issue work
- `vsr-feature-auth` - feature development
- `project-bugfix-X` - bug fixes

## Troubleshooting

### Prompt Not Submitting
The wingman sends Enter twice with delays. If stuck, user can attach and press Enter manually.

### Auto-Approver Not Working
Check logs: `cat /tmp/auto-approver-<session-name>.log`

Should see: "Approval prompt detected! Navigating to option 2..."

### Session Already Exists
Kill it: `tmux kill-session -t <name>`

## Advanced: Update Memory

After successful tasks, update `TOOLS.md`:

```markdown
### Recent Claude Code Sessions
- 2026-01-26: VSR AWS check - verified vLLM server running ✅
- Session pattern: vsr-* for semantic-router work
```

## Pro Tips

- **Parallel sessions:** Run multiple tasks simultaneously in different sessions
- **Name consistently:** Use project prefixes (vsr-, myapp-, etc.)
- **Monitor periodically:** Check progress every few minutes
- **Let it finish:** Don't kill sessions early, let Claude Code complete

---

**Remember:** This skill saves API costs by using free work Claude Code for heavy lifting, keeping your Anthropic budget for conversations.
