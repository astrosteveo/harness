---
name: working-with-monorepos
description: Use when working in a monorepo with multiple packages, coordinating cross-package changes, or understanding package dependencies
---

# Working with Monorepos

## Overview

Monorepos contain multiple packages/projects in a single repository, sharing code, dependencies, and tooling. Understanding their structure is essential for making safe, efficient changes.

**Core principle:** Understand dependency graph + scope changes appropriately = safe cross-package work.

**Announce at start:** "I'm using the working-with-monorepos skill to navigate this multi-package repository."

## Structure Discovery

### 1. Identify Monorepo Type

```bash
# Check for workspace configuration
cat package.json | grep -A5 '"workspaces"'           # npm/yarn workspaces
cat pnpm-workspace.yaml 2>/dev/null                  # pnpm workspaces
cat nx.json 2>/dev/null                              # Nx
cat turbo.json 2>/dev/null                           # Turborepo
cat lerna.json 2>/dev/null                           # Lerna
cat rush.json 2>/dev/null                            # Rush

# Go monorepo
cat go.work 2>/dev/null                              # Go workspaces
find . -name "go.mod" -type f                        # Multi-module

# Python monorepo
cat pyproject.toml | grep -A5 'tool.poetry.packages' # Poetry workspaces
find . -name "setup.py" -o -name "pyproject.toml"    # Multi-package
```

### 2. Map Package Locations

```bash
# Common patterns - check what exists
ls -la packages/                    # packages/*
ls -la apps/                        # apps/* (Nx/Turbo convention)
ls -la libs/                        # libs/* (shared libraries)
ls -la modules/                     # modules/*
ls -la services/                    # services/* (microservices)

# List all packages (tool-specific)
npm query .workspace | jq '.[].name'    # npm 8+
yarn workspaces list --json             # yarn
pnpm list -r --depth -1                 # pnpm
npx nx show projects                    # Nx
npx lerna list                          # Lerna
```

### 3. Understand Package Roles

| Directory | Typical Purpose |
|-----------|-----------------|
| `apps/` | Deployable applications |
| `packages/` | Shared libraries/utilities |
| `libs/` | Internal shared code |
| `services/` | Backend services |
| `tools/` | Build/dev tooling |
| `configs/` | Shared configurations |

## Dependency Analysis

### 1. Map Internal Dependencies

```bash
# Find what a package depends on internally
grep -r '"@myorg/' packages/my-package/package.json

# Find what depends on a package
grep -r '"@myorg/my-package"' --include="package.json" .

# Nx dependency graph (generates visualization)
npx nx graph

# Turborepo dependency info
npx turbo run build --dry-run --filter=my-package

# Lerna dependency tree
npx lerna ls --graph
```

### 2. Build Dependency Graph Mentally

```
app-web
  -> @myorg/ui-components
     -> @myorg/design-tokens
  -> @myorg/api-client
     -> @myorg/shared-types

app-mobile
  -> @myorg/ui-components (shared!)
  -> @myorg/api-client (shared!)
```

**Key insight:** Changes to `@myorg/ui-components` affect both `app-web` AND `app-mobile`.

### 3. Identify Dependency Direction

- **Leaf packages:** No internal dependencies (safe to modify)
- **Core packages:** Many dependents (changes ripple outward)
- **App packages:** Depend on many, nothing depends on them

## Running Commands

### Root-Level Commands

```bash
# Install all dependencies
npm install                     # npm workspaces
yarn install                    # yarn workspaces
pnpm install                    # pnpm workspaces

# Run across all packages
npm run build --workspaces
yarn workspaces run build
pnpm -r run build
npx nx run-many --target=build
npx turbo run build
```

### Package-Specific Commands

```bash
# npm workspaces
npm run test --workspace=@myorg/my-package
npm run test -w @myorg/my-package

# yarn workspaces
yarn workspace @myorg/my-package test

# pnpm
pnpm --filter @myorg/my-package test
pnpm -F @myorg/my-package test

# Nx
npx nx test my-package

# Turborepo
npx turbo run test --filter=my-package

# Lerna
npx lerna run test --scope=@myorg/my-package

# Direct (always works)
cd packages/my-package && npm test
```

### Filtering by Pattern

```bash
# All packages matching pattern
pnpm --filter "@myorg/*" build
npx turbo run build --filter="packages/*"
npx nx run-many --target=build --projects="libs/*"
npx lerna run build --scope="@myorg/feature-*"
```

## Change Impact Analysis

### 1. Identify What Changed

```bash
# Files changed vs main branch
git diff --name-only main

# Packages with changes
git diff --name-only main | cut -d'/' -f1-2 | sort -u
```

### 2. Find Affected Packages

```bash
# Nx affected (recommended - understands dependency graph)
npx nx affected --target=build --base=main
npx nx affected:test --base=main

# Turborepo affected
npx turbo run build --filter="...[origin/main]"

# Lerna changed
npx lerna changed

# Manual: Find dependents of changed package
grep -r '"@myorg/changed-package"' --include="package.json" . | cut -d: -f1
```

### 3. Visualize Impact

```
Changed: @myorg/api-client

Direct dependents:
  -> app-web
  -> app-mobile
  -> @myorg/data-layer

Transitive dependents:
  -> app-admin (via @myorg/data-layer)
```

## Testing Strategies

### Test Affected Only (Fast Feedback)

```bash
# Nx (best support for affected)
npx nx affected:test --base=main

# Turborepo with filter
npx turbo run test --filter="...[origin/main]"

# Manual approach
for pkg in $(git diff --name-only main | cut -d'/' -f2 | sort -u); do
  npm run test -w packages/$pkg
done
```

### Test All (Pre-merge/CI)

```bash
# Run all tests
npm run test --workspaces
yarn workspaces run test
pnpm -r run test
npx nx run-many --target=test --all
npx turbo run test
```

### Test Specific Package + Dependents

```bash
# Nx: test package and everything that depends on it
npx nx affected:test --base=main --head=HEAD

# Turborepo: test package and dependents
npx turbo run test --filter="my-package..."

# The "..." means "and all dependents"
```

### Recommended Strategy

| Scenario | Approach |
|----------|----------|
| During development | Test changed package only |
| Before commit | Test affected packages |
| Before merge | Test all packages |
| CI pipeline | Test affected + build all |

## Cross-Package Refactoring

### Safe Refactoring Process

1. **Map the blast radius:**
   ```bash
   # What uses the thing I'm changing?
   grep -r "functionToChange" --include="*.ts" packages/
   ```

2. **Start from leaves:**
   - Modify leaf packages first (no dependents)
   - Work up the dependency tree

3. **Maintain backward compatibility:**
   ```typescript
   // Add new signature, deprecate old
   /** @deprecated Use newFunction instead */
   export function oldFunction() { return newFunction(); }
   export function newFunction() { /* new implementation */ }
   ```

4. **Update consumers incrementally:**
   - Update one package at a time
   - Run tests after each update
   - Commit working states

5. **Remove deprecated code:**
   - Only after all consumers updated
   - Search for usage before removing

### Cross-Package Type Changes

```bash
# Find all imports of the type
grep -r "import.*MyType" --include="*.ts" .

# Check if type is re-exported
grep -r "export.*MyType" --include="*.ts" packages/
```

### Shared Configuration Changes

```bash
# Find what extends shared config
grep -r "extends.*@myorg/config" .
grep -r "preset.*@myorg/config" .
```

## Common Tools Reference

### npm Workspaces

```json
// package.json
{
  "workspaces": ["packages/*", "apps/*"]
}
```

```bash
npm install                              # Install all
npm run build --workspaces               # Build all
npm run test -w @myorg/package           # Test one
```

### Yarn Workspaces

```json
// package.json
{
  "workspaces": ["packages/*"]
}
```

```bash
yarn install                             # Install all
yarn workspaces run build                # Build all
yarn workspace @myorg/package test       # Test one
```

### pnpm Workspaces

```yaml
# pnpm-workspace.yaml
packages:
  - 'packages/*'
  - 'apps/*'
```

```bash
pnpm install                             # Install all
pnpm -r run build                        # Build all
pnpm -F @myorg/package test              # Test one
```

### Nx

```bash
npx nx build my-package                  # Build one
npx nx run-many --target=build           # Build all
npx nx affected:test --base=main         # Test affected
npx nx graph                             # Visualize deps
```

### Turborepo

```json
// turbo.json
{
  "pipeline": {
    "build": { "dependsOn": ["^build"] },
    "test": { "dependsOn": ["build"] }
  }
}
```

```bash
npx turbo run build                      # Build all (cached)
npx turbo run test --filter=my-package   # Test one
npx turbo run build --filter="...[main]" # Build affected
```

### Lerna

```bash
npx lerna run build                      # Build all
npx lerna run test --scope=my-package    # Test one
npx lerna changed                        # List changed
npx lerna publish                        # Publish changed
```

## Quick Reference

| Task | Command Pattern |
|------|-----------------|
| Install all deps | `npm/yarn/pnpm install` (at root) |
| Build all | `npm run build --workspaces` or tool-specific |
| Build one | `npm run build -w package-name` |
| Test affected | `nx affected:test` or `turbo run test --filter="...[main]"` |
| Find dependents | `grep -r "package-name" --include="package.json"` |
| Visualize deps | `nx graph` or check tool docs |

## Common Mistakes

### Modifying shared code without checking dependents

- **Problem:** Breaking changes ripple to unknown consumers
- **Fix:** Always grep for usage before modifying exports

### Running commands from wrong directory

- **Problem:** Commands fail or affect wrong packages
- **Fix:** Run workspace commands from repo root, or use --filter/-w

### Ignoring transitive dependencies

- **Problem:** Tests pass locally but fail in dependents
- **Fix:** Test affected packages, not just changed package

### Forgetting to build dependencies first

- **Problem:** Package uses stale version of internal dependency
- **Fix:** Use tools that understand build order (Nx, Turbo)

### Publishing with broken internal deps

- **Problem:** Published package references unpublished changes
- **Fix:** Use `lerna version`/`changeset` for coordinated releases

## Example Workflow

```
You: I'm using the working-with-monorepos skill to navigate this multi-package repository.

[Check monorepo type - found turbo.json and pnpm-workspace.yaml]
[List packages - found apps/web, apps/mobile, packages/ui, packages/api-client]
[Analyze task: modify packages/api-client]
[Find dependents of api-client: apps/web, apps/mobile]

I need to modify @myorg/api-client. This affects:
- apps/web (direct dependent)
- apps/mobile (direct dependent)

[Make changes to packages/api-client]
[Run: pnpm -F @myorg/api-client test - passes]
[Run: pnpm turbo run test --filter="@myorg/api-client..." - tests affected]

All affected packages tested:
- @myorg/api-client: 12 tests passing
- apps/web: 45 tests passing
- apps/mobile: 38 tests passing
```

## Red Flags

**Never:**
- Modify shared packages without checking what depends on them
- Skip testing dependents after changing a core package
- Assume you understand the dependency graph without verifying
- Run install/build from a package directory expecting workspace behavior
- Publish packages without coordinated versioning

**Always:**
- Discover the monorepo tool in use first
- Map dependencies before cross-package changes
- Test affected packages, not just changed ones
- Run workspace commands from repository root
- Use tool-specific commands for reliability

## Integration

**Pairs with:**
- **using-git-worktrees** - Isolate monorepo work in separate worktree
- **writing-plans** - Plan cross-package changes with dependency awareness
- **test-driven-development** - TDD within individual packages
- **verification-before-completion** - Verify all affected packages pass
