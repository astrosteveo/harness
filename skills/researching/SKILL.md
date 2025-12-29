---
name: researching
description: "MUST use before planning or implementing features involving external libraries, frameworks, or APIs. Fetches current versions, best practices, and documentation to prevent outdated training data from informing decisions."
---

# Researching Current Technologies

## Overview

Research current library versions, best practices, design patterns, and documentation BEFORE making architectural decisions or writing implementation plans. Never rely on training data for version numbers, API signatures, or current recommendations.

**Announce at start:** "I'm using the researching skill to gather current information about the technologies involved."

## When To Use This Skill

**ALWAYS use when:**
- Planning features that use external libraries or frameworks
- Making technology choice recommendations
- Writing implementation code that uses third-party dependencies
- Discussing best practices or design patterns for specific technologies
- Any time you would otherwise rely on training data for versions/APIs

**Skip only when:**
- Working with purely internal code with no external dependencies
- User explicitly says they don't need current research

## The Research Process

### Step 1: Identify Research Targets

From the current task, identify:
- **Libraries/Frameworks:** Any external dependencies mentioned or implied
- **APIs:** External services or platform APIs being used
- **Patterns:** Design patterns or architectural approaches being considered
- **Tools:** Build tools, testing frameworks, deployment platforms

### Step 2: Research Each Target

For each technology identified, use web search to find:

**Version Information:**
- Current stable version
- Latest major version release date
- Breaking changes from previous versions
- LTS (Long Term Support) status if applicable

**API & Usage:**
- Current API signatures for features being used
- Deprecated methods to avoid
- New recommended approaches
- Common gotchas and pitfalls

**Best Practices:**
- Official documentation recommendations
- Community consensus on patterns
- Anti-patterns to avoid
- Performance considerations

**Migration & Compatibility:**
- Peer dependency requirements
- Compatibility with other libraries in the stack
- Migration guides if upgrading

### Step 3: Document Findings

Create a research summary with this structure:

```markdown
## Research Findings: [Technology Stack]

**Researched on:** YYYY-MM-DD
**Context:** [What feature/task this research supports]

### [Library/Framework Name]

**Current Version:** X.Y.Z (released YYYY-MM-DD)
**Documentation:** [URL]

**Key Findings:**
- [Important discovery 1]
- [Important discovery 2]

**Recommendations:**
- [Specific recommendation for this project]

**Avoid:**
- [Deprecated approach or anti-pattern]

---
```

### Step 4: Share Findings

- Present key findings to the user before proceeding
- Highlight any discoveries that contradict common assumptions
- Flag any version mismatches with existing project dependencies
- Save comprehensive findings to `.harness/NNN-feature-slug/research.md`

**Note:** Save research in the same `.harness/NNN-feature-slug/` directory as the related design and plan documents. If a feature directory already exists, use it. Otherwise, create a new one following the naming convention (see brainstorming skill).

## Research Queries

Use targeted, specific searches. Examples:

**For versions:**
- "[library name] latest version 2025"
- "[library name] changelog latest release"
- "[library name] npm/pypi current version"

**For best practices:**
- "[library name] best practices 2025"
- "[library name] recommended patterns"
- "[library name] official documentation getting started"

**For specific features:**
- "[library name] [feature] example"
- "[library name] how to [specific task]"
- "[library name] [feature] breaking changes"

**For compatibility:**
- "[library A] [library B] compatibility"
- "[library name] peer dependencies"
- "[framework name] [library name] integration"

## Integration With Other Skills

### When Called From Brainstorming

Research BEFORE proposing approaches:
1. Identify technologies the user is considering
2. Research current state of each
3. Include research findings when presenting trade-offs
4. Flag any technologies that are deprecated or have better alternatives

### When Called From Writing-Plans

Research BEFORE specifying implementations:
1. Verify versions for package.json/requirements.txt
2. Confirm API signatures before writing code examples
3. Check for deprecated methods in planned code
4. Validate that planned patterns match current recommendations

## Key Principles

- **Never assume versions** - Always verify current stable version
- **Never assume APIs** - Confirm method signatures and parameters
- **Flag contradictions** - If research contradicts training knowledge, explicitly note this
- **Cite sources** - Include URLs to documentation when providing recommendations
- **Recency matters** - Prefer sources from the current year
- **Official first** - Prioritize official documentation over blog posts

## Example Research Session

User wants to add form validation to a React app:

```
"I'm using the researching skill to gather current information about form validation options in React."

**Research targets identified:**
- React Hook Form vs Formik vs Zod (current recommendations)
- React 18/19 compatibility
- TypeScript integration patterns

**Searching for current information...**

**Key findings:**

1. **React Hook Form v7.54.0** (current stable)
   - Now the community-recommended approach over Formik
   - Native TypeScript support improved significantly
   - Zod integration via @hookform/resolvers

2. **Zod v3.24.0** (current stable)
   - Standard for TypeScript-first validation
   - Excellent React Hook Form integration
   - Can share validation between client/server

3. **Recommendation for this project:**
   - Use React Hook Form + Zod (modern standard)
   - Avoid Formik (less maintained, more verbose)
   - Avoid Yup (Zod preferred for TypeScript)
```

## Reusing Research

**Reuse when:**
- Same session and topic was recently researched
- Saved research exists in `.harness/NNN-feature/research.md` for current feature
- Information is not time-sensitive (patterns, architecture)

**Re-research when:**
- Versions may have changed (new session, weeks later)
- Previous research didn't cover current scope
- User asks about specific recent changes

**How to reference:** Check `.harness/NNN-feature/research.md` before starting new research. Cite findings with "Per earlier research..." and note the date.

## After Research

- Proceed to brainstorming with research-informed recommendations
- Or proceed to writing-plans with verified versions and APIs
- Reference research document in plan header if saved to file
