# Claude Code Wingman 🦅

**Your wingman for free coding** - dispatch tasks to Claude Code via tmux with WhatsApp approval, keeping your API budget for conversations.

**GitHub:** https://github.com/yossiovadia/claude-code-wingman

## Features

✅ Auto-approval mode - runs completely hands-off  
✅ Interactive mode - asks you before each action (via WhatsApp/Clawdbot)  
✅ tmux session management - attach anytime to see/control  
✅ Dependency checks - validates tmux + claude CLI are installed  
✅ Security - validates session names, secures log files  
✅ Real-world tested - used for production VSR work  

## Quick Install

```bash
git clone https://github.com/yossiovadia/claude-code-wingman.git
cd claude-code-wingman
chmod +x *.sh

# Test it
./claude-wingman.sh --workdir ~/code/myproject --prompt "Your task"
```

**Requirements:** tmux, Claude Code CLI (`claude`), bash

---

## Two Modes

### Auto Mode (Default)
Automatically approves all permission prompts - perfect for trusted environments.

```bash
./claude-wingman.sh \
  --session my-task \
  --workdir ~/code/myproject \
  --prompt "Add error handling to api.py"
```

### Interactive Mode
Asks you before each action - perfect when you want oversight.

```bash
./claude-wingman.sh \
  --session my-task \
  --workdir ~/code/myproject \
  --prompt "Add error handling to api.py" \
  --interactive
```

Then Clawdbot will notify you when approval is needed:
```bash
# Check for pending approvals
./check-approvals.sh

# Respond
./respond-approval.sh my-task always
```

---

## Problem Statement

- **Clawdbot** uses your Anthropic API ($20/month budget)
- **Claude Code** (via work/free tier) doesn't cost you anything
- Want to leverage free Claude Code for heavy lifting while using Clawdbot for coordination

## Solution

This wingman spawns Claude Code in tmux sessions with automatic (or interactive) approval of permission prompts. Uses work's free Claude Code API while keeping your Anthropic budget for conversations.

---

## Development Plan

### Phase 1: Research & Testing ✅ COMPLETE!
- [x] Step 1: Research Claude Code auto-approval settings
- [x] Step 2: Build minimal wrapper script (auto-approver.sh)
- [x] Step 3: Test with simple task ✅ SUCCESS

**Result:** Full end-to-end automation achieved! test5.txt created with zero human intervention.

### Phase 2: Production Features ✅ COMPLETE!
- [x] Interactive approval mode
- [x] Dependency checks
- [x] Security improvements (validation, secure logs)
- [x] Multiple test cases

### Phase 3: Release ✅ COMPLETE!
- [x] Published to GitHub
- [x] Clawdbot skill documentation
- [x] Usage guide
- [x] Changelog

---

## Usage

See [USAGE.md](USAGE.md) for detailed examples and troubleshooting.

See [CHANGELOG.md](CHANGELOG.md) for version history and real-world test results.

---

## Cost Savings

- **Without wingman:** Clawdbot does everything → uses your $20/month API budget
- **With wingman:** Clawdbot spawns Claude Code → uses work's free API ✅

Perfect for heavy coding tasks while keeping Clawdbot API costs minimal.

---

## Contributing

This project is open source and ready for contributions. Bash scripts are welcome and encouraged!

To publish to ClawdHub:
```bash
npm i -g clawdhub
clawdhub login
clawdhub publish . --slug claude-code-wingman --name "Claude Code Wingman" --version 1.0.0
```

---

## Contributors

- **Yossi Ovadia** ([@yossiovadia](https://github.com/yossiovadia)) - Product vision, testing, VSR use case
- **The Dude** (Clawdbot Agent) - Implementation, debugging, documentation

---

*Built in one day. From idea to working prototype to published project. This could help others with the same problem.* 🎳✨
