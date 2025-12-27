# Harness for OpenCode

Complete guide for using Harness with [OpenCode.ai](https://opencode.ai).

## Quick Install

Tell OpenCode:

```
Clone https://github.com/astrosteveo/harness to ~/.config/opencode/harness, then create directory ~/.config/opencode/plugin, then symlink ~/.config/opencode/harness/.opencode/plugin/harness.js to ~/.config/opencode/plugin/harness.js, then restart opencode.
```

## Manual Installation

### Prerequisites

- [OpenCode.ai](https://opencode.ai) installed
- Node.js installed
- Git installed

### Installation Steps

#### 1. Install Harness

```bash
mkdir -p ~/.config/opencode/harness
git clone https://github.com/astrosteveo/harness.git ~/.config/opencode/harness
```

#### 2. Register the Plugin

OpenCode discovers plugins from `~/.config/opencode/plugin/`. Create a symlink:

```bash
mkdir -p ~/.config/opencode/plugin
ln -sf ~/.config/opencode/harness/.opencode/plugin/harness.js ~/.config/opencode/plugin/harness.js
```

Alternatively, for project-local installation:

```bash
# In your OpenCode project
mkdir -p .opencode/plugin
ln -sf ~/.config/opencode/harness/.opencode/plugin/harness.js .opencode/plugin/harness.js
```

#### 3. Restart OpenCode

Restart OpenCode to load the plugin. Harness will automatically activate.

## Usage

### Finding Skills

Use the `find_skills` tool to list all available skills:

```
use find_skills tool
```

### Loading a Skill

Use the `use_skill` tool to load a specific skill:

```
use use_skill tool with skill_name: "harness:brainstorming"
```

Skills are automatically inserted into the conversation and persist across context compaction.

### Personal Skills

Create your own skills in `~/.config/opencode/skills/`:

```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

Create `~/.config/opencode/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

### Project Skills

Create project-specific skills in your OpenCode project:

```bash
# In your OpenCode project
mkdir -p .opencode/skills/my-project-skill
```

Create `.opencode/skills/my-project-skill/SKILL.md`:

```markdown
---
name: my-project-skill
description: Use when [condition] - [what it does]
---

# My Project Skill

[Your skill content here]
```

## Skill Priority

Skills are resolved with this priority order:

1. **Project skills** (`.opencode/skills/`) - Highest priority
2. **Personal skills** (`~/.config/opencode/skills/`)
3. **Harness skills** (`~/.config/opencode/harness/skills/`)

You can force resolution to a specific level:
- `project:skill-name` - Force project skill
- `skill-name` - Search project → personal → harness
- `harness:skill-name` - Force harness skill

## Features

### Automatic Context Injection

The plugin automatically injects harness context via the chat.message hook on every session. No manual configuration needed.

### Message Insertion Pattern

When you load a skill with `use_skill`, it's inserted as a user message with `noReply: true`. This ensures skills persist throughout long conversations, even when OpenCode compacts context.

### Compaction Resilience

The plugin listens for `session.compacted` events and automatically re-injects the core harness bootstrap to maintain functionality after context compaction.

### Tool Mapping

Skills written for Claude Code are automatically adapted for OpenCode. The plugin provides mapping instructions:

- `TodoWrite` → `update_plan`
- `Task` with subagents → OpenCode's `@mention` system
- `Skill` tool → `use_skill` custom tool
- File operations → Native OpenCode tools

## Architecture

### Plugin Structure

**Location:** `~/.config/opencode/harness/.opencode/plugin/harness.js`

**Components:**
- Two custom tools: `use_skill`, `find_skills`
- chat.message hook for initial context injection
- event handler for session.compacted re-injection
- Uses shared `lib/skills-core.js` module (also used by Codex)

### Shared Core Module

**Location:** `~/.config/opencode/harness/lib/skills-core.js`

**Functions:**
- `extractFrontmatter()` - Parse skill metadata
- `stripFrontmatter()` - Remove metadata from content
- `findSkillsInDir()` - Recursive skill discovery
- `resolveSkillPath()` - Skill resolution with shadowing
- `checkForUpdates()` - Git update detection

This module is shared between OpenCode and Codex implementations for code reuse.

## Updating

```bash
cd ~/.config/opencode/harness
git pull
```

Restart OpenCode to load the updates.

## Troubleshooting

### Plugin not loading

1. Check plugin file exists: `ls ~/.config/opencode/harness/.opencode/plugin/harness.js`
2. Check symlink: `ls -l ~/.config/opencode/plugin/harness.js`
3. Check OpenCode logs: `opencode run "test" --print-logs --log-level DEBUG`
4. Look for: `service=plugin path=file:///.../harness.js loading plugin`

### Skills not found

1. Verify skills directory: `ls ~/.config/opencode/harness/skills`
2. Use `find_skills` tool to see what's discovered
3. Check skill structure: each skill needs a `SKILL.md` file

### Tools not working

1. Verify plugin loaded: Check OpenCode logs for plugin loading message
2. Check Node.js version: The plugin requires Node.js for ES modules
3. Test plugin manually: `node --input-type=module -e "import('file://~/.config/opencode/plugin/harness.js').then(m => console.log(Object.keys(m)))"`

### Context not injecting

1. Check if chat.message hook is working
2. Verify using-harness skill exists
3. Check OpenCode version (requires recent version with plugin support)

## Getting Help

- Report issues: https://github.com/astrosteveo/harness/issues
- Main documentation: https://github.com/astrosteveo/harness
- OpenCode docs: https://opencode.ai/docs/

## Testing

The implementation includes an automated test suite at `tests/opencode/`:

```bash
# Run all tests
./tests/opencode/run-tests.sh --integration --verbose

# Run specific test
./tests/opencode/run-tests.sh --test test-tools.sh
```

Tests verify:
- Plugin loading
- Skills-core library functionality
- Tool execution (use_skill, find_skills)
- Skill priority resolution
- Proper isolation with temp HOME
