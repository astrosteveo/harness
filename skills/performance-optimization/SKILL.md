---
name: performance-optimization
description: Use when code is too slow, memory usage is too high, or investigating performance bottlenecks - requires profiling before optimizing
---

# Performance Optimization

## Overview

Guessing at performance problems wastes time and often makes code worse. "I think this is slow" is not evidence.

**Core principle:** ALWAYS measure before optimizing. Profile first, optimize second.

**Violating the letter of this process is violating the spirit of optimization.**

## The Iron Law

```
NO OPTIMIZATION WITHOUT PROFILING FIRST
```

If you haven't measured performance, you cannot propose optimizations.

## When to Use

Use for ANY performance concern:
- Slow response times
- High memory usage
- High CPU utilization
- Slow database queries
- Network latency issues
- Build time problems
- Test suite slowness

**Use this ESPECIALLY when:**
- Someone says "this feels slow"
- You're tempted to "just optimize this loop"
- Code review suggests "this could be faster"
- Scaling problems emerge under load

**Don't skip when:**
- Issue seems obvious (obvious guesses are often wrong)
- You're certain of the bottleneck (measure anyway)
- "Everyone knows X is slow" (verify with data)

## When NOT to Optimize

**Stop and question the need if:**
- No user has complained about performance
- System meets all SLAs and requirements
- Profiling shows no clear bottleneck
- Optimization requires significant complexity
- Code is rarely executed (< 1% of runtime)

**Premature optimization indicators:**
- "This might be slow someday"
- "Let's optimize just in case"
- "Best practice says to cache this"
- Optimizing during initial development
- No performance requirements exist

**Remember:** Working, readable code is better than fast, complex code that isn't needed.

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Establish Baseline

**BEFORE attempting ANY optimization:**

1. **Define the Problem Clearly**
   - What specific operation is slow?
   - How slow is it now? (exact numbers)
   - How fast does it need to be? (target)
   - Who is affected and how?

2. **Measure Current Performance**
   - Use appropriate profiling tools for your language/platform
   - Measure under realistic conditions
   - Record multiple runs (account for variance)
   - Document: time, memory, CPU, I/O metrics

3. **Create Reproducible Benchmark**
   - Automate the measurement
   - Use realistic data volumes
   - Control for external factors
   - Version control the benchmark

4. **Record Baseline Metrics**
   ```
   Operation: [specific operation]
   Current: [measured value with units]
   Target: [required performance]
   Gap: [how much improvement needed]
   Environment: [hardware, load, data size]
   Date: [when measured]
   ```

### Phase 2: Identify Bottlenecks

**Use profiling to find the actual problem:**

1. **Profile, Don't Guess**

   | Language/Platform | Profiling Tools |
   |-------------------|-----------------|
   | Python | cProfile, py-spy, memory_profiler |
   | JavaScript/Node | Chrome DevTools, clinic.js, --inspect |
   | Java/JVM | JProfiler, VisualVM, async-profiler |
   | Go | pprof, trace |
   | Rust | perf, flamegraph |
   | Database | EXPLAIN ANALYZE, query logs |
   | General | perf, dtrace, strace |

2. **Identify Bottleneck Type**

   | Type | Symptoms | Investigation |
   |------|----------|---------------|
   | **CPU** | High CPU usage, slow computation | Profile hot functions, check algorithms |
   | **Memory** | High RAM, frequent GC, swapping | Heap analysis, allocation profiling |
   | **I/O** | Waiting on disk, slow file ops | I/O tracing, async opportunities |
   | **Network** | Latency, timeouts, slow API calls | Network traces, connection pooling |
   | **Database** | Slow queries, lock contention | Query plans, index analysis |
   | **Concurrency** | Thread contention, deadlocks | Lock profiling, thread dumps |

3. **Find the Hotspots**
   - What takes the most time?
   - What's called most frequently?
   - Where is memory allocated?
   - What's blocking on I/O?

4. **Quantify Impact**
   - What percentage of time is this hotspot?
   - If fixed, what's the maximum speedup? (Amdahl's Law)
   - Is it worth optimizing?

### Phase 3: Optimize Strategically

**Address bottlenecks in order of impact:**

1. **Pick Highest-Impact Bottleneck**
   - Focus on the biggest contributor first
   - One optimization at a time
   - Don't optimize < 5% contributors

2. **Apply Appropriate Pattern**

   **CPU Bottlenecks:**
   - Better algorithm (O(n^2) -> O(n log n))
   - Reduce work done (exit early, skip unnecessary)
   - Cache computed results (memoization)
   - Parallelize independent work
   - Move to compiled language for hot paths

   **Memory Bottlenecks:**
   - Use appropriate data structures
   - Stream instead of load all at once
   - Pool and reuse objects
   - Reduce object size/overhead
   - Clear references to allow GC

   **I/O Bottlenecks:**
   - Batch operations together
   - Use async/non-blocking I/O
   - Buffer appropriately
   - Compress data
   - Use local caching

   **Network Bottlenecks:**
   - Reduce round trips (batch requests)
   - Use connection pooling
   - Compress payloads
   - Cache responses
   - Use CDN for static content

   **Database Bottlenecks:**
   - Add appropriate indexes
   - Optimize query structure
   - Reduce data fetched
   - Use connection pooling
   - Consider read replicas
   - Cache query results

3. **Implement Single Change**
   - Make ONE optimization
   - Keep it simple and readable
   - Document what you changed and why
   - Don't bundle multiple optimizations

### Phase 4: Verify and Document

**Prove the optimization worked:**

1. **Measure After Optimization**
   - Run the same benchmark as baseline
   - Same conditions, same data
   - Multiple runs for variance

2. **Compare Results**
   ```
   Operation: [specific operation]
   Before: [baseline measurement]
   After: [new measurement]
   Improvement: [percentage or absolute]
   Target: [required performance]
   Status: [met target? / need more?]
   ```

3. **Check for Regressions**
   - Run full test suite
   - Check other performance metrics
   - Verify no functionality broken
   - Check memory if optimizing for speed

4. **Document Trade-offs**
   - What did this optimization cost?
   - Complexity added?
   - Memory for speed trade-off?
   - Readability impact?
   - Maintenance burden?

5. **If Target Not Met**
   - Return to Phase 2
   - Profile again with current state
   - Find next biggest bottleneck
   - Repeat the cycle

## Trade-offs to Consider

Every optimization has costs. Be explicit about trade-offs:

| Trade-off | Consider |
|-----------|----------|
| **Speed vs Memory** | Caching uses RAM; is it worth it? |
| **Speed vs Readability** | Complex code is harder to maintain |
| **Speed vs Correctness** | Optimizations can introduce bugs |
| **Speed vs Flexibility** | Optimized code is often more rigid |
| **Development Time vs Runtime** | Is the engineering time worth it? |
| **Local vs Global** | Optimizing one path may slow others |

**Ask before optimizing:**
- Is this complexity worth the performance gain?
- Can future developers understand this?
- Does this optimization have an expiration date?
- What happens when requirements change?

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "This looks slow, let me optimize it"
- "I'll just add a cache here"
- "Loops are slow, use list comprehension"
- "I know where the bottleneck is"
- "Quick optimization, no need to measure"
- "Everyone knows this pattern is faster"
- "Let's optimize while we're in here"
- "This COULD become a bottleneck"
- "Best practice says to do X"

**ALL of these mean: STOP. Return to Phase 1. Measure first.**

## Common Optimization Myths

| Myth | Reality |
|------|---------|
| "This algorithm is faster" | Depends on data size and access patterns. Measure. |
| "Native code is always faster" | Interpretation overhead often negligible. Measure. |
| "Caching always helps" | Cache invalidation bugs, memory pressure. Measure. |
| "Async makes things faster" | Overhead can hurt small operations. Measure. |
| "Microservices scale better" | Network overhead, complexity. Measure for your case. |
| "More threads = more speed" | Context switching, lock contention. Measure. |
| "The database is the bottleneck" | Often it's the queries or N+1 problems. Measure. |

## Language-Agnostic Principles

These apply regardless of language or platform:

1. **Measure, don't guess** - Human intuition about performance is unreliable
2. **Optimize the algorithm first** - Big-O improvements beat micro-optimizations
3. **Do less work** - The fastest code is code that doesn't run
4. **Avoid allocation in hot paths** - Memory allocation is expensive everywhere
5. **Batch operations** - Amortize fixed costs over multiple items
6. **Fail fast** - Exit early when result is known
7. **Locality matters** - Keep related data together in memory
8. **I/O dominates** - Network and disk are orders of magnitude slower than RAM
9. **Cache carefully** - Only cache what's expensive to compute AND frequently needed
10. **Keep it simple** - Complex optimizations create maintenance debt

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Baseline** | Define problem, measure, create benchmark | Have numbers, not guesses |
| **2. Identify** | Profile, find hotspots, quantify impact | Know WHERE the problem is |
| **3. Optimize** | Single change, appropriate pattern | Targeted improvement made |
| **4. Verify** | Re-measure, compare, document | Prove it worked, note trade-offs |

## Related Skills

- **harness:systematic-debugging** - Use when performance issues stem from bugs
- **harness:verification-before-completion** - Verify optimizations actually work
- **harness:test-driven-development** - Ensure optimizations don't break functionality

## Real-World Impact

From optimization sessions:
- Measured approach: Fix actual bottleneck in 1-2 hours
- Guessing approach: Optimize wrong things for days
- Measured optimizations: 10-100x improvements common
- Guessed optimizations: Often < 5% or even slower
- Premature optimization: Technical debt with no benefit
