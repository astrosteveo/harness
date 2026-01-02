---
name: gamedev-brainstorming
description: "MUST invoke for game development projects - creating games, game features, or gameplay mechanics."
---

# Gamedev Brainstorming

## Overview

Turn game ideas into fully formed designs through collaborative dialogue, culminating in a Game Design Document (GDD).

**The flow:**
1. Understand the game idea (vision, feel, core loop) - **SKIP if requirements are clear**
2. **RESEARCH** (existing games + tech + market) - BEFORE designing
3. Propose design approaches (informed by research)
4. Create Game Design Document (GDD.md)
5. Transition to implementation planning

## First Action (MANDATORY)

When this skill is invoked, immediately assess:

**Does the user's request already explain what game they want?**
- YES → Skip to Step 2, invoke `harness:researching` immediately
- NO → Ask ONE clarifying question about their game vision

Most game ideas ARE clear enough. When in doubt, research first.

## The Iron Rule

```
NO DESIGNING UNTIL RESEARCH IS COMPLETE
```

You cannot propose mechanics, systems, or architecture until you have:
- Explored similar games for reference
- Researched technical requirements
- Verified engine/framework capabilities

## The Process

### Step 1: Understand the Game Idea

**SKIP THIS STEP if the user has already explained what they want clearly.**

Signs you can skip Step 1:
- User described the core gameplay loop
- User gave reference games (e.g., "like Celeste meets Hollow Knight")
- User explained the player experience they want
- You have enough info to know WHAT to research

**If you need more clarity, ask about:**

| Category | Good Questions |
|----------|----------------|
| **Core Loop** | "What's the primary action players will repeat?" |
| **Feel** | "What emotion should the game evoke?" |
| **Reference** | "Any games that capture the feel you want?" |
| **Scope** | "Is this a jam game, side project, or full release?" |
| **Platform** | "What platforms are you targeting?" |

**Ask one question at a time. Prefer multiple choice.**

### Step 2: Research (REQUIRED)

**REQUIRED SUB-SKILL:** Use harness:researching

**This happens BEFORE proposing ANY design decisions.**

Research for games includes:

#### Game Research
- **Reference games** - How do similar games solve design problems?
- **Core mechanics** - What makes the reference games' mechanics feel good?
- **Player feedback** - What do players love/hate about similar games?

#### Technical Research
- **Engine/framework** - Current versions, capabilities, limitations
- **Asset pipeline** - Supported formats, import workflows
- **Platform requirements** - Performance targets, input methods

#### Market Research (if applicable)
- **Genre conventions** - What players expect from this genre
- **Differentiation** - What makes this game unique

| Rationalization | Reality |
|-----------------|---------|
| "I know this genre" | Play the reference games. Watch gameplay. Find specifics. |
| "Simple game, no research needed" | Simple games need tight feel. Research what makes them feel good. |
| "I'll research during development" | Research after design = rework. Research first. |

### Step 3: Propose Design Approaches (REQUIRED)

**Only AFTER research is complete.**

Present **exactly 3 design approaches** with explicit trade-offs:

| Approach | Focus | When to Recommend |
|----------|-------|-------------------|
| **Minimal Viable Game (MVG)** | Core loop only, fastest to playable | Game jams, prototypes, validating feel |
| **Polished Core** | Core loop + juice + one secondary system | Side projects, demos |
| **Full Scope** | Complete feature set per vision | Serious projects with time/resources |

**Format:**

```markdown
## Design Approaches

### Approach A: Minimal Viable Game
**Core Loop:** [Primary mechanic only]
**Systems:** [List essential systems]
**Scope:** [Estimated complexity]
**Pros:** Fast to playable, easy to pivot, validates feel
**Cons:** Missing depth, may not represent full vision
**Tech:** [Specific engine/framework recommendations]

### Approach B: Polished Core
**Core Loop:** [Primary mechanic with juice]
**Systems:** [Core + one secondary system]
**Scope:** [Estimated complexity]
**Pros:** Feels complete, good demo potential
**Cons:** More work before validation
**Tech:** [Specific recommendations]

### Approach C: Full Scope
**Core Loop:** [Complete primary mechanic]
**Systems:** [All planned systems]
**Scope:** [Estimated complexity]
**Pros:** Matches vision, production-ready
**Cons:** Significant time investment, harder to pivot
**Tech:** [Specific recommendations]

---

**Recommendation:** Approach [X] because [specific reasons based on research]

Which approach would you like to proceed with?
```

### Step 4: Create Game Design Document

**Once approach is chosen, create the GDD.**

Save to: `.harness/NNN-feature-slug/gdd.md`

**GDD Structure:**

```markdown
# [Game Title] - Game Design Document

> **Version:** 1.0
> **Last Updated:** [Date]
> **Status:** Draft | In Development | Final

---

## 1. Overview

### High Concept
[One sentence pitch - "It's X meets Y with Z"]

### Genre & Platform
- **Genre:** [Primary genre / Sub-genre]
- **Platform(s):** [Target platforms]
- **Target Audience:** [Who is this for?]

### Core Experience
[2-3 sentences describing what the player FEELS while playing]

---

## 2. Gameplay

### Core Loop
[Describe the primary action loop the player repeats]

```
[Diagram or step-by-step of core loop]
```

### Primary Mechanics
| Mechanic | Description | Feel Target |
|----------|-------------|-------------|
| [Name] | [What it does] | [How it should feel] |

### Secondary Systems
| System | Purpose | Interacts With |
|--------|---------|----------------|
| [Name] | [Why it exists] | [Other systems] |

### Progression
[How does the player advance? What motivates continued play?]

---

## 3. Game World

### Setting
[Where/when does this take place?]

### Visual Style
[Art direction - reference images, color palette, mood]

### Audio Direction
[Sound design goals, music style, reference tracks]

---

## 4. Technical

### Engine/Framework
[Specific engine with version]

### Target Performance
| Platform | Resolution | Frame Rate |
|----------|------------|------------|
| [Platform] | [Resolution] | [FPS target] |

### Key Technical Challenges
[What are the hard problems to solve?]

---

## 5. Scope

### MVP Features (Must Have)
- [ ] [Feature 1]
- [ ] [Feature 2]
- [ ] [Feature 3]

### Nice to Have
- [ ] [Feature 4]
- [ ] [Feature 5]

### Out of Scope (This Version)
- [Feature explicitly NOT included]

---

## 6. References

### Reference Games
| Game | What to Learn |
|------|---------------|
| [Game] | [Specific mechanic/feel to study] |

### Documentation
- [Link to engine docs]
- [Link to relevant tutorials]
```

### Step 5: Transition to Implementation

After GDD is saved:

1. **Commit the GDD** to version control
2. **Create requirements.md** - Extract technical requirements from GDD
3. **Invoke harness:writing-plans** - Create implementation plan

**Offer to proceed:**

```
GDD saved to `.harness/NNN-feature-slug/gdd.md`

Ready to create implementation plan?
- YES → I'll invoke harness:writing-plans
- NO → GDD is committed, continue when ready
```

## Game-Specific Considerations

### Feel-First Development

Games succeed or fail on feel. The implementation plan should prioritize:

1. **Core mechanic feel** - Get this right FIRST
2. **Juice/feedback** - Screen shake, particles, sound, animation
3. **Polish secondary systems** - Only after core feels good

### Prototype Loop

For games, the TDD cycle adapts:

```
1. Define feel target (what should this feel like?)
2. Implement minimal mechanic
3. Playtest - does it feel right?
4. Iterate until feel is correct
5. Add juice/polish
6. Repeat
```

### Playtesting Gates

Implementation plans for games should include playtest gates:

| Gate | Criteria |
|------|----------|
| **Core Loop** | Is the primary action fun to repeat? |
| **10-Minute Test** | Will players stay engaged for 10 minutes? |
| **Fresh Eyes** | Does someone unfamiliar understand what to do? |

## After the Design

**Documentation Structure for Games:**

```
.harness/NNN-game-name/
├── gdd.md              # Game Design Document (this skill)
├── requirements.md     # Technical requirements extracted from GDD
├── research.md         # Reference games, tech research
├── design.md           # Architecture decisions (from writing-plans)
└── plan.md             # Implementation plan
```

**Deferred Items:**
- Add "nice to have" features to `.harness/BACKLOG.md`
- Use FEAT-XXX format for future features
- Reference the game's feature directory

## Key Principles

- **Feel over features** - A game with one great mechanic beats many mediocre ones
- **Playtest early** - Get the core loop in front of players ASAP
- **Reference games are research** - Play them, don't just remember them
- **Scope ruthlessly** - Cut features, not quality
- **Juice matters** - Budget time for polish
- **Document decisions** - Future you will forget why you made choices
