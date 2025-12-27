# Installing Harness for Codex

Quick setup to enable harness skills in Codex.

## Installation

1. **Clone harness repository**:
   ```bash
   mkdir -p ~/.codex/harness
   cd ~/.codex/harness
   git clone https://github.com/astrosteveo/harness.git .
   ```

2. **Create personal skills directory**:
   ```bash
   mkdir -p ~/.codex/skills
   ```

3. **Update ~/.codex/AGENTS.md** to include this harness section:
   ```markdown
   ## Harness System

   <EXTREMELY_IMPORTANT>
   You have harness. Harness teach you new skills and capabilities. RIGHT NOW run: `~/.codex/harness/.codex/harness-codex bootstrap` and follow the instructions it returns.
   </EXTREMELY_IMPORTANT>
   ```

## Verification

Test the installation:
```bash
~/.codex/harness/.codex/harness-codex bootstrap
```

You should see skill listings and bootstrap instructions. The system is now ready for use.