# Troubleshooting Guide

Common issues and solutions when using the harness plugin.

## Skills Not Triggering

### Symptom
You expect a skill to trigger but the assistant doesn't use it.

### Solutions

1. **Check skill name spelling**
   - Use exact names: `harness:brainstorming` not `harness:brainstorm`
   - See `skills/INDEX.md` for complete list

2. **Explicit invocation**
   - Say: "Use the brainstorming skill" or "Apply harness:brainstorming"
   - The 1% rule should catch most cases, but explicit works best

3. **Check hook is running**
   - Run: `cat ~/.claude/plugins/cache/*/harness/*/hooks/hooks.json`
   - Verify SessionStart hook exists

4. **Restart session**
   - Hooks only run on session start
   - Try `/clear` or start new conversation

## Skill Over-Triggering

### Symptom
Heavy skills trigger for simple questions.

### Solutions

1. **Be explicit about simplicity**
   - Say: "Quick question, no need for formal process..."
   - Say: "Just a simple fix, skip the workflow"

2. **Report as bug**
   - If a skill consistently over-triggers, open an issue
   - Include the prompt that caused over-triggering

## Worktree Issues

### Symptom
Git worktree creation fails.

### Solutions

1. **Check for existing worktree**
   ```bash
   git worktree list
   ```

2. **Clean up stale worktrees**
   ```bash
   git worktree prune
   ```

3. **Verify base branch exists**
   ```bash
   git branch -a | grep main
   ```

4. **Check directory permissions**
   - Ensure you can write to parent directory

## Hook Not Running

### Symptom
Session starts without "You have harness skills" context.

### Solutions

1. **Verify plugin installation**
   ```bash
   ls ~/.claude/plugins/cache/*/harness/*/hooks/
   ```

2. **Check hooks.json syntax**
   ```bash
   python3 -c "import json; json.load(open('hooks/hooks.json'))"
   ```

3. **Test hook script manually**
   ```bash
   cd /path/to/harness/plugin
   ./hooks/session-start.sh
   ```
   Expected: JSON output with additionalContext

## Research Skill Web Search Fails

### Symptom
Researching skill can't fetch current information.

### Solutions

1. **Check network connectivity**
   - Ensure web search is available in your environment

2. **Use specific queries**
   - Instead of: "React best practices"
   - Try: "React 19 best practices 2025"

3. **Fallback to manual research**
   - Ask assistant to provide search queries
   - Research manually and provide findings

## Plan Execution Stuck

### Symptom
Subagent or execution stops mid-plan.

### Solutions

1. **Check for blocking issues**
   - Review last subagent output
   - Look for unanswered questions

2. **Resume explicitly**
   - Say: "Continue with the plan from Task N"
   - Or: "Resume subagent-driven development"

3. **Restart from checkpoint**
   - Plans are saved to `.harness/NNN-feature/plan.md`
   - TodoWrite tracks progress
   - Start new session pointing to plan file

## Getting More Help

1. **Check skill documentation**
   - Each skill has detailed SKILL.md
   - Read the "Red Flags" and "Common Mistakes" sections

2. **Open an issue**
   - GitHub: https://github.com/astrosteveo/harness

3. **Check upstream**
   - Some issues may be addressed in obra/superpowers
