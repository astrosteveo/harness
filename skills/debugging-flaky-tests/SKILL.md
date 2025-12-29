---
name: debugging-flaky-tests
description: Use when tests pass/fail inconsistently, timing-dependent failures, or tests that fail only in CI or under load
---

# Debugging Flaky Tests

## Overview

Flaky tests erode trust in the test suite. Random pass/fail undermines confidence and leads to ignored failures.

**Core principle:** A flaky test is a symptom. Find the root cause before deciding whether to fix, quarantine, or delete.

**Violating the letter of this process is violating the spirit of debugging flaky tests.**

**Parent Skill:** This skill extends `harness:systematic-debugging`. Complete the systematic debugging phases first, then apply flaky-specific patterns below.

## The Iron Law

```
NO QUARANTINE OR DELETION WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

Quarantining without understanding is hiding problems. Deleting without understanding is losing coverage.

## When to Use

**Use this skill when:**
- Test passes locally, fails in CI
- Test fails intermittently with same code
- Test fails under load but passes in isolation
- Test fails only when run with other tests
- Test passes on retry
- Test fails with timing-related errors
- Test behavior changes based on execution order

**Don't use this skill when:**
- Test consistently fails (use systematic-debugging)
- Test was never passing (that's a broken test, not flaky)
- Failure is clearly caused by recent code change

## Phase 0: Flaky or Environmental?

**Before assuming flakiness, distinguish:**

| Pattern | Diagnosis | Action |
|---------|-----------|--------|
| Fails every CI run, passes locally | Environmental difference | Check CI environment, not flakiness |
| Fails on some CI runs, passes on others | Likely flaky | Continue with this skill |
| Fails only with specific test order | Shared state issue | Check test isolation |
| Fails after machine sits idle | Resource cleanup issue | Check teardown, connections |
| Fails only under heavy load | Resource contention | Check for race conditions |

**Environmental Checklist:**
- [ ] Same Node/Python/runtime version?
- [ ] Same dependency versions (lock file)?
- [ ] Same environment variables?
- [ ] Same database state/seed?
- [ ] Same filesystem permissions?
- [ ] Same network access?
- [ ] Same time zone/locale?

If environmental, fix environment. Don't chase phantom flakiness.

## Phase 1: Reproduce the Flakiness

**MANDATORY. You cannot fix what you cannot trigger.**

### Local Reproduction Techniques

**1. Repeat Runs**
```bash
# Run test N times
for i in {1..100}; do npm test -- --testNamePattern="flaky test" || break; done

# With parallelism stress
npm test -- --maxWorkers=8 --runInBand=false

# With test ordering randomization
npm test -- --randomize
```

**2. Seed Control**
```bash
# If test framework supports seeds
npm test -- --seed=12345

# Record seed from failing CI run, replay locally
npm test -- --seed=$FAILING_SEED
```

**3. Timing Stress**
```bash
# Slow down system to expose races
cpulimit -l 20 -- npm test

# Add artificial latency
tc qdisc add dev lo root netem delay 100ms
```

**4. Resource Exhaustion**
```bash
# Limit memory
NODE_OPTIONS="--max-old-space-size=256" npm test

# Limit file descriptors
ulimit -n 64 && npm test

# Run with many parallel processes
stress --cpu 4 & npm test
```

### CI Reproduction

**When local reproduction fails:**
1. Check CI logs for exact failure message
2. Note: CPU count, memory, parallel jobs running
3. Note: Order of test execution
4. Check for shared CI resources (databases, caches)
5. Run in CI-equivalent Docker container locally

## Phase 2: Root Cause Categories

**Use systematic-debugging Phase 1-2, then classify into these flaky-specific categories:**

### Race Conditions

**Symptoms:**
- Inconsistent assertion failures
- "Element not found" intermittently
- Data appears/disappears between operations

**Investigation:**
```javascript
// Add timing instrumentation
console.log(`[${Date.now()}] Before operation`);
await operation();
console.log(`[${Date.now()}] After operation`);
```

**Common Causes:**
- Async operations without proper awaiting
- Event handlers firing in unpredictable order
- Concurrent database writes
- Shared mutable state between tests

### Shared State

**Symptoms:**
- Test passes in isolation, fails with others
- Order-dependent failures
- State "leaking" between tests

**Investigation:**
```bash
# Run single test - passes
npm test -- --testNamePattern="suspected test"

# Run with likely polluters
npm test -- --testNamePattern="polluter|suspected"

# Bisect to find polluter
npm test -- path/to/suspected.test.ts --runInBand
```

**Common Causes:**
- Global variables modified by tests
- Singleton state not reset
- Database not cleaned between tests
- Mocked modules not restored
- Environment variables modified

### Timing Dependencies

**Symptoms:**
- Timeout failures
- "Expected X but got Y" where Y is partial result
- Works locally (fast), fails in CI (slow)

**Investigation:**
```javascript
// Replace sleeps with conditions
// BAD
await sleep(1000);
expect(element).toBeVisible();

// GOOD - reveals timing assumption
await waitFor(() => expect(element).toBeVisible(), { timeout: 5000 });
```

**Common Causes:**
- Hardcoded sleep durations
- Assuming operation completes "instantly"
- Animation/transition timing
- Network request timing assumptions

### External Service Dependencies

**Symptoms:**
- Sporadic network errors
- Rate limiting failures
- "Service unavailable" errors
- Different results from same API call

**Investigation:**
- Check if test hits real external services
- Look for missing mocks
- Check for rate limits or quotas

**Common Causes:**
- Tests hitting real APIs instead of mocks
- Mocks not covering all code paths
- External service instability
- Rate limiting

### Resource Exhaustion

**Symptoms:**
- "Too many open files"
- Memory allocation failures
- Connection pool exhausted
- Process spawn failures

**Investigation:**
```bash
# Monitor resources during test
watch -n 0.5 'lsof -p $PID | wc -l'
watch -n 0.5 'ps -o rss= -p $PID'
```

**Common Causes:**
- File handles not closed
- Database connections not released
- Memory leaks accumulating across tests
- Child processes not terminated

## Phase 3: Quarantine Strategy

**Quarantine is temporary isolation, NOT a fix.**

### When to Quarantine

Quarantine ONLY when:
1. Root cause is identified but fix is non-trivial
2. Flakiness blocks other development
3. You have a plan and timeline for fixing

**Never quarantine because:**
- "We'll look at it later" (you won't)
- "It's probably fine" (it's not)
- "Too hard to debug" (use this skill)

### Quarantine Implementation

**1. Mark the test**
```javascript
// Jest
describe.skip('Flaky: race condition in async handler - JIRA-123', () => {

// Or with custom marker
test.flaky('operation completes', async () => {
```

**2. Document in test file**
```javascript
/**
 * QUARANTINED: 2024-01-15
 * REASON: Race condition between WebSocket and HTTP responses
 * ROOT CAUSE: Handler assumes HTTP completes before WS message
 * TICKET: JIRA-123
 * OWNER: @username
 * DEADLINE: 2024-01-22
 */
```

**3. Track in backlog**
Use `harness:backlog-tracking` to create a tracking item:
```
BUG-XXX: Fix quarantined flaky test in payment_flow.test.ts
- Root cause: Race condition in async handler
- Deadline: 2024-01-22
- References: JIRA-123
```

**4. Set expiration**
Quarantine has a deadline. No indefinite quarantine.

### Quarantine Review

Weekly review of quarantined tests:
- Is fix in progress?
- Has deadline passed?
- Can test be deleted instead?

Quarantine older than 30 days without progress → escalate or delete.

## Phase 4: Fix Patterns

### Race Condition Fixes

**Pattern: Proper Async/Await**
```javascript
// BAD
function fetchData() {
  fetch('/api').then(r => this.data = r);
}

// GOOD
async function fetchData() {
  this.data = await fetch('/api');
}
```

**Pattern: Event Synchronization**
```javascript
// BAD - race between event and assertion
emitter.emit('done');
expect(handler.called).toBe(true);

// GOOD - wait for event processing
await new Promise(resolve => emitter.once('done', resolve));
expect(handler.called).toBe(true);
```

### Shared State Fixes

**Pattern: Test Isolation**
```javascript
// beforeEach/afterEach for guaranteed cleanup
let db;
beforeEach(async () => {
  db = await createTestDatabase();
});
afterEach(async () => {
  await db.destroy();
});
```

**Pattern: Factory Functions Over Singletons**
```javascript
// BAD - singleton shared across tests
import { cache } from './cache';

// GOOD - fresh instance per test
import { createCache } from './cache';
let cache;
beforeEach(() => { cache = createCache(); });
```

### Timing Fixes

**Pattern: Condition-Based Waiting**
```javascript
// BAD - arbitrary sleep
await sleep(2000);
expect(element).toBeVisible();

// GOOD - wait for condition
await waitFor(() => element.isVisible(), { timeout: 5000 });
expect(element).toBeVisible();
```

**Pattern: Retry with Backoff**
```javascript
// For inherently async operations
async function waitForCondition(fn, { timeout = 5000, interval = 100 }) {
  const start = Date.now();
  while (Date.now() - start < timeout) {
    if (await fn()) return true;
    await sleep(interval);
  }
  throw new Error('Timeout waiting for condition');
}
```

### External Service Fixes

**Pattern: Deterministic Mocking**
```javascript
// Mock ALL external calls
jest.mock('./api', () => ({
  fetchUser: jest.fn().mockResolvedValue({ id: 1, name: 'Test' })
}));

// Verify mock was called, not just that test passed
expect(api.fetchUser).toHaveBeenCalledWith(expectedArgs);
```

**Pattern: Test Doubles for Time**
```javascript
// Control time instead of waiting
jest.useFakeTimers();
triggerTimeout();
jest.advanceTimersByTime(5000);
expect(callback).toHaveBeenCalled();
```

### Resource Exhaustion Fixes

**Pattern: Explicit Cleanup**
```javascript
afterEach(async () => {
  await connection.close();
  await fileHandle.close();
  childProcess.kill();
});
```

**Pattern: Resource Pooling**
```javascript
// Limit concurrent resources
const pool = createPool({ max: 10 });
const connection = await pool.acquire();
try {
  // use connection
} finally {
  pool.release(connection);
}
```

## Phase 5: CI-Specific Flakiness

### Parallel Test Interference

**Symptoms:**
- Tests pass with `--runInBand`, fail in parallel
- Port conflicts
- File conflicts

**Fixes:**
```javascript
// Use unique ports per test worker
const port = 3000 + parseInt(process.env.JEST_WORKER_ID || '0');

// Use unique temp directories
const tmpDir = `${os.tmpdir()}/test-${process.env.JEST_WORKER_ID}`;
```

### Resource Contention

**Symptoms:**
- Timeouts only in CI
- Slow operations that work locally

**Fixes:**
- Increase timeouts for CI (but investigate why CI is slower)
- Reduce parallelism: `--maxWorkers=2`
- Use dedicated test database per worker

### CI Environment Differences

**Common Differences:**
| Local | CI | Impact |
|-------|-----|--------|
| SSD | Network storage | Slower I/O |
| 8+ cores | 2 cores | Less parallelism |
| 16GB RAM | 4GB RAM | Memory pressure |
| Persistent | Ephemeral | Missing cached data |

**Mitigation:**
- Match CI resources locally for debugging
- Document resource requirements
- Use CI-specific timeout multipliers

## Phase 6: Delete vs Fix Decision

### Delete When

- Test provides little value (low-risk code, redundant coverage)
- Cost to fix exceeds value of coverage
- Test design is fundamentally flawed
- Feature being tested is deprecated

### Fix When

- Test covers critical functionality
- Fix is straightforward once root cause known
- Test caught real bugs in the past
- Losing coverage creates risk

### Decision Framework

```
Is the code under test critical?
  YES → Fix the test
  NO → Is there other coverage for this behavior?
    YES → Consider deletion
    NO → Is fix cost < 4 hours?
      YES → Fix the test
      NO → Document risk, delete, add to backlog for future coverage
```

**When deleting:**
1. Document why in commit message
2. Add backlog item if coverage gap matters
3. Consider if simpler test could provide coverage

## Prevention Patterns

### Design for Testability

- Dependency injection over globals
- Pure functions over stateful operations
- Explicit async boundaries
- Configurable timeouts and retries

### Test Hygiene

- Each test creates and destroys its own state
- No test depends on another test's side effects
- No shared mutable fixtures
- Deterministic test data (factories, not random)

### CI Configuration

- Consistent environment via containers
- Isolated test databases per worker
- Adequate resource allocation
- Flaky test detection and reporting

## Quick Reference

| Symptom | Likely Cause | First Investigation Step |
|---------|--------------|-------------------------|
| Passes locally, fails CI | Environmental | Compare environments |
| Fails intermittently | Race condition | Add timing logs |
| Order-dependent | Shared state | Run single test |
| Timeout failures | Timing assumption | Replace sleeps with waits |
| Works with mocks off | External service | Verify mock coverage |
| Memory errors | Resource leak | Monitor cleanup |

## Related Skills

- **PARENT SKILL:** `harness:systematic-debugging` - Complete this first
- **REQUIRED:** `harness:test-driven-development` - For writing proper fix tests
- **REQUIRED:** `harness:verification-before-completion` - Verify fix eliminates flakiness
- **RECOMMENDED:** `harness:backlog-tracking` - Track quarantined tests

## Final Rule

```
Flaky test → Root cause investigation → Informed decision (fix/quarantine/delete)
Skipping root cause investigation → Guaranteed to recur
```

No quarantine or deletion without understanding why.
