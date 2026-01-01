---
name: working-with-legacy-code
description: "SHOULD invoke when modifying code without existing tests or when strict TDD isn't feasible."
---

# Working With Legacy Code

## Overview

Legacy code is code without tests. Strict TDD assumes a blank slate. Reality often provides neither.

**Core principle:** When you can't test-first, test-around. When you can't test-around, proceed deliberately.

**This skill adapts TDD principles for messy reality, not abandons them.**

## When to Use This vs TDD

```
                            START
                              |
                              v
                   +--------------------+
                   | Is there existing  |
                   | test coverage for  |
                   | the code you're    |
                   | modifying?         |
                   +--------------------+
                         |        |
                        YES       NO
                         |        |
                         v        v
              +----------+    +-------------------+
              | Use TDD  |    | Can you quickly   |
              | skill    |    | add a failing     |
              | directly |    | test for the      |
              +----------+    | new behavior?     |
                              +-------------------+
                                    |        |
                                   YES       NO
                                    |        |
                                    v        v
                         +----------+    +-------------------+
                         | Use TDD  |    | Are there hard-   |
                         | skill    |    | to-mock external  |
                         +----------+    | dependencies?     |
                                         | (APIs, DBs, etc)  |
                                         +-------------------+
                                               |        |
                                              YES       NO
                                               |        |
                                               v        v
                                    +----------+    +-------------------+
                                    | Use THIS |    | Is understanding  |
                                    | skill    |    | current behavior  |
                                    +----------+    | critical before   |
                                                    | changes?          |
                                                    +-------------------+
                                                          |        |
                                                         YES       NO
                                                          |        |
                                                          v        v
                                               +----------+    +----------+
                                               | Use THIS |    | Use TDD  |
                                               | skill    |    | skill    |
                                               +----------+    +----------+
```

**Use THIS skill when:**
- Modifying code without existing tests
- Working with external APIs, databases, or systems
- Understanding existing behavior before changing it
- Gradual refactoring of tangled code
- Hard-to-mock dependencies make TDD impractical

**Use TDD skill when:**
- Writing new code from scratch
- Existing tests cover your change area
- Dependencies are already mockable
- Clear requirements exist

## The Spectrum of Testing

Not all legacy situations are equal:

| Situation | Strategy | Test Confidence |
|-----------|----------|-----------------|
| New feature in tested code | TDD directly | High |
| New feature in untested code | Characterization tests first | Medium-High |
| Bug fix in untested code | Characterization + regression test | Medium-High |
| Refactoring untested code | Strangler fig pattern | Medium |
| External API integration | Approval/contract testing | Medium |
| Database-heavy code | Integration tests with test DB | Medium |
| Truly untestable code | Defensive coding + monitoring | Low |

## Strategy 1: Characterization Tests

**Document what code DOES before changing what it SHOULD do.**

### When to Use
- Before modifying any untested code
- When you don't fully understand existing behavior
- When documentation is missing or wrong

### The Process

1. **Write tests that pass against current code**
   ```typescript
   // Don't know what processOrder returns for edge cases?
   // Find out by testing it:

   test('characterization: processOrder with empty items', () => {
     const result = processOrder({ items: [], customer: validCustomer });
     // Run test, see what it ACTUALLY returns
     // Then update assertion to match reality:
     expect(result).toEqual({ error: 'NO_ITEMS', code: 422 });
   });
   ```

2. **Let the code tell you what it does**
   - Write assertion you THINK is correct
   - Run test, see actual output
   - Update assertion to match reality
   - This documents actual behavior

3. **Cover the paths you'll modify**
   - Focus on code paths your change will touch
   - Include edge cases you discover
   - Don't aim for 100% coverage, aim for change coverage

4. **Now make your change**
   - Characterization tests protect against regression
   - New behavior gets TDD treatment
   - You can safely refactor

### Example: Bug Fix with Characterization

```typescript
// Bug: calculateDiscount returns wrong value for VIP customers

// Step 1: Characterize current behavior
test('characterization: regular customer 10% discount', () => {
  const result = calculateDiscount({ type: 'regular', total: 100 });
  expect(result).toBe(10); // Verified this is current behavior
});

test('characterization: VIP customer discount', () => {
  const result = calculateDiscount({ type: 'vip', total: 100 });
  expect(result).toBe(10); // BUG: Should be 20, but currently returns 10
});

// Step 2: Write the failing test for correct behavior
test('VIP customers should get 20% discount', () => {
  const result = calculateDiscount({ type: 'vip', total: 100 });
  expect(result).toBe(20); // This fails - good!
});

// Step 3: Fix the bug, both tests should inform behavior
// Characterization test for regular customer ensures we don't break it
// New test ensures VIP behavior is correct
```

## Strategy 2: Strangler Fig Pattern

**Gradually replace legacy code by wrapping and redirecting.**

### When to Use
- Large, tangled codebases
- Can't stop shipping to rewrite
- Need to migrate incrementally

### The Process

```
     [Old System]
           |
           v
    +-------------+
    | Strangler   |  <-- New code wraps old
    | Facade      |
    +-------------+
     /          \
    v            v
[New Code]   [Old Code]
  (tested)    (legacy)

Over time:
    +-------------+
    | Strangler   |
    | Facade      |
    +-------------+
     /    |    \
    v     v     v
[New]  [New]  [Old]
         |
         v
       [New]
```

1. **Create a facade that delegates to old code**
   ```typescript
   // Old code: directly called everywhere
   const result = legacyPaymentProcessor.charge(amount);

   // New facade: same interface, delegates for now
   class PaymentFacade {
     charge(amount: number) {
       return legacyPaymentProcessor.charge(amount);
     }
   }
   ```

2. **Update callers to use facade (with tests)**
   ```typescript
   // Update callers one at a time
   // Each update gets a test
   const facade = new PaymentFacade();
   const result = facade.charge(amount);
   ```

3. **Implement new behavior behind facade (with TDD)**
   ```typescript
   class PaymentFacade {
     charge(amount: number) {
       if (this.useNewImplementation()) {
         return this.newCharge(amount); // TDD this
       }
       return legacyPaymentProcessor.charge(amount);
     }
   }
   ```

4. **Gradually route traffic to new implementation**
   - Feature flags control routing
   - Monitor both paths
   - Migrate incrementally

5. **Remove old code when facade fully routes to new**

## Strategy 3: Finding Seams

**Seams are places where you can alter behavior without editing code.**

### Types of Seams

| Seam Type | How to Use | Example |
|-----------|------------|---------|
| **Object Seam** | Replace object with test double | Dependency injection |
| **Preprocessing Seam** | Swap at build time | Conditional compilation |
| **Link Seam** | Swap at link time | Different implementations for test/prod |

### Identifying Seams

```typescript
// BEFORE: No seam - hard to test
class OrderService {
  processOrder(order: Order) {
    const db = new DatabaseConnection(); // Created internally
    const api = new PaymentAPI();        // Created internally
    // ... uses db and api directly
  }
}

// AFTER: Object seams via constructor injection
class OrderService {
  constructor(
    private db: DatabaseConnection,  // Injected - testable seam
    private api: PaymentAPI          // Injected - testable seam
  ) {}

  processOrder(order: Order) {
    // ... uses this.db and this.api
  }
}

// Test with seams
test('processOrder saves to database', () => {
  const mockDb = { save: jest.fn() };
  const mockApi = { charge: jest.fn().mockResolvedValue({ success: true }) };

  const service = new OrderService(mockDb, mockApi);
  service.processOrder(testOrder);

  expect(mockDb.save).toHaveBeenCalledWith(testOrder);
});
```

### Creating Seams Without Major Refactoring

```typescript
// Original: Internal creation
class Reporter {
  generateReport() {
    const now = new Date(); // Hard to test time-dependent behavior
    // ...
  }
}

// Add seam with default
class Reporter {
  constructor(private clock: () => Date = () => new Date()) {}

  generateReport() {
    const now = this.clock(); // Seam!
    // ...
  }
}

// Test can now control time
const fixedTime = new Date('2024-01-15');
const reporter = new Reporter(() => fixedTime);
```

## Strategy 4: Approval Testing / Golden Master

**When output is complex, compare against known-good snapshots.**

### When to Use
- Complex output (HTML, JSON, reports)
- Output correctness is "I know it when I see it"
- Refactoring code that produces complex results

### The Process

1. **Capture current output as golden master**
   ```typescript
   test('report generation - approval test', () => {
     const result = generateReport(testData);
     expect(result).toMatchSnapshot(); // Jest snapshot
   });
   ```

2. **Review snapshot manually** - Is this correct?
3. **Changes to output require explicit approval**
4. **Refactor safely** - Any change shows in diff

### Approval Testing for External APIs

```typescript
// Record real API responses
test('payment API contract', () => {
  // First run: record actual response
  // Subsequent runs: compare against recorded
  const response = await paymentAPI.charge(testAmount);

  expect(response).toMatchInlineSnapshot(`
    {
      "status": "success",
      "transactionId": expect.any(String),
      "amount": 100,
      "currency": "USD"
    }
  `);
});
```

## Strategy 5: Working with External Dependencies

**When you can't mock it, isolate it.**

### Pattern: Humble Object

```typescript
// BEFORE: Business logic mixed with external calls
class OrderProcessor {
  async process(order: Order) {
    const inventory = await fetch('/api/inventory');

    // Business logic buried in external call handler
    if (inventory.available < order.quantity) {
      await fetch('/api/notify', { body: 'Out of stock' });
      return { error: 'INSUFFICIENT_INVENTORY' };
    }

    await fetch('/api/payment', { body: order.payment });
    return { success: true };
  }
}

// AFTER: Humble object pattern
// External calls in thin wrapper (humble, hard to test, minimal logic)
class ExternalServices {
  async getInventory() { return fetch('/api/inventory'); }
  async notify(msg: string) { return fetch('/api/notify', { body: msg }); }
  async processPayment(payment: Payment) {
    return fetch('/api/payment', { body: payment });
  }
}

// Business logic extracted and testable
class OrderProcessor {
  constructor(private services: ExternalServices) {}

  async process(order: Order, inventory: Inventory) {
    // Pure business logic - easy to test!
    if (inventory.available < order.quantity) {
      return { action: 'notify', error: 'INSUFFICIENT_INVENTORY' };
    }
    return { action: 'charge', payment: order.payment };
  }
}

// Test business logic without external calls
test('insufficient inventory returns notify action', () => {
  const processor = new OrderProcessor(mockServices);
  const result = processor.process(order, { available: 0 });
  expect(result).toEqual({ action: 'notify', error: 'INSUFFICIENT_INVENTORY' });
});
```

### Integration Test with Real Dependencies

When you MUST test against real systems:

```typescript
describe('Payment Integration', () => {
  // Use test/sandbox environments
  const api = new PaymentAPI({ environment: 'sandbox' });

  test('successful charge', async () => {
    const result = await api.charge({
      amount: 100,
      card: TEST_CARD_SUCCESS
    });
    expect(result.status).toBe('success');
  });

  test('declined card', async () => {
    const result = await api.charge({
      amount: 100,
      card: TEST_CARD_DECLINE
    });
    expect(result.status).toBe('declined');
  });
});
```

### Contract Tests

Verify your understanding matches the external system:

```typescript
// Contract test: Does our mock match reality?
describe('PaymentAPI Contract', () => {
  test('response shape matches our interface', async () => {
    const realResponse = await realAPI.charge(testData);
    const mockResponse = await mockAPI.charge(testData);

    // Same shape, maybe different values
    expect(Object.keys(realResponse)).toEqual(Object.keys(mockResponse));
  });
});
```

## Strategy 6: When NOT to Test

**Sometimes testing isn't the right investment.**

### Legitimate Skip Scenarios

| Scenario | Why Skip | What to Do Instead |
|----------|----------|-------------------|
| Throwaway prototype | Will be deleted | Mark as PROTOTYPE, delete after validation |
| One-time migration script | Never runs again | Manual verification, logging |
| Trivial delegation | No logic to test | Trust the delegate's tests |
| Generated code | Tests would test generator | Test generator instead |

### When Skipping, Mitigate Risk

1. **Defensive coding**
   ```typescript
   // Can't test? Validate aggressively
   function riskyOperation(data: unknown) {
     if (!isValidData(data)) {
       throw new Error(`Invalid data: ${JSON.stringify(data)}`);
     }
     // ... proceed
   }
   ```

2. **Logging for post-hoc debugging**
   ```typescript
   logger.info('Processing order', { orderId, state: 'start' });
   try {
     const result = processOrder(order);
     logger.info('Order processed', { orderId, result });
     return result;
   } catch (error) {
     logger.error('Order failed', { orderId, error });
     throw error;
   }
   ```

3. **Monitoring and alerting**
   - Set up metrics for critical paths
   - Alert on anomalies
   - Review logs regularly

## Verification Checklist

Before completing legacy code modifications:

- [ ] Understood existing behavior (characterization tests or code reading)
- [ ] Identified what could break (dependencies, callers)
- [ ] Protected against regression (characterization tests or careful review)
- [ ] New behavior has tests (TDD for new code)
- [ ] External dependencies are isolated (seams, humble objects)
- [ ] Documented any skipped tests (with reasoning)
- [ ] Added monitoring if tests were skipped

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Bad | Instead |
|--------------|--------------|---------|
| "Too legacy to test" | Self-fulfilling excuse | Find one seam, start there |
| Mocking everything | Tests are meaningless | Use real objects when possible |
| Testing implementation | Breaks on refactor | Test behavior through public API |
| Massive test setup | Tests are fragile | Extract test fixtures |
| Skipping without mitigation | Flying blind | Add logging, monitoring, validation |

## Relationship to TDD Skill

This skill **adapts** TDD, it doesn't replace it:

| TDD Principle | Legacy Adaptation |
|---------------|-------------------|
| Test first | Characterize first, then test-first for new code |
| Watch test fail | Same - always verify test fails correctly |
| Minimal code | Same - minimal changes per test |
| Refactor | Strangler fig for large changes |
| No mocks unless unavoidable | Humble objects isolate what must be mocked |

**The goal is always to get back to TDD:**
- Characterization tests enable safe refactoring
- Refactoring creates seams
- Seams enable testing
- Testing enables TDD

## Quick Reference

| Situation | Primary Strategy |
|-----------|------------------|
| Don't understand code | Characterization tests |
| Large tangled codebase | Strangler fig |
| Hard-to-test dependencies | Find/create seams |
| Complex output | Approval testing |
| External APIs | Humble object + contract tests |
| Can't test at all | Defensive coding + monitoring |

## Related Skills

- **harness:test-driven-development** - Use when tests are feasible
- **harness:systematic-debugging** - Use for investigating legacy bugs
- **harness:verification-before-completion** - Always verify changes work
