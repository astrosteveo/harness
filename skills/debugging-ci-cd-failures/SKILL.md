---
name: debugging-ci-cd-failures
description: Use when CI/CD pipeline fails, builds break in CI but pass locally, or investigating environment-specific test failures
---

# Debugging CI/CD Pipeline Failures

## Overview

CI failures are different from local failures. You cannot attach a debugger, add breakpoints, or run commands interactively. The environment is ephemeral, logs are truncated, and reproduction is slow.

**Core principle:** CI debugging requires indirect observation. Add instrumentation, capture artifacts, and create reproducible local environments.

## When to Use

```
CI/CD pipeline fails but tests pass locally?     -> Use this skill
Build succeeds locally but fails in CI?          -> Use this skill
Tests are flaky ONLY in CI?                      -> Use this skill
Deployment step fails with unclear errors?       -> Use this skill
"Works on my machine" but not in pipeline?       -> Use this skill
```

**Do NOT use for:**
- Tests that fail both locally and in CI (use systematic-debugging)
- Code logic bugs (use systematic-debugging)
- Flaky tests that reproduce locally (use systematic-debugging)

## Troubleshooting Decision Tree

```
CI failure occurs
    |
    v
Can you reproduce locally?
    |
    +--YES--> Use harness:systematic-debugging
    |
    +--NO---> Continue with this skill
              |
              v
         What type of failure?
              |
              +--Build/compile error---------> Check: Environment differences
              |                                       (Node version, OS, dependencies)
              |
              +--Test failure----------------> Check: Environment variables,
              |                                       timing issues, parallelism
              |
              +--Permission/auth error-------> Check: Secrets, tokens, permissions
              |
              +--Timeout---------------------> Check: Resource limits, network,
              |                                       slow operations
              |
              +--Flaky (intermittent)--------> Check: Race conditions in setup,
                                                      resource contention
```

## Phase 1: Gather Information

**BEFORE attempting fixes:**

### 1. Read CI Logs Carefully

CI logs contain the answer 90% of the time. Common mistakes:
- Stopping at the first error (real error often above)
- Missing truncated output
- Ignoring warnings before the error

**Technique: Find the actual failure point**
```
Look for:
- "error:" or "Error:" (case matters in some systems)
- Exit codes (especially non-zero)
- Stack traces (scroll UP from where you see them)
- Timing information (when did it slow down?)
- The FIRST error, not the last
```

### 2. Compare CI vs Local Environment

Create a checklist:

| Aspect | Local | CI | Match? |
|--------|-------|----|----|
| OS | macOS | Ubuntu | NO |
| Node/Python version | 18.17.0 | 18.x | Maybe |
| Dependencies (lock file) | Current | Cached? | Check |
| Environment variables | .env | Secrets | Check |
| Working directory | /Users/me/proj | /home/runner/work | NO |
| Available memory | 16GB | 7GB | NO |
| Disk space | 500GB | Limited | Maybe |
| Network access | Full | Restricted? | Check |
| Time zone | Local | UTC | NO |
| Parallelism | 1 | 4+ | Check |

### 3. Identify Recent Changes

```bash
# What changed since last successful CI run?
git log --oneline $(git rev-parse origin/main)..HEAD

# What files changed?
git diff --name-only origin/main

# Any workflow/CI config changes?
git diff origin/main -- .github/workflows/ .gitlab-ci.yml Jenkinsfile
```

## Phase 2: Common CI/CD Failure Patterns

### Pattern 1: Environment Differences

**Symptoms:**
- "Command not found"
- Different behavior on same code
- Path-related errors

**Investigation:**
```yaml
# Add debug step to workflow
- name: Debug environment
  run: |
    echo "=== System Info ==="
    uname -a
    echo "=== Tool Versions ==="
    node --version || echo "node not found"
    npm --version || echo "npm not found"
    python --version || echo "python not found"
    echo "=== Environment Variables ==="
    env | sort
    echo "=== Working Directory ==="
    pwd
    ls -la
```

**Common fixes:**
- Pin exact versions in CI config
- Use same base image as local dev container
- Ensure PATH includes required tools

### Pattern 2: Missing or Wrong Secrets

**Symptoms:**
- "Authentication failed"
- Empty variable errors
- 401/403 HTTP errors

**Investigation:**
```yaml
- name: Check secrets availability
  run: |
    # Check if secret is set (without exposing value)
    echo "API_KEY is: ${API_KEY:+SET}${API_KEY:-UNSET}"
    echo "TOKEN length: ${#TOKEN}"
```

**Common causes:**
- Secret not added to CI system
- Wrong secret name (case-sensitive)
- Secret scope wrong (repo vs org)
- Fork PRs cannot access secrets (security feature)

**NEVER do:**
- Print secret values in logs
- Commit secrets to fix CI

### Pattern 3: Permission Issues

**Symptoms:**
- "Permission denied"
- Cannot write to directory
- Cannot execute script

**Investigation:**
```yaml
- name: Check permissions
  run: |
    ls -la
    id
    whoami
    echo "HOME=$HOME"
    echo "Can write to workspace: $(touch .test-write && echo YES || echo NO)"
    rm -f .test-write
```

**Common fixes:**
```yaml
# Make script executable
- run: chmod +x ./scripts/deploy.sh

# Use correct user
- run: sudo chown -R $USER:$USER .
```

### Pattern 4: Timeouts

**Symptoms:**
- "Operation timed out"
- Job cancelled after X minutes
- Hanging with no output

**Investigation:**
```yaml
- name: Run with timing
  run: |
    time npm install
  timeout-minutes: 10
```

**Common causes:**
- Network latency (npm/pip registry slow)
- Waiting for resource that never comes
- Infinite loop triggered by CI environment
- Test waiting for interactive input

**Fixes:**
- Add timeout to specific steps
- Use caching for dependencies
- Add verbose output to find hang point

### Pattern 5: Resource Limits

**Symptoms:**
- "Out of memory"
- "No space left on device"
- Process killed (OOMKilled)

**Investigation:**
```yaml
- name: Check resources
  run: |
    free -h || vm_stat
    df -h
    echo "=== Running processes ==="
    ps aux --sort=-%mem | head -20 || ps aux | head -20
```

**Common fixes:**
```yaml
# Limit Node memory
- run: NODE_OPTIONS="--max-old-space-size=4096" npm run build

# Clear space
- run: |
    docker system prune -af
    rm -rf ~/.npm/_cacache
```

### Pattern 6: Flaky CI (Not Flaky Tests)

**Distinct from flaky tests.** This is when CI infrastructure itself is unreliable.

**Symptoms:**
- Same commit passes/fails randomly
- Failure in setup/teardown, not tests
- Network-related failures
- Race conditions in parallel jobs

**Investigation:**
- Run failed job 3+ times without code changes
- Check CI system status page
- Review parallel job coordination

**Common causes:**
- Service startup race conditions
- Port conflicts in parallel runs
- External service intermittent
- Cache corruption

**Fixes:**
```yaml
# Wait for service
- name: Wait for database
  run: |
    for i in {1..30}; do
      pg_isready -h localhost && break
      echo "Waiting for postgres..."
      sleep 1
    done

# Avoid port conflicts
- run: |
    PORT=$(shuf -i 3000-9000 -n 1)
    npm run test -- --port $PORT
```

## Phase 3: Reproducing CI Locally

### Option 1: Docker with CI Image

```bash
# GitHub Actions Ubuntu
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/catthehacker/ubuntu:act-latest \
  bash

# GitLab CI
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:latest \
  bash
```

### Option 2: Act for GitHub Actions

```bash
# Install act
brew install act  # or see https://github.com/nektos/act

# Run workflow locally
act -j build

# With secrets
act -j build --secret-file .env.ci

# With specific event
act push -j test
```

**Limitations of act:**
- Some GitHub-hosted runner features missing
- Service containers work differently
- Matrix builds may behave differently

### Option 3: Manual Environment Matching

```bash
# Create environment matching CI
export CI=true
export GITHUB_ACTIONS=true
export NODE_ENV=test
export HOME=/tmp/ci-home
mkdir -p $HOME

# Run with CI-like conditions
npm ci  # Not npm install
npm test
```

## Phase 4: Debugging Without Interactive Access

### Add Debug Steps

```yaml
# Before failing step
- name: Debug before deploy
  run: |
    echo "=== Current state ==="
    ls -la dist/
    cat package.json | jq '.version'
    echo "=== Environment ==="
    printenv | grep -E '^(NODE|NPM|CI)' | sort

# After failed step (use if: failure())
- name: Debug on failure
  if: failure()
  run: |
    echo "=== Process list ==="
    ps aux
    echo "=== Recent logs ==="
    tail -100 /var/log/*.log 2>/dev/null || true
```

### Capture Artifacts

```yaml
# GitHub Actions
- name: Upload debug artifacts
  if: failure()
  uses: actions/upload-artifact@v4
  with:
    name: debug-info
    path: |
      npm-debug.log
      coverage/
      test-results/
      screenshots/
    retention-days: 5

# GitLab CI
test:
  artifacts:
    when: on_failure
    paths:
      - npm-debug.log
      - test-results/
```

### SSH Debug Access (When Available)

**GitHub Actions (using tmate):**
```yaml
- name: SSH debug
  if: failure()
  uses: mxschmitt/action-tmate@v3
  with:
    limit-access-to-actor: true
```

**CircleCI (built-in):**
```
# Rerun job with SSH in CircleCI UI
# Then: ssh -p PORT IP_ADDRESS
```

### Strategic Logging

Add targeted debug output:

```javascript
// Wrap suspicious operations
console.log('=== DEBUG START: API Call ===');
console.log('Request:', JSON.stringify({url, method, headers: {...headers, Authorization: '[REDACTED]'}}));
const response = await fetch(url, options);
console.log('Response status:', response.status);
console.log('Response headers:', Object.fromEntries(response.headers));
console.log('=== DEBUG END: API Call ===');
```

## Phase 5: Environment-Specific Issues

### Path Differences

```javascript
// BAD: Hardcoded paths
const config = require('/Users/me/project/config.json');

// GOOD: Relative or environment-based
const config = require(path.join(__dirname, '../config.json'));
const config = require(process.env.CONFIG_PATH || './config.json');
```

### Missing System Dependencies

```yaml
# Check and install
- name: Ensure dependencies
  run: |
    which chromium || sudo apt-get install -y chromium-browser
    which convert || sudo apt-get install -y imagemagick
```

### Network Restrictions

**Symptoms:**
- Cannot reach external URLs
- DNS resolution fails
- TLS/certificate errors

**Investigation:**
```yaml
- name: Network debug
  run: |
    curl -v https://registry.npmjs.org/ 2>&1 | head -50
    nslookup registry.npmjs.org
    ping -c 3 8.8.8.8 || echo "ICMP blocked"
```

### Timezone Issues

```yaml
# Set consistent timezone
- run: |
    export TZ=UTC
    date
    npm test
```

## When to Fix Locally vs In CI

### Fix Locally When:
- You can reproduce the issue
- It's a code bug exposed by CI environment
- Changes need testing before push
- Multiple iterations likely needed

### Fix in CI Directly When:
- Issue is CI-config specific
- Cannot reproduce locally despite trying
- Quick workflow syntax fix
- Adding debug output to understand issue

**Workflow for CI-direct fixes:**
```bash
# Create focused branch
git checkout -b ci/debug-deploy-failure

# Make minimal change
# Push and observe
git push origin ci/debug-deploy-failure

# Iterate quickly, squash before merge
```

## Quick Reference

| Symptom | First Check | Common Fix |
|---------|-------------|------------|
| "Command not found" | PATH, tool installation | Add setup step |
| "Permission denied" | File permissions, user | chmod, run as correct user |
| "Connection refused" | Service startup, ports | Wait for service, check ports |
| Auth failure | Secrets, token expiry | Verify secret config |
| Out of memory | Memory limits, leaks | Limit memory, optimize |
| Timeout | Hanging process, slow op | Add timeouts, verbose logging |
| "File not found" | Working directory, paths | Use absolute paths, check pwd |
| Works locally fails CI | Environment diff | Match CI environment locally |

## Related Skills

- **harness:systematic-debugging** - For bugs reproducible locally
- **harness:verification-before-completion** - Verify CI fixes before claiming success
- **harness:test-driven-development** - For writing tests that work in CI

## Real-World Impact

CI debugging follows the same principle as local debugging: understand before fixing. The difference is in technique, not approach. Add instrumentation, capture evidence, and reproduce locally when possible.
