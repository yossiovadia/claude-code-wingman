# Claude Code Orchestrator

**Orchestrate Claude Code sessions from Clawdbot via tmux** - leverage free/work Claude Code while keeping API costs minimal.

**GitHub:** https://github.com/yossiovadia/claude-code-orchestrator

## Quick Install

```bash
git clone https://github.com/yossiovadia/claude-code-orchestrator.git
cd claude-code-orchestrator
chmod +x *.sh

# Test it
./claude-orchestrate.sh --workdir ~/code/myproject --prompt "Your task"
```

**Requirements:** tmux, Claude Code CLI (`claude`), bash

## Problem Statement

- **Clawdbot** uses your Anthropic API ($20/month budget)
- **Claude Code** (via work/free tier) doesn't cost you anything
- Want to leverage free Claude Code for heavy lifting while using Clawdbot for coordination

## Challenges

1. Claude Code asks for approval on every command (breaks automation)
2. Interactive prompts don't auto-submit when scripted
3. Real-time output monitoring is tricky
4. Need clean session management for parallel tasks

## Solution (Building Incrementally)

A wrapper system that:
- Spawns Claude Code in tmux with proper auto-approval settings
- Handles prompt submission reliably
- Monitors output and streams updates back to Clawdbot
- Manages multiple parallel sessions cleanly

## Development Plan

### Phase 1: Research & Testing ✅ COMPLETE!
- [x] Step 1: Research Claude Code auto-approval settings
- [x] Step 2: Build minimal wrapper script (auto-approver.sh)
- [x] Step 3: Test with simple task ✅ SUCCESS

**Result:** Full end-to-end automation achieved! test5.txt created with zero human intervention.

### Phase 2: Production Wrapper
- [ ] Robust error handling
- [ ] Progress streaming
- [ ] Session cleanup

### Phase 3: Clawdbot Skill
- [ ] Package as reusable skill
- [ ] Documentation
- [ ] Examples

### Phase 4: Release
- [ ] Clean up for public consumption
- [ ] Share on ClawdHub
- [ ] Maybe contribute to Clawdbot

---

## Contributors

- **Yos** - Product vision, testing, VSR use case
- **The Dude** - Implementation, debugging, documentation

---

*Building this in the open. If it works, share it. If it doesn't, learn from it.*
