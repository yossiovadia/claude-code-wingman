#!/bin/bash
# Auto-Approver: Monitors tmux session and auto-approves Claude Code prompts

SESSION_NAME="$1"

if [ -z "$SESSION_NAME" ]; then
    echo "Usage: $0 <tmux-session-name>"
    exit 1
fi

echo "[Auto-Approver] Monitoring session: $SESSION_NAME"

while true; do
    # Capture current pane content
    OUTPUT=$(tmux capture-pane -t "$SESSION_NAME" -p 2>/dev/null)
    
    # Check if session still exists
    if [ $? -ne 0 ]; then
        echo "[Auto-Approver] Session ended. Exiting."
        exit 0
    fi
    
    # Look for approval prompt
    if echo "$OUTPUT" | grep -q "Do you want to proceed?"; then
        echo "[Auto-Approver] Approval prompt detected! Sending '2' (approve for project)..."
        tmux send-keys -t "$SESSION_NAME" "2" C-m
        sleep 2  # Give it time to process
    fi
    
    sleep 1  # Check every second
done
