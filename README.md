# Harness

A structured development workflow for coding agents that emphasizes **research-driven planning**, test-driven development, and verified delivery. Harness ensures your AI assistant doesn't rely on outdated training data when building software.

## What Makes Harness Different

**Research Before Planning** - Before proposing any approach or writing any code, Harness triggers research to verify current library versions, API signatures, best practices, and design patterns. No more outdated dependencies or deprecated methods from stale training data.

**Structured Workflow** - From idea to PR with full Git audit trail:
1. **Brainstorming** - Socratic discovery to understand what you're really building
2. **Research** - Verify current technologies before making recommendations
3. **Planning** - Detailed implementation plans with exact code and commands
4. **Execution** - Subagent-driven development with two-stage code review
5. **Delivery** - Verified completion with merge/PR decision workflow

**Skills-Based Architecture** - Composable skills that trigger automatically based on context. Your agent just works the right way.

**Organized Documentation** - All project artifacts are stored in `.harness/NNN-feature-slug/` directories with structured documents for requirements, research, design, and implementation plans.

**Backlog Tracking** - Bugs, deferred features, and technical debt are tracked in `.harness/BACKLOG.md` so nothing falls through the cracks.

## Installation

```bash
# Add the marketplace
/plugin marketplace add astrosteveo/claude-code-plugins

# Install the plugin
/plugin install harness@astrosteveo-plugins
```

Verify with `/skills` - you should see harness skills listed.

## The Workflow

### 1. Brainstorming
Before writing code, Harness asks questions to understand what you're building. It presents designs in digestible chunks and validates each section with you.

### 2. Researching (NEW)
Before proposing approaches, Harness researches:
- **Current versions** - Latest stable releases of libraries/frameworks
- **API signatures** - Actual method names and parameters
- **Best practices** - Current recommended patterns
- **Deprecations** - What to avoid

Research findings are documented in the plan for reference.

### 3. Writing Plans
Creates implementation plans clear enough for "an enthusiastic junior engineer with no project context" to follow:
- **Thorough research** - Distinct from brainstorming research; now that requirements are concrete, verify exact versions, APIs, and patterns
- Bite-sized tasks (2-5 minutes each)
- Exact file paths and complete code
- Verification commands with expected output
- RED-GREEN-REFACTOR TDD cycle

### 4. Executing Plans
Three execution modes:
- **Autonomous** - Runs to completion with automated spec/code quality reviews by subagents. Best for independent tasks when you trust the process.
- **Checkpoints** - Same automated quality gates, but pauses after each task for your approval. Best when you want oversight and to catch issues early.
- **Batch Review** - Separate session that executes 3 tasks at a time with human review between batches. Best for complex/risky changes.

### 5. Finishing Up
Verifies all tests pass, presents options (merge/PR/keep/discard), cleans up worktree.

## Project Documentation Structure

All documentation is organized in `.harness/`:

```
.harness/
├── BACKLOG.md                    # Bugs, deferred tasks, tech debt
├── 001-user-auth/
│   ├── requirements.md           # User story and acceptance criteria
│   ├── research.md               # Technology research findings
│   ├── design.md                 # Architecture decisions
│   └── plan.md                   # Implementation tasks
├── 002-api-caching/
│   └── ...
```

- **NNN** - Zero-padded sequence number (001, 002, 003...)
- **feature-slug** - Kebab-case description of the feature

## Skills (10 Core)

| Skill | Purpose |
|-------|---------|
| **using-harness** | Foundation - skill invocation, context management |
| **brainstorming** | Design + planning (includes plan writing) |
| **researching** | Verify current versions, APIs, best practices |
| **test-driven-development** | RED-GREEN-REFACTOR cycle |
| **systematic-debugging** | 4-phase root cause analysis |
| **verification-before-completion** | Evidence before claims + finishing work |
| **backlog-tracking** | Track bugs and deferred items |
| **subagent-driven-development** | Execute plans with fresh context per phase |
| **gamedev-brainstorming** | Game development with GDD workflow |
| **writing-skills** | Meta - create new skills |

## Documentation

- [Skill Index](skills/INDEX.md) - Complete list of available skills
- [Code Review Architecture](docs/CODE-REVIEW-ARCHITECTURE.md) - Understanding review mechanisms
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Changelog](CHANGELOG.md) - Version history and changes

## Philosophy

- **Research First** - Never assume versions or APIs from training data
- **Test-Driven Development** - Write tests first, always
- **Systematic over Ad-hoc** - Process over guessing
- **Evidence over Claims** - Verify before declaring success
- **YAGNI** - You Aren't Gonna Need It

## Updating

```bash
/plugin update harness
```

## Credits

Harness is a fork of [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent, enhanced with research-driven planning capabilities to prevent outdated training data from informing architectural decisions.

## Contributing

1. Fork the repository
2. Create a branch for your changes
3. Follow the `writing-skills` skill for new skills
4. Submit a PR

See `skills/writing-skills/SKILL.md` for the complete guide.

## License

MIT License - see LICENSE file for details.

## Support

- **Issues**: https://github.com/astrosteveo/harness/issues
- **Original Project**: https://github.com/obra/superpowers
