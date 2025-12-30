---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute **Phases** sequentially, report for review between Phases.

**Core principle:** Phase-by-phase execution with checkpoints for architect review.

**Note:** This skill is for separate session execution. For same-session execution, use `harness:subagent-driven-development`.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with the user before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Phase

**Execute one Phase at a time:**

For the current Phase:
1. Mark Phase as in_progress in TodoWrite
2. Execute each Task within the Phase sequentially
3. Follow each step exactly (plan has bite-sized steps)
4. Run verifications as specified
5. Commit after each Task
6. Mark Phase as completed when all Tasks done

### Step 3: Report

When Phase complete:
- Show which Phase was implemented
- Show task completion summary
- Show verification output (tests passing)
- Say: "Phase [N] complete. Ready for feedback."

### Step 4: Continue
Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 5: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use harness:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## Choosing Between Execution Modes

See `harness:subagent-driven-development` for the decision flowchart.

**Quick decision:**
- **Same session + fully autonomous?** -> subagent-driven (autonomous mode)
- **Same session + human approval per Phase?** -> subagent-driven (checkpoint mode)
- **Separate session + human review per Phase?** -> executing-plans (this skill)

| Factor | Autonomous | Checkpoints | Batch Review (this skill) |
|--------|------------|-------------|---------------------------|
| Skill | subagent-driven | subagent-driven | executing-plans |
| Session | Same | Same | Separate (worktree) |
| Dispatch unit | Phase | Phase | Phase |
| Human stops | None | After each Phase | After each Phase |
| Reviews | Automated (subagents) | Automated (subagents) | Human |
| Context | Fresh per Phase | Fresh per Phase | Accumulates |
| Speed | Fastest | Medium | Slowest |
| Best for | Independent Phases, trust process | Want oversight per Phase | Complex/risky changes |

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## When Plans Become Invalid

**Signs a plan is invalid:**
- External changes: new requirements, dependency updates, discovered blockers
- Completed tasks reveal gaps or incorrect assumptions

**What to do:**
1. Stop execution immediately
2. Assess scope: minor issue vs fundamental change
3. Decide: adapt in place or return to planning phase

**Adapt vs Re-plan:**
- **Adapt in place:** Small adjustments that don't change overall architecture
- **Re-plan:** Multiple tasks affected, new dependencies, or approach fundamentally flawed

**Communicate changes:** Report what invalidated the plan, propose path forward, wait for stakeholder decision before proceeding.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Between batches: just report and wait
- Stop when blocked, don't guess
