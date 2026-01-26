# Research Notes

## Step 1: Auto-Approval Settings

### Question
Can Claude Code be configured to auto-approve commands without interactive prompts?

### Approaches to Test

1. **Project-level CLAUDE.md file**
   - Claude Code looks for `CLAUDE.md` in project root
   - May contain approval settings

2. **Settings file override**
   - Use `--settings` flag with JSON config
   - Check if there's an `auto_approve` or similar setting

3. **Per-directory approval memory**
   - When user selects "Yes, and don't ask again for X in this directory"
   - Where does Claude Code store this? Can we pre-populate it?

4. **Programmatic approval**
   - Detect approval prompt in output
   - Auto-send "2" (approve for directory)
   - Not ideal but works as fallback

### Tests to Run

- [ ] Test 1: Check if CLAUDE.md can configure approvals
- [ ] Test 2: Try --settings with approval config
- [ ] Test 3: Find where approval preferences are stored
- [ ] Test 4: Programmatic detection & response

---

## Findings

*(Will document as we test)*
