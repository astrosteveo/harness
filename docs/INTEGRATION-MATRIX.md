# Harness Integration Matrix

> Platform support comparison for Claude Code, Codex, and OpenCode.

## Quick Summary

| Platform | Status | Installation | Skill Loading | Subagents | Auto-Injection |
|----------|--------|--------------|---------------|-----------|----------------|
| Claude Code | Primary | Plugin system | Native `Skill` tool | Full support | Via hooks |
| OpenCode | Supported | Plugin symlink | `use_skill` tool | `@mention` system | `session.created` event |
| Codex | Experimental | Manual clone | CLI script | Not available | Manual bootstrap |

---

## Feature Comparison Matrix

### Core Features

| Feature | Claude Code | OpenCode | Codex |
|---------|-------------|----------|-------|
| Skill discovery | `find_skills` built-in | `find_skills` tool | `harness-codex find-skills` CLI |
| Skill loading | `Skill` tool | `use_skill` tool | `harness-codex use-skill` CLI |
| Auto-bootstrap | Session hooks | `session.created` event | Manual |
| Context persistence | Native | `noReply` message insertion | Manual re-run |
| Compaction resilience | Native | `session.compacted` event handler | Not supported |
| Update notifications | Yes | Planned | `bootstrap` command |

### Tool Mapping

Skills reference Claude Code tools. Other platforms substitute equivalents:

| Claude Code Tool | OpenCode Equivalent | Codex Equivalent |
|------------------|---------------------|------------------|
| `TodoWrite` | `update_plan` | `update_plan` |
| `Task` (subagents) | `@mention` system | Not available (do work directly) |
| `Skill` | `use_skill` | `harness-codex use-skill` |
| `Read` | Native | Native |
| `Write` | Native | Native |
| `Edit` | Native | Native |
| `Bash` | Native | Native |
| `Grep` | Native | Native |
| `Glob` | Native | Native |

### Skill Namespace Priority

| Priority | Claude Code | OpenCode | Codex |
|----------|-------------|----------|-------|
| 1 (highest) | Personal override | `project:` (`.opencode/skills/`) | Personal (`~/.codex/skills/`) |
| 2 | Harness | Personal (`~/.config/opencode/skills/`) | Harness (`~/.codex/harness/skills/`) |
| 3 (lowest) | - | `harness:` (`~/.config/opencode/harness/skills/`) | - |

---

## Skills Availability

All 18 skills work across platforms, but some features require tool substitution:

| Skill | Claude Code | OpenCode | Codex | Notes |
|-------|-------------|----------|-------|-------|
| using-harness | Full | Full | Full | Foundation skill |
| brainstorming | Full | Full | Full | |
| researching | Full | Full | Full | Requires web search capability |
| writing-plans | Full | Full | Full | |
| executing-plans | Full | Partial | Limited | Checkpoint behavior varies |
| subagent-driven-development | Full | Partial | Limited | Uses `@mention` on OpenCode, manual on Codex |
| test-driven-development | Full | Full | Full | |
| working-with-legacy-code | Full | Full | Full | |
| systematic-debugging | Full | Full | Full | |
| verification-before-completion | Full | Full | Full | |
| writing-documentation | Full | Full | Full | |
| using-git-worktrees | Full | Full | Full | |
| resolving-merge-conflicts | Full | Full | Full | |
| requesting-code-review | Full | Partial | Limited | Subagent-based review |
| receiving-code-review | Full | Full | Full | |
| dispatching-parallel-agents | Full | Partial | Limited | Subagent parallelization |
| finishing-a-development-branch | Full | Full | Full | |
| backlog-tracking | Full | Full | Full | |
| resuming-work | Full | Full | Full | |
| handling-context-exhaustion | Full | Full | Full | |
| writing-skills | Full | Full | Full | |

**Legend:**
- **Full**: All features work as designed
- **Partial**: Core features work, some advanced features require workarounds
- **Limited**: Basic functionality only, significant features missing

---

## Installation Instructions

### Claude Code (Primary Platform)

```bash
# Add the marketplace
/plugin marketplace add astrosteveo/harness-marketplace

# Install the plugin
/plugin install harness@harness-marketplace

# Verify installation
/help
# Look for: /harness:brainstorm, /harness:write-plan, /harness:execute-plan
```

**Update:**
```bash
/plugin update harness
```

### OpenCode

```bash
# Clone harness
mkdir -p ~/.config/opencode/harness
git clone https://github.com/astrosteveo/harness.git ~/.config/opencode/harness

# Register the plugin (symlink)
mkdir -p ~/.config/opencode/plugin
ln -sf ~/.config/opencode/harness/.opencode/plugin/harness.js ~/.config/opencode/plugin/harness.js

# Restart OpenCode
```

**Project-local installation (alternative):**
```bash
mkdir -p .opencode/plugin
ln -sf ~/.config/opencode/harness/.opencode/plugin/harness.js .opencode/plugin/harness.js
```

**Update:**
```bash
cd ~/.config/opencode/harness && git pull
# Restart OpenCode
```

### Codex (Experimental)

Tell Codex:
```
Fetch and follow instructions from https://raw.githubusercontent.com/astrosteveo/harness/refs/heads/main/.codex/INSTALL.md
```

**Manual installation:**
```bash
# Clone harness
mkdir -p ~/.codex/harness
git clone https://github.com/astrosteveo/harness.git ~/.codex/harness

# Make CLI executable
chmod +x ~/.codex/harness/.codex/harness-codex

# Bootstrap
~/.codex/harness/.codex/harness-codex bootstrap
```

**Update:**
```bash
cd ~/.codex/harness && git pull
```

---

## Platform-Specific Limitations

### Claude Code

| Limitation | Impact | Workaround |
|------------|--------|------------|
| None known | - | - |

Claude Code is the primary development platform. All features are designed for and tested on this platform first.

### OpenCode

| Limitation | Impact | Workaround |
|------------|--------|------------|
| No native `Skill` tool | Skills loaded via custom tool | Use `use_skill` tool |
| Different subagent system | `Task` tool not available | Use `@mention` system |
| Context compaction | Skills may be lost on long conversations | Auto-re-injection via `session.compacted` event |
| Plugin discovery | Requires manual symlink setup | Follow installation steps exactly |
| ES module requirement | Older Node.js may fail | Use Node.js v18+ |

### Codex

| Limitation | Impact | Workaround |
|------------|--------|------------|
| No native skill system | Skills loaded via CLI | Run `harness-codex use-skill <name>` |
| No subagent support | Cannot delegate to parallel agents | Do work directly in main session |
| No auto-bootstrap | Must manually initialize each session | Run `harness-codex bootstrap` |
| No compaction resilience | Skills lost on context limit | Manually re-run `use-skill` |
| No context persistence | Skills are output text, not system state | Skills remain as conversation history |
| Experimental status | May require refinement | Report issues to GitHub |

---

## Architecture Comparison

### Claude Code

```
.claude-plugin/
├── plugin.json          # Plugin metadata (name, version, author)
└── marketplace.json     # Marketplace configuration

skills/                  # Skill definitions (SKILL.md files)
commands/                # CLI commands
hooks/                   # Session hooks
lib/                     # Shared utilities
```

**Loading mechanism:** Native plugin system with `Skill` tool integration.

### OpenCode

```
~/.config/opencode/
├── harness/             # Cloned repository
│   ├── .opencode/
│   │   └── plugin/
│   │       └── harness.js    # Main plugin (ES module)
│   ├── lib/
│   │   └── skills-core.js    # Shared skill utilities
│   └── skills/               # Skill definitions
└── plugin/
    └── harness.js -> ...     # Symlink to plugin
```

**Loading mechanism:** OpenCode plugin system discovers `~/.config/opencode/plugin/harness.js` on startup. Plugin provides `use_skill` and `find_skills` tools.

**Event hooks:**
- `session.created`: Injects bootstrap content
- `session.compacted`: Re-injects compact bootstrap after context compaction

### Codex

```
~/.codex/
├── harness/                     # Cloned repository
│   ├── .codex/
│   │   ├── harness-codex        # Node.js CLI script
│   │   ├── harness-bootstrap.md # Bootstrap content
│   │   └── INSTALL.md           # Installation instructions
│   ├── lib/
│   │   └── skills-core.js       # Shared skill utilities (ES module)
│   └── skills/                  # Skill definitions
└── skills/                      # Personal skills (optional)
```

**Loading mechanism:** CLI script invoked by user/agent. Outputs skill content to stdout.

**Commands:**
- `harness-codex bootstrap`: Full bootstrap with skill list and using-harness
- `harness-codex use-skill <name>`: Load specific skill
- `harness-codex find-skills`: List available skills

---

## Shared Code

The `lib/skills-core.js` module is shared between OpenCode and Codex implementations:

| Function | Purpose |
|----------|---------|
| `extractFrontmatter()` | Parse YAML frontmatter from SKILL.md |
| `stripFrontmatter()` | Remove frontmatter, return content only |
| `findSkillsInDir()` | Recursive skill discovery |
| `resolveSkillPath()` | Skill resolution with shadowing support |
| `checkForUpdates()` | Git update detection (3s timeout) |

**Note:** The Codex CLI uses CommonJS `require()` while OpenCode uses ES module `import`. The shared module exports in ES module format.

---

## Troubleshooting by Platform

### Claude Code

| Issue | Solution |
|-------|----------|
| Skills not showing in `/help` | Run `/plugin install harness@harness-marketplace` |
| Plugin not updating | Run `/plugin update harness` |
| Marketplace not found | Run `/plugin marketplace add astrosteveo/harness-marketplace` |

### OpenCode

| Issue | Solution |
|-------|----------|
| Plugin not loading | Check symlink: `ls -l ~/.config/opencode/plugin/harness.js` |
| Skills not found | Verify: `ls ~/.config/opencode/harness/skills` |
| Node.js errors | Upgrade to Node.js v18+ for ES module support |
| Tools not working | Check OpenCode logs: `opencode run "test" --print-logs --log-level DEBUG` |
| Context not injecting | Verify `session.created` hook is firing |

### Codex

| Issue | Solution |
|-------|----------|
| Skills not found | Verify: `ls ~/.codex/harness/skills` |
| CLI not executable | Run: `chmod +x ~/.codex/harness/.codex/harness-codex` |
| Node.js errors | Verify: `node --version` (v14+ required, v18+ recommended) |
| Bootstrap not working | Check: `~/.codex/harness/.codex/harness-codex bootstrap` |

---

## Testing

### Claude Code

Tests located in `tests/claude-code/` and `tests/skill-triggering/`.

```bash
./tests/skill-triggering/run-test.sh <skill-name>
```

### OpenCode

Tests located in `tests/opencode/`.

```bash
# Run all tests
./tests/opencode/run-tests.sh --integration --verbose

# Run specific test
./tests/opencode/run-tests.sh --test test-tools.sh
```

### Codex

No automated test suite. Manual verification:

```bash
# Verify installation
ls ~/.codex/harness/skills

# Test CLI
~/.codex/harness/.codex/harness-codex find-skills

# Test skill loading
~/.codex/harness/.codex/harness-codex use-skill harness:brainstorming
```

---

## Version Information

| Component | Version | Location |
|-----------|---------|----------|
| Plugin version | 4.0.3 | `.claude-plugin/plugin.json` |
| Repository | github.com/astrosteveo/harness | Main repository |
| Upstream | github.com/obra/superpowers | Fork source |

---

## Getting Help

- **GitHub Issues:** https://github.com/astrosteveo/harness/issues
- **OpenCode Docs:** https://opencode.ai/docs/
- **Upstream Project:** https://github.com/obra/superpowers
