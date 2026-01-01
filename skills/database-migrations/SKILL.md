---
name: database-migrations
description: "MUST invoke when modifying database schema, migrating data, or planning structural changes."
---

# Database Migrations

## Overview

Database migrations are irreversible in production. Data loss cannot be undone with a git revert.

**Core principle:** Every migration must be reversible until proven safe in production.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO MIGRATION RUNS WITHOUT PRE-FLIGHT CHECKLIST COMPLETION
```

If you haven't verified backup, rollback, and impact, you cannot run the migration.

## Pre-Flight Checklist

```
BEFORE running ANY migration:

[ ] BACKUP: Fresh backup exists and is verified restorable
[ ] ROLLBACK: Down migration tested and confirmed working
[ ] IMPACT: Affected tables/rows counted, estimate reviewed
[ ] DOWNTIME: Zero-downtime strategy confirmed OR maintenance window scheduled
[ ] DEPENDENCIES: Application code compatible with both before/after states
[ ] STAGING: Migration tested on staging with production-like data
[ ] MONITORING: Alerts configured for migration failures

Skip any checkbox = potential data loss
```

## Migration Categories

### Schema Migration vs Data Migration

| Type | Purpose | Risk Level | Rollback |
|------|---------|------------|----------|
| Schema | Change structure (columns, indexes, constraints) | Medium | Down migration |
| Data | Transform existing data | HIGH | Backup restore only |
| Combined | Both in one migration | CRITICAL | Often impossible |

**Rule:** Never combine schema and data migrations. Separate them always.

## Safe Migration Patterns

### Additive Changes (Low Risk)

```
SAFE operations - generally reversible:
- ADD nullable column
- ADD index (with CONCURRENTLY where supported)
- ADD table
- ADD constraint (as NOT VALID first, then VALIDATE)

Pattern:
1. Add new structure
2. Deploy code that uses new structure
3. Verify stability
4. Clean up old structure (separate migration)
```

### Expand/Contract Pattern (Zero-Downtime)

```
Phase 1: EXPAND
- Add new column/table alongside old
- Deploy code that writes to BOTH
- Backfill new structure

Phase 2: MIGRATE
- Deploy code that reads from NEW
- Verify data consistency
- Monitor for issues

Phase 3: CONTRACT
- Remove old column/table
- Deploy code that only uses new

Each phase = separate deployment cycle
```

### Feature Flag Integration

```
Migration + Feature Flag workflow:

1. Create migration with flag check
2. Deploy with flag OFF
3. Enable flag in staging, verify
4. Enable flag in production subset
5. Monitor, expand, complete rollout
6. Remove flag (separate PR)
```

## Dangerous Operations

### Column Drops (CRITICAL)

```
NEVER drop columns directly.

Safe pattern:
1. Remove all code references to column
2. Deploy and verify no usage
3. Add column to ignore list (if ORM supports)
4. Wait one full deployment cycle
5. THEN drop column in separate migration
6. Keep backup for 30+ days
```

### Type Changes (HIGH RISK)

```
NEVER ALTER COLUMN TYPE directly on large tables.

Safe pattern:
1. Add new column with new type
2. Backfill data (batched, off-peak)
3. Deploy code to write to both columns
4. Switch reads to new column
5. Stop writes to old column
6. Drop old column (separate migration)
```

### Data Loss Risks

| Operation | Risk | Mitigation |
|-----------|------|------------|
| DROP COLUMN | Permanent loss | Backup, staged rollout |
| DROP TABLE | Permanent loss | Backup, 30-day retention |
| TRUNCATE | Permanent loss | Never in migration |
| UPDATE without WHERE | Mass corruption | Always verify WHERE clause |
| DELETE without WHERE | Mass deletion | Transaction + verification |
| ALTER TYPE (shrinking) | Data truncation | Test with production data copy |

## Testing Migrations

### Local Testing

```
Local verification checklist:

[ ] Migration runs forward successfully
[ ] Migration runs backward successfully
[ ] Forward -> Backward -> Forward produces same state
[ ] No data loss in round-trip
[ ] Performance acceptable on sample data
```

### Staging Verification

```
Staging requirements:

[ ] Production-like data volume (anonymized)
[ ] Same database version as production
[ ] Same indexes and constraints
[ ] Run migration, verify timing
[ ] Run rollback, verify timing
[ ] Check for locks/blocking queries
```

### Production Dry-Run

```
Before production, verify:

[ ] EXPLAIN ANALYZE on all migration queries
[ ] Lock acquisition time estimated
[ ] Table size and row count documented
[ ] Expected duration calculated
[ ] Alerting thresholds set
```

## Rollback Procedures

### Down Migration Requirements

```
Every up migration MUST have:

1. Corresponding down migration
2. Down migration TESTED (not just written)
3. Down migration preserves data where possible
4. Documentation of data loss in down (if any)
```

### When Down Migration Fails

```
Emergency rollback procedure:

1. STOP the migration (kill query if safe)
2. Do NOT attempt untested rollback
3. Restore from backup if needed
4. Document what happened
5. Fix migration, retest, retry
```

### Data Restoration

```
Backup restoration checklist:

[ ] Identify last good backup timestamp
[ ] Calculate data loss window
[ ] Communicate with stakeholders
[ ] Perform point-in-time recovery
[ ] Verify data integrity post-restore
[ ] Document incident
```

## Zero-Downtime Migration Patterns

### Adding NOT NULL Column

```
Wrong (causes downtime):
ALTER TABLE users ADD COLUMN status VARCHAR NOT NULL;

Right (zero-downtime):
1. ALTER TABLE users ADD COLUMN status VARCHAR;
2. UPDATE users SET status = 'active' WHERE status IS NULL; (batched)
3. ALTER TABLE users ALTER COLUMN status SET NOT NULL;
```

### Renaming Column

```
Wrong (causes downtime):
ALTER TABLE users RENAME COLUMN name TO full_name;

Right (zero-downtime):
1. Add new column: ALTER TABLE users ADD COLUMN full_name VARCHAR;
2. Backfill: UPDATE users SET full_name = name; (batched)
3. Deploy code reading both, writing both
4. Deploy code reading new only
5. Drop old: ALTER TABLE users DROP COLUMN name;
```

### Adding Foreign Key

```
Wrong (locks table):
ALTER TABLE orders ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);

Right (minimal locking):
1. ALTER TABLE orders ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) NOT VALID;
2. ALTER TABLE orders VALIDATE CONSTRAINT fk_user;
```

## Common Failures

| Failure | Cause | Prevention |
|---------|-------|------------|
| Table locked for hours | Large table ALTER | Use batching, off-peak |
| Application errors | Code expects old schema | Deploy code first |
| Rollback fails | Down migration not tested | Always test rollback |
| Data corruption | Missing WHERE clause | Review queries manually |
| Migration timeout | Underestimated size | Test on staging first |
| Constraint violation | Dirty data | Clean data before constraint |

## Red Flags - STOP

- Running migration without backup verification
- "Quick" production fix without staging test
- Combining schema + data migration
- ALTER on large table during peak hours
- No rollback plan documented
- "Should work" without testing
- Ignoring staging test failures
- Skipping pre-flight checklist

## Key Patterns

**Adding column:**
```
- Add nullable column
- Deploy code using column
- Backfill if needed
- Add NOT NULL if needed (separate migration)
```

**Removing column:**
```
- Remove all code references
- Deploy and verify
- Add to ORM ignore list
- Wait one deployment cycle
- Drop column
```

**Adding index:**
```
- Use CONCURRENTLY (PostgreSQL)
- Run during low-traffic period
- Monitor lock wait time
- Have kill-query ready
```

**Data migration:**
```
- Separate from schema migration
- Batch updates (1000-10000 rows)
- Include progress logging
- Have stop mechanism
- Verify counts before/after
```

## The Gate Function

```
BEFORE running any migration:

1. BACKUP: Is there a verified, restorable backup?
2. ROLLBACK: Has the down migration been tested?
3. STAGING: Has this run successfully on staging?
4. IMPACT: Do you know exactly what will change?
5. TIMING: Is this the right time to run it?
6. MONITORING: Will you know if it fails?

If ANY answer is NO or UNCLEAR: STOP. Do not proceed.
```

## Why This Matters

Database migrations gone wrong cause:
- Permanent data loss (no recovery possible)
- Hours or days of downtime
- Customer-facing outages
- Compliance violations
- Lost revenue and trust

Unlike code bugs, data loss cannot be reverted.

## When To Apply

**ALWAYS before:**
- Any ALTER TABLE statement
- Any migration file creation
- Any data transformation
- Any DROP statement
- Any constraint modification

**Rule applies regardless of:**
- "Small" changes
- "Safe" tables
- "Development" environment
- Time pressure
- Stakeholder pressure

## The Bottom Line

**Data is irreplaceable. Migrations are irreversible.**

Complete the pre-flight checklist. Test the rollback. Then proceed.

This is non-negotiable.
