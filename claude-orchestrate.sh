#!/bin/bash
# Claude Code Orchestrator - Complete wrapper for automated Claude Code sessions

set -e

# Configuration
SESSION_PREFIX="claude-auto"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTO_APPROVER="$SCRIPT_DIR/auto-approver.sh"

# Usage
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --session <name>      Session name (default: auto-generated)"
    echo "  --workdir <path>      Working directory (default: current dir)"
    echo "  --prompt <text>       Prompt to send to Claude Code"
    echo "  --model <model>       Model to use (default: opus)"
    echo "  --monitor             Monitor session in real-time (blocks)"
    echo "  --wait                Wait for completion"
    echo ""
    echo "Examples:"
    echo "  $0 --workdir ~/code/myproject --prompt 'Add error handling to api.py'"
    echo "  $0 --session vsr-123 --prompt 'Fix the bug in line 42' --wait"
    exit 1
}

# Parse arguments
SESSION_NAME=""
WORKDIR="$(pwd)"
PROMPT=""
MODEL=""  # Empty = use Claude Code's default
MONITOR=false
WAIT=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --session)
            SESSION_NAME="$2"
            shift 2
            ;;
        --workdir)
            WORKDIR="$2"
            shift 2
            ;;
        --prompt)
            PROMPT="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --monitor)
            MONITOR=true
            shift
            ;;
        --wait)
            WAIT=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate
if [ -z "$PROMPT" ]; then
    echo "Error: --prompt is required"
    usage
fi

if [ ! -d "$WORKDIR" ]; then
    echo "Error: Working directory does not exist: $WORKDIR"
    exit 1
fi

# Generate session name if not provided
if [ -z "$SESSION_NAME" ]; then
    SESSION_NAME="${SESSION_PREFIX}-$(date +%s)"
fi

echo "[Orchestrator] Starting Claude Code session: $SESSION_NAME"
echo "[Orchestrator] Working directory: $WORKDIR"
echo "[Orchestrator] Model: $MODEL"
echo "[Orchestrator] Prompt: $PROMPT"
echo ""

# Clean up any existing session
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

# Step 1: Create tmux session
echo "[Orchestrator] Creating tmux session..."
tmux new-session -d -s "$SESSION_NAME" -c "$WORKDIR"

# Step 2: Start auto-approver in background
echo "[Orchestrator] Starting auto-approver..."
LOG_FILE="/tmp/auto-approver-${SESSION_NAME}.log"
"$AUTO_APPROVER" "$SESSION_NAME" > "$LOG_FILE" 2>&1 &
AUTO_APPROVER_PID=$!
echo "[Orchestrator] Auto-approver running (PID: $AUTO_APPROVER_PID)"

# Step 3: Start Claude Code
echo "[Orchestrator] Launching Claude Code..."
if [ -n "$MODEL" ]; then
    tmux send-keys -t "$SESSION_NAME" "claude --model $MODEL" C-m
else
    tmux send-keys -t "$SESSION_NAME" "claude" C-m
fi

# Wait for Claude Code to initialize
echo "[Orchestrator] Waiting for Claude Code to initialize..."
sleep 5

# Step 4: Send prompt
echo "[Orchestrator] Sending prompt..."
tmux send-keys -t "$SESSION_NAME" "$PROMPT" C-m

# Wait a moment for prompt to be accepted
sleep 2

echo ""
echo "[Orchestrator] Session started successfully!"
echo ""
echo "Commands:"
echo "  Attach:    tmux attach -t $SESSION_NAME"
echo "  Monitor:   tmux capture-pane -t $SESSION_NAME -p"
echo "  Logs:      cat $LOG_FILE"
echo "  Kill:      tmux kill-session -t $SESSION_NAME"
echo ""

# Monitor mode
if [ "$MONITOR" = true ]; then
    echo "[Orchestrator] Monitoring session (Ctrl+C to stop monitoring, session continues)..."
    echo ""
    while tmux has-session -t "$SESSION_NAME" 2>/dev/null; do
        clear
        echo "=== Session: $SESSION_NAME ==="
        tmux capture-pane -t "$SESSION_NAME" -p
        echo ""
        echo "=== Auto-Approver Log ==="
        tail -5 "$LOG_FILE" 2>/dev/null || echo "(no log yet)"
        sleep 2
    done
    echo "[Orchestrator] Session ended."
fi

# Wait mode
if [ "$WAIT" = true ] && [ "$MONITOR" = false ]; then
    echo "[Orchestrator] Waiting for session to complete..."
    while tmux has-session -t "$SESSION_NAME" 2>/dev/null; do
        sleep 5
    done
    echo "[Orchestrator] Session completed."
    echo ""
    echo "=== Auto-Approver Log ==="
    cat "$LOG_FILE"
fi
