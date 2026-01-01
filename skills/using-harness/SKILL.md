---
name: using-harness
description: "INJECTED AT SESSION START. Foundation skill establishing how to find and use other skills."
---

<MANDATORY-SESSION-START-CHECK>
# ⛔ INCOMPLETE WORK CHECK

**If you see "INCOMPLETE WORK DETECTED" above this skill content, you MUST:**

1. **STOP** - Do not respond to the user's message yet
2. **ASK** - Present the incomplete work info and ask: "Resume? [Yes / No / Abandon]"
3. **WAIT** - Do not proceed until the user responds

**Handling user response:**
- **Yes**: Read the plan file, invoke `harness:subagent-driven-development`
- **No**: Continue with the user's original request
- **Abandon**: Create abandon commit: `git commit --allow-empty -m "chore: abandon [feature] plan\n\nplan: abandoned"`

| Rationalization for skipping | Reality |
|------------------------------|---------|
| "Let me respond to the user first" | NO. Ask about incomplete work FIRST. |
| "The user's question is more important" | Incomplete work is context. Address it first. |
| "I'll mention it later" | Later = forgotten. Ask NOW. |

</MANDATORY-SESSION-START-CHECK>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In other environments:** Check your platform's documentation for how skills are loaded.

# Using Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |
| "I know the current version" | Training data is outdated. Use researching skill. |
| "The API is probably..." | Never assume APIs. Research current docs. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Research skills first** (researching) - verify current versions, APIs, best practices BEFORE making decisions
2. **Process skills second** (brainstorming, debugging) - these determine HOW to approach the task
3. **Implementation skills third** (writing-skills, subagent-driven-development) - these guide execution

"Let's build X" → researching + brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.
"Add library X" → researching first to verify current version and usage patterns.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.
