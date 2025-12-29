# Windows Guide for Harness Skills

Harness skills are written with Unix shell commands (bash), which is the default shell on macOS and Linux. Windows users can still use these skills with some adaptations.

## How It Works

When Claude executes bash commands from skills:
- **macOS/Linux**: Commands run directly in bash
- **Windows**: Commands run through Git Bash (if installed) or need translation

Most skills will work automatically if you have Git for Windows installed, which provides Git Bash.

## Command Translation Table

Common Unix commands and their Windows equivalents:

| Unix Command | PowerShell | CMD | Notes |
|--------------|------------|-----|-------|
| `ls` | `Get-ChildItem` or `dir` | `dir` | `ls` works in PowerShell as alias |
| `ls -la` | `Get-ChildItem -Force` | `dir /a` | Shows hidden files |
| `ls -lt` | `Get-ChildItem \| Sort-Object LastWriteTime -Descending` | `dir /od` | Sort by time |
| `cat` | `Get-Content` | `type` | `cat` works in PowerShell |
| `grep` | `Select-String` | `findstr` | Pattern matching |
| `find` | `Get-ChildItem -Recurse` | `dir /s` | File search |
| `mkdir -p` | `New-Item -ItemType Directory -Force` | `mkdir` | Create nested dirs |
| `rm` | `Remove-Item` | `del` | Delete files |
| `rm -rf` | `Remove-Item -Recurse -Force` | `rmdir /s /q` | Delete directories |
| `cp` | `Copy-Item` | `copy` | Copy files |
| `mv` | `Move-Item` | `move` | Move/rename |
| `pwd` | `Get-Location` | `cd` (no args) | Current directory |
| `cd` | `Set-Location` | `cd` | Change directory |
| `touch` | `New-Item` | `type nul >` | Create empty file |
| `head -n 5` | `Get-Content -Head 5` | N/A | First N lines |
| `tail -n 5` | `Get-Content -Tail 5` | N/A | Last N lines |
| `echo $VAR` | `Write-Output $env:VAR` | `echo %VAR%` | Environment vars |
| `export VAR=val` | `$env:VAR = "val"` | `set VAR=val` | Set env var |
| `which` | `Get-Command` | `where` | Find executable |
| `chmod +x` | N/A | N/A | Not applicable on Windows |

## Windows-Specific Considerations

### Path Separators

Unix uses forward slashes (`/`), Windows uses backslashes (`\`):

```bash
# Unix
cd /Users/name/project

# Windows
cd C:\Users\name\project
```

**In Git Bash**: Forward slashes work fine.

**In PowerShell/CMD**: Use backslashes or escape forward slashes.

**In code/config files**: Most modern tools accept forward slashes on Windows.

### Line Endings

Unix uses LF (`\n`), Windows uses CRLF (`\r\n`):

**Configure Git to handle this automatically:**
```bash
git config --global core.autocrlf true
```

**For existing files with wrong line endings:**
- VS Code: Click "CRLF" or "LF" in status bar to convert
- Git: Files are normalized on commit if autocrlf is configured

### Shell Differences

| Aspect | Bash | PowerShell | CMD |
|--------|------|------------|-----|
| Variables | `$VAR` | `$VAR` or `$env:VAR` | `%VAR%` |
| String quotes | Single or double | Single (literal) or double (interpolated) | Double only |
| Pipes | `\|` | `\|` | `\|` |
| Command chaining | `&&` | `;` or `&&` (PS 7+) | `&&` |
| Comments | `#` | `#` | `REM` |
| Here-docs | `<<EOF` | `@"..."@` | N/A |

### File Permissions

Unix has `chmod` for file permissions. Windows uses ACLs (Access Control Lists):

- `chmod +x` (make executable) has no direct equivalent - Windows uses file extensions
- Scripts are executable based on extension (`.bat`, `.cmd`, `.ps1`)
- For shell scripts, run them explicitly: `bash script.sh`

### Environment Variables

```bash
# Unix - in bash
export MY_VAR="value"
echo $MY_VAR

# Windows - in PowerShell
$env:MY_VAR = "value"
echo $env:MY_VAR

# Windows - in CMD
set MY_VAR=value
echo %MY_VAR%
```

## Hook-Specific Guidance

For running Harness hooks on Windows, see **[polyglot-hooks.md](windows/polyglot-hooks.md)**.

Key points from that document:
- Use the polyglot `.cmd` wrapper pattern for cross-platform hooks
- Requires Git for Windows (provides `bash.exe`)
- The wrapper runs bash scripts via `C:\Program Files\Git\bin\bash.exe`

## Skills That May Need Special Handling

### using-git-worktrees

The skill uses bash commands like `ls -d` and `grep`. On Windows:
- Git Bash: Works as-is
- PowerShell: Use `Test-Path` instead of `ls -d`

```powershell
# PowerShell equivalent to: ls -d .worktrees 2>/dev/null
if (Test-Path .worktrees) { ".worktrees" }
```

### resuming-work

Uses `find` command with `-exec`. On Windows:
- Git Bash: Works as-is
- PowerShell: Use `Get-ChildItem -Recurse`

```powershell
# PowerShell equivalent to: find .harness -name "plan.md"
Get-ChildItem -Path .harness -Recurse -Filter "plan.md"
```

### finishing-a-development-branch

Uses `grep` for worktree detection. On Windows:
- Git Bash: Works as-is
- PowerShell: Use `Select-String`

```powershell
# PowerShell equivalent to: git worktree list | grep $(git branch --show-current)
git worktree list | Select-String (git branch --show-current)
```

### systematic-debugging

Uses `env | grep` pattern. On Windows:
- PowerShell: `Get-ChildItem Env: | Where-Object { $_.Name -match "PATTERN" }`
- CMD: `set | findstr PATTERN`

### test-driven-development

Uses `npm test`, `cargo test`, `pytest`, `go test` - these work the same on Windows as long as the tools are installed.

## Recommended Setup for Windows

1. **Install Git for Windows**: Provides Git Bash with common Unix utilities
   - Download from https://git-scm.com/download/win
   - During installation, choose "Use Git from the Windows Command Prompt"

2. **Configure Git line endings**:
   ```bash
   git config --global core.autocrlf true
   ```

3. **Use a Unix-like terminal**:
   - Git Bash (included with Git for Windows)
   - Windows Terminal with Git Bash profile
   - WSL (Windows Subsystem for Linux) for full Linux compatibility

4. **Set default shell in VS Code** (if applicable):
   - Open Settings
   - Search for "terminal.integrated.defaultProfile.windows"
   - Set to "Git Bash"

## Troubleshooting

### "command not found" errors

- Ensure Git for Windows is installed
- Check that Git Bash binaries are in PATH
- For Git Bash: verify `C:\Program Files\Git\bin` is in PATH

### Scripts open in text editor instead of running

- Windows associates `.sh` files with text editors by default
- Run explicitly with `bash script.sh`
- Or use the polyglot wrapper pattern (see polyglot-hooks.md)

### Path issues with spaces

Paths with spaces need quoting:
```bash
# Works
cd "/c/Program Files/Git"

# Fails
cd /c/Program Files/Git
```

### Environment variables not available

Check you're using the right syntax for your shell:
- Bash: `$VAR`
- PowerShell: `$env:VAR`
- CMD: `%VAR%`

## Additional Resources

- [Git for Windows](https://git-scm.com/download/win)
- [Windows Terminal](https://github.com/microsoft/terminal)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [polyglot-hooks.md](windows/polyglot-hooks.md) - Cross-platform hook patterns
