---
name: claude-code-wingman
description: Your Claude Code wingman - dispatch coding tasks to free/work Claude Code with WhatsApp approval, keeping your API budget for conversations
metadata: {"clawdbot":{"emoji":"🦅","requires":{"anyBins":["claude","tmux"]}}}
---

# Claude Code Wingman

Your wingman for free coding - dispatch tasks to Claude Code (on your work's dime) with full approval control via WhatsApp.

**GitHub:** https://github.com/yossiovadia/claude-code-orchestrator

## What It Does

Spawns Claude Code in tmux sessions with interactive approval via WhatsApp/chat. Perfect for when you have free/work Claude Code access but limited Anthropic API budget.

**Cost Comparison:**
- **Without:** Clawdbot does all coding → uses your $20/month API
- **With:** Clawdbot spawns Claude Code → uses work's free API ✅

## 🎯 Real-World Example

**You (via WhatsApp):** "Check if my AWS server is still running"

**Clawdbot spawns Claude Code** → work pays for API

**Claude Code asks:** "Do you want me to SSH to the server?"

**You get notified in WhatsApp:**
```
⚠️ Approval needed for session: aws-check

Do you want to run SSH command?
1. yes - Approve this once
2. always - Approve for session
3. no - Decline
```

**You respond:** "always"

**Claude Code:**
- ✅ Connects to server
- ✅ Checks vLLM service status  
- ✅ Reports: "Server healthy, API responding, 4 GPUs at 90%"

**Result:** Complex task done for free, with full oversight via chat.

## Installation

The skill references the standalone repo. Install it once:

```bash
cd ~/code
git clone https://github.com/yossiovadia/claude-code-orchestrator.git
cd claude-code-orchestrator
chmod +x *.sh
```

## Usage from Clawdbot

When a user asks for coding work, spawn Claude Code:

```bash
~/code/claude-code-orchestrator/claude-orchestrate.sh \
  --session <session-name> \
  --workdir <project-directory> \
  --prompt "<task description>"
```

### Example Patterns

**User:** "Fix the bug in api.py"

**Clawdbot Response:**
```
Spawning Claude Code for this...

bash:~/code/claude-code-orchestrator/claude-orchestrate.sh \
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
~/code/claude-code-orchestrator/claude-orchestrate.sh \
  --session <name> \
  --workdir <dir> \
  --prompt "<task>"
```

### Monitor Progress
```bash
tmux capture-pane -t <session-name> -p -S -100
```

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
tmux ls | grep claude-auto
```

## Workflow

1. **User requests coding work** (fix bug, add feature, refactor, etc.)
2. **Clawdbot spawns Claude Code** via orchestrator script
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

### When to Use Orchestrator

✅ **Use orchestrator for:**
- Heavy code generation/refactoring
- Multi-file changes
- Long-running tasks
- Repetitive coding work

❌ **Don't use orchestrator for:**
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
The orchestrator sends Enter twice with delays. If stuck, user can attach and press Enter manually.

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
