---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**
- Check out the current project state first (files, docs, recent commits)
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Researching current technologies (REQUIRED):**
- **REQUIRED SUB-SKILL:** Use harness:researching before proposing approaches
- Identify any external libraries, frameworks, or APIs involved
- Research current versions, best practices, and recommended patterns
- Never rely on training data for version numbers or API signatures
- Flag any deprecated approaches or better alternatives discovered

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- **Inform recommendations with research findings** - cite current versions and practices
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why
- Explicitly note if research contradicts common assumptions

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Documentation Structure:**

All project documents are saved to `.harness/NNN-feature-slug/` where:
- `NNN` is a zero-padded sequence number (001, 002, etc.)
- `feature-slug` is a kebab-case name for the feature

**To determine the next sequence number:**
1. Check existing `.harness/` directories
2. Find the highest NNN prefix
3. Increment by 1 for the new feature

**Save documents:**
- Requirements: `.harness/NNN-feature-slug/requirements.md`
- Research: `.harness/NNN-feature-slug/research.md` (from harness:researching)
- Design: `.harness/NNN-feature-slug/design.md`
- Plan: `.harness/NNN-feature-slug/plan.md` (from harness:writing-plans)

**Commit the design document to git after saving.**

**Deferred Items:**
If any features, bugs, or tasks are identified but deferred during brainstorming:
- Add them to `.harness/BACKLOG.md`
- Use the backlog format (see harness:backlog-tracking)

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?"
- Use harness:using-git-worktrees to create isolated workspace
- Use harness:writing-plans to create detailed implementation plan

## Key Principles

- **Research before recommending** - Never assume versions or APIs from training data
- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
- **Cite current sources** - Reference documentation URLs when making recommendations
