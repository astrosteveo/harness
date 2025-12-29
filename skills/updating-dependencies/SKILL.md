---
name: updating-dependencies
description: Use when updating library versions, applying security patches, or handling breaking changes from dependency updates
---

# Managing Dependency Updates

## Overview

Systematically update project dependencies while minimizing risk of breaking changes. This skill covers security patches, version upgrades, and handling breaking changes with appropriate testing and rollback strategies.

**Announce at start:** "I'm using the updating-dependencies skill to manage this update safely."

## When To Use This Skill

**ALWAYS use when:**
- Updating any project dependency
- Responding to security vulnerability alerts (Dependabot, npm audit, etc.)
- Upgrading to new major versions
- Resolving peer dependency conflicts
- Migrating deprecated dependencies

**Skip only when:**
- Adding a brand new dependency (use researching skill instead)
- User explicitly wants a quick update without safety checks

## Types of Updates

### Security Patches (HIGH PRIORITY)

Security patches fix vulnerabilities without changing functionality.

**Characteristics:**
- Often patch version bumps (1.2.3 -> 1.2.4)
- May come via automated alerts (Dependabot, Snyk, npm audit)
- Generally safe to apply quickly
- May be urgent depending on severity (CVSS score)

**Approach:**
1. Verify the advisory is legitimate (check CVE database or npm advisory)
2. Apply the patch
3. Run existing test suite
4. Deploy promptly for critical/high severity

### Minor Version Updates

Minor versions add features while maintaining backward compatibility.

**Characteristics:**
- Middle number changes (1.2.x -> 1.3.0)
- Should not break existing code (semver promise)
- May add deprecation warnings for future major versions
- Good opportunity to adopt new features

**Approach:**
1. Review changelog for new features and deprecations
2. Apply update
3. Run test suite
4. Address any deprecation warnings proactively

### Major Version Updates (CAUTION)

Major versions may contain breaking changes.

**Characteristics:**
- First number changes (1.x.x -> 2.0.0)
- Breaking changes expected
- May require code modifications
- Migration guides usually available
- May have peer dependency implications

**Approach:**
1. Read migration guide thoroughly
2. Check for codemod/migration tools
3. Assess scope of breaking changes
4. Plan incremental migration if large
5. Update code before or alongside version bump
6. Extensive testing required

## Risk Assessment Checklist

Before applying any update, assess risk level:

```markdown
## Update Risk Assessment

**Dependency:** [name]
**Current Version:** [x.y.z]
**Target Version:** [a.b.c]
**Update Type:** [ ] Security Patch  [ ] Minor  [ ] Major

### Risk Factors

**Low Risk (proceed with confidence):**
- [ ] Security patch with no API changes
- [ ] Minor update from well-maintained library
- [ ] Comprehensive test coverage exists
- [ ] Library follows semantic versioning strictly
- [ ] No peer dependency conflicts

**Medium Risk (proceed with caution):**
- [ ] Minor update with deprecation warnings
- [ ] Library has history of minor breaking changes
- [ ] Limited test coverage for affected areas
- [ ] Multiple dependencies being updated together
- [ ] Transitive dependency update

**High Risk (plan carefully):**
- [ ] Major version update
- [ ] Core dependency (React, database driver, etc.)
- [ ] Library has known migration complexity
- [ ] Peer dependencies also need updates
- [ ] No migration guide available
- [ ] Library is poorly maintained or abandoned

### Pre-Update Checklist

- [ ] Read CHANGELOG/release notes
- [ ] Check for breaking changes
- [ ] Review deprecation notices
- [ ] Check peer dependency requirements
- [ ] Verify test suite passes before update
- [ ] Identify rollback strategy
```

## The Update Process

### Step 1: Research the Update

Before touching any files:

1. **Check current state:**
   - What version is currently installed?
   - Are there any existing version constraints?
   - What depends on this package?

2. **Review release information:**
   - Read changelog between current and target versions
   - Note breaking changes, deprecations, new features
   - Check GitHub issues for reported problems with target version
   - Look for migration guides or codemods

3. **Assess dependencies:**
   - Will peer dependencies need updates?
   - Are there transitive dependency conflicts?
   - Check if other packages pin conflicting versions

### Step 2: Prepare for Update

1. **Verify clean state:**
   ```bash
   git status  # Should be clean or changes committed
   ```

2. **Ensure tests pass:**
   ```bash
   npm test  # or equivalent
   ```

3. **Create dedicated branch (for major updates):**
   ```bash
   git checkout -b update/package-name-v2
   ```

### Step 3: Apply the Update

**Strategy: One at a Time vs Batch**

| Approach | When to Use |
|----------|-------------|
| **One at a time** | Major updates, unfamiliar libraries, limited test coverage |
| **Batch related** | Security patches, minor updates to related packages |
| **All at once** | Only for trivial updates with excellent test coverage |

**Applying the update:**

```bash
# Single package (npm)
npm install package-name@version

# Single package (yarn)
yarn add package-name@version

# Single package (pnpm)
pnpm add package-name@version

# Security patches only
npm audit fix

# Update within semver range
npm update package-name
```

### Step 4: Handle Lockfile

The lockfile (package-lock.json, yarn.lock, pnpm-lock.yaml) should:
- Be committed with the update
- Not be manually edited
- Be regenerated if corrupted: delete and reinstall

**After update, verify:**
```bash
# Verify lockfile is consistent
npm ci  # Clean install from lockfile

# Check for unexpected changes
git diff package-lock.json
```

### Step 5: Test After Update

**Minimum testing requirements:**

1. **Automated tests:**
   ```bash
   npm test
   npm run lint
   npm run typecheck  # if TypeScript
   ```

2. **Build verification:**
   ```bash
   npm run build
   ```

3. **Manual smoke testing:**
   - Start the application
   - Test core user flows
   - Check for console errors/warnings

**For major updates, also:**
- Test edge cases in affected areas
- Performance testing if relevant
- Check bundle size changes
- Verify in staging environment

### Step 6: Regression Detection

Watch for these signs of regression:

- **Type errors** - Especially with TypeScript strict mode
- **New deprecation warnings** - Log at startup
- **Test failures** - Even unrelated tests may reveal issues
- **Runtime errors** - Check browser console, server logs
- **Performance degradation** - Slower builds, larger bundles
- **Visual regressions** - UI changes from CSS library updates

## Handling Breaking Changes

When you encounter breaking changes:

### 1. Find the Migration Guide

Most major libraries provide migration guides:
- Check the library's documentation site
- Look in the GitHub release notes
- Search for "[library] v[X] migration guide"
- Check for official codemods/upgrade scripts

### 2. Assess Migration Scope

Determine how much code needs to change:

```bash
# Find usages of the library
grep -r "import.*from 'library-name'" src/
grep -r "require('library-name')" src/

# Find usages of deprecated/changed APIs
grep -r "deprecatedMethod" src/
```

### 3. Apply Changes Systematically

**For small changes:**
- Apply migration guide step by step
- Commit logical units of change

**For large changes:**
- Consider incremental migration if library supports it
- Use adapter patterns to isolate changes
- May warrant its own feature branch and PR

### 4. Common Breaking Change Patterns

| Change Type | How to Handle |
|-------------|---------------|
| Renamed export | Find and replace all imports |
| Changed function signature | Update all call sites |
| Removed deprecated API | Replace with recommended alternative |
| Changed default behavior | May need explicit configuration |
| New peer dependency | Install required peer |
| Dropped Node/browser version | Verify environment compatibility |

## Rollback Strategies

If an update causes problems:

### Immediate Rollback (Before Commit)

```bash
# Discard changes to package files
git checkout -- package.json package-lock.json

# Reinstall previous versions
npm ci
```

### Rollback After Commit

```bash
# Revert the update commit
git revert <commit-hash>

# Or reset to previous state
git reset --hard HEAD~1

# Reinstall
npm ci
```

### Partial Rollback

If only one package in a batch update caused issues:

```bash
# Install the previous version of just that package
npm install problem-package@previous-version
```

### When to Rollback

Rollback immediately if:
- Critical functionality is broken
- Security vulnerability introduced
- Build completely fails
- Majority of tests fail

Investigate before rollback if:
- Only some tests fail (may be test issues)
- Deprecation warnings appear (not breaking)
- Minor visual differences (may be intentional)

## Version Pinning Strategies

### When to Pin (Exact Versions)

Use exact versions (`"package": "1.2.3"`) when:
- Deploying to production with strict reproducibility needs
- Package has history of breaking semver
- You need to control exactly when updates happen
- Working with poorly maintained packages
- Lock file not committed (unusual)

### When to Float (Ranges)

Use version ranges when:
- **Caret `^1.2.3`** - Accept minor and patch updates (default, recommended)
- **Tilde `~1.2.3`** - Accept only patch updates (more conservative)
- **Range `>=1.2.3 <2.0.0`** - Explicit range for complex requirements

### Recommended Strategy

```json
{
  "dependencies": {
    "core-library": "^2.0.0",
    "problematic-lib": "1.2.3",
    "peer-sensitive": "~3.4.0"
  }
}
```

- Use `^` (caret) by default - get patches and minor features
- Pin exact versions for known-problematic packages
- Use `~` (tilde) when you want patches but not new features
- Document WHY you've pinned or constrained any package

## Integration With Other Skills

### With Researching Skill

Use researching to:
- Check current stable version before updating
- Find migration guides and known issues
- Verify compatibility with other dependencies

### With Systematic-Debugging Skill

If update causes failures:
- Bisect to identify which update caused the issue
- Use debugging skill's root cause analysis

### With Test-Driven-Development Skill

For major updates:
- Write tests for expected behavior changes first
- Update code to pass new tests
- Verify old tests still pass or update as needed

## Key Principles

- **One change at a time** - Easier to identify which update caused issues
- **Read the changelog** - Always know what you're updating to
- **Test thoroughly** - Run full test suite, not just affected tests
- **Commit lockfile** - Lockfile ensures reproducible installs
- **Document constraints** - Add comments explaining why versions are pinned
- **Stay current** - Regular small updates are safer than rare large ones
- **Automate alerts** - Use Dependabot/Renovate for update notifications

## Example Update Session

User asks to update React from v17 to v18:

```
"I'm using the updating-dependencies skill to manage this update safely."

## Update Risk Assessment

**Dependency:** react
**Current Version:** 17.0.2
**Target Version:** 18.2.0
**Update Type:** [X] Major

### Risk Factors Identified
- [X] Major version update
- [X] Core dependency (React)
- [X] Peer dependencies also need updates (react-dom)

### Research Findings
- Migration guide available at react.dev/blog/2022/03/08/react-18-upgrade-guide
- Key changes: createRoot API, automatic batching, strict mode behavior
- Codemod available: npx codemod react/19/migration-recipe

### Plan
1. Create branch: update/react-18
2. Update react and react-dom together
3. Run codemod for createRoot migration
4. Run test suite
5. Manual testing of key flows
6. Review strict mode warnings in development
```
