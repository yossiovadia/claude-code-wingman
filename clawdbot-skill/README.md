# Clawdbot Skill: Claude Code Orchestrator

This directory contains the Clawdbot skill wrapper for the Claude Code Orchestrator.

## Installation for Clawdbot

1. **Clone the main repo** (if not already):
   ```bash
   cd ~/code
   git clone https://github.com/yossiovadia/claude-code-orchestrator.git
   ```

2. **Copy this skill** to your Clawdbot skills directory:
   ```bash
   cp -r ~/code/claude-code-orchestrator/clawdbot-skill ~/.clawdbot/skills/claude-code-orchestrator
   ```

   Or create a symlink:
   ```bash
   ln -s ~/code/claude-code-orchestrator/clawdbot-skill ~/.clawdbot/skills/claude-code-orchestrator
   ```

3. **Restart Clawdbot:**
   ```bash
   clawdbot gateway restart
   ```

## Usage

See `SKILL.md` for full documentation on how Clawdbot should use this skill.

## Requirements

- tmux
- Claude Code CLI (`claude`)
- Bash
- Main orchestrator scripts in `~/code/claude-code-orchestrator/`
