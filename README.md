# Claude Code Wingman 🦅

Run Claude Code as a Clawdbot skill. Control it from WhatsApp, track progress, and approve actions - all without leaving your chat.

**GitHub:** https://github.com/yossiovadia/claude-code-wingman

## What It Does

Clawdbot spawns Claude Code in a tmux session. When Claude Code needs permission to do something, **you get notified via WhatsApp** (or Clawdbot dashboard) and can approve or deny.

- **Give tasks via chat:** "Fix the bug in api.py"
- **Get approval requests:** "Claude Code wants to edit 3 files. Allow?"
- **Track progress:** Ask "what's the status?" anytime
- **Take over:** Attach to the tmux session to see or control Claude Code directly

## Why Use This?

| Without Wingman | With Wingman |
|-----------------|--------------|
| Clawdbot does all coding | Clawdbot dispatches to Claude Code |
| Uses your $20/month API budget | Uses work's free Claude Code API |
| Limited to chat interface | Full Claude Code power + chat control |

## Quick Start

```bash
git clone https://github.com/yossiovadia/claude-code-wingman.git
cd claude-code-wingman
chmod +x *.sh
```

**Requirements:** tmux, Claude Code CLI (`claude`), bash

## Usage

```bash
./claude-wingman.sh \
  --session my-task \
  --workdir ~/code/myproject \
  --prompt "Add error handling to api.py"
```

When Claude Code asks for permission, you'll be notified. Respond with:
```bash
./respond-approval.sh my-task yes      # approve once
./respond-approval.sh my-task always   # approve for session
./respond-approval.sh my-task no       # deny
```

### Attach to Session

Want to see what Claude Code is doing? Attach to the tmux session:
```bash
tmux attach -t my-task
```

Detach with `Ctrl+B` then `D`. The session keeps running.

### Auto Mode

For trusted environments, skip the approval prompts:
```bash
./claude-wingman.sh --workdir ~/code/myproject --prompt "Run tests" --auto
```

## Commands

| Command | Description |
|---------|-------------|
| `tmux attach -t <session>` | Watch/control Claude Code live |
| `tmux capture-pane -t <session> -p` | Get current output |
| `./check-approvals.sh` | See pending approval requests |
| `tmux kill-session -t <session>` | Stop a session |

## More Docs

- [USAGE.md](USAGE.md) - Detailed examples
- [CHANGELOG.md](CHANGELOG.md) - Version history

## Contributing

PRs welcome! To publish updates to ClawdHub:
```bash
clawdhub publish . --slug claude-code-wingman --name "Claude Code Wingman" --version X.Y.Z
```
