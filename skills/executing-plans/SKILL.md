---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for architect review.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with the user before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Batch
**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Report
When batch complete:
- Show what was implemented
- Show verification output
- Say: "Ready for feedback."

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
- **Same session + autonomous?** -> subagent-driven-development
- **Parallel session + human checkpoints?** -> executing-plans (this skill)

| Factor | executing-plans | subagent-driven |
|--------|-----------------|-----------------|
| Human involvement | High (review each batch) | Low (autonomous) |
| Context usage | Single session accumulates | Fresh per task |
| Speed | Slower (wait for feedback) | Faster (continuous) |
| Review granularity | Batch-level | Per-task (2-stage) |
| Best for | Complex/risky changes | Independent tasks |

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
