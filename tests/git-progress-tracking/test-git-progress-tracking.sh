#!/bin/bash
# Test git-based progress tracking detection
# Tests the logic that session start uses to find incomplete work

# Don't use set -e - we handle errors explicitly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_REPO=""
PASSED=0
FAILED=0

cleanup() {
  if [ -n "$TEST_REPO" ] && [ -d "$TEST_REPO" ]; then
    rm -rf "$TEST_REPO"
  fi
}
trap cleanup EXIT

# Setup test repo with a plan (creates fresh repo each time)
setup_test_repo() {
  # Clean up previous test repo if exists
  if [ -n "$TEST_REPO" ] && [ -d "$TEST_REPO" ]; then
    rm -rf "$TEST_REPO"
  fi

  TEST_REPO=$(mktemp -d)
  cd "$TEST_REPO"
  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"

  mkdir -p .harness/001-test-feature
  cat > .harness/001-test-feature/plan.md << 'EOF'
# Test Feature Plan

**Phases:**
1. Phase 1: Setup (2 tasks)
2. Phase 2: Core (2 tasks)
3. Phase 3: Polish (2 tasks)

---

## Phase 1: Setup
### Task 1.1: First task
### Task 1.2: Second task

## Phase 2: Core
### Task 2.1: Third task
### Task 2.2: Fourth task

## Phase 3: Polish
### Task 3.1: Fifth task
### Task 3.2: Sixth task
EOF

  git add .harness/
  git commit -q -m "docs: add test plan"
}

# Count phases in a plan
count_plan_phases() {
  local plan="$1"
  grep -c "^## Phase" "$plan" 2>/dev/null || echo 0
}

# Count completed phases from git
count_completed_phases() {
  local plan="$1"
  local plan_sha
  plan_sha=$(git log --diff-filter=A --format=%H -- "$plan" 2>/dev/null | head -1)
  if [ -z "$plan_sha" ]; then
    echo 0
    return
  fi
  local count
  count=$(git log ${plan_sha}..HEAD --format=%B 2>/dev/null | grep -c "^phase([0-9]*): complete$") || count=0
  echo "$count"
}

# Check if plan is abandoned
is_abandoned() {
  local plan="$1"
  local plan_sha
  plan_sha=$(git log --diff-filter=A --format=%H -- "$plan" 2>/dev/null | head -1)
  if [ -z "$plan_sha" ]; then
    return 1
  fi
  git log ${plan_sha}..HEAD --format=%B 2>/dev/null | grep -q "^plan: abandoned$"
}

# Test helper
assert_eq() {
  local expected="$1"
  local actual="$2"
  local msg="$3"
  if [ "$expected" = "$actual" ]; then
    echo "PASS: $msg"
    PASSED=$((PASSED + 1))
  else
    echo "FAIL: $msg (expected: $expected, got: $actual)"
    FAILED=$((FAILED + 1))
  fi
}

# Test 1: No completions
test_no_completions() {
  echo "Test 1: No completions detected"
  setup_test_repo

  local total=$(count_plan_phases ".harness/001-test-feature/plan.md")
  local completed=$(count_completed_phases ".harness/001-test-feature/plan.md")

  assert_eq "3" "$total" "Total phases = 3"
  assert_eq "0" "$completed" "Completed phases = 0"
}

# Test 2: Partial completion
test_partial_completion() {
  echo "Test 2: Partial completion"
  setup_test_repo

  # Complete phase 1
  git commit -q --allow-empty -m "feat: complete Phase 1

phase(1): complete"

  # Complete phase 2
  git commit -q --allow-empty -m "feat: complete Phase 2

phase(2): complete"

  local completed=$(count_completed_phases ".harness/001-test-feature/plan.md")
  assert_eq "2" "$completed" "Completed phases = 2"
}

# Test 3: Full completion
test_full_completion() {
  echo "Test 3: Full completion"
  setup_test_repo

  git commit -q --allow-empty -m "phase(1): complete"
  git commit -q --allow-empty -m "phase(2): complete"
  git commit -q --allow-empty -m "phase(3): complete"

  local total=$(count_plan_phases ".harness/001-test-feature/plan.md")
  local completed=$(count_completed_phases ".harness/001-test-feature/plan.md")

  assert_eq "$total" "$completed" "All phases complete"
}

# Test 4: Abandoned plan
test_abandoned_plan() {
  echo "Test 4: Abandoned plan"
  setup_test_repo

  git commit -q --allow-empty -m "chore: abandon test plan

plan: abandoned"

  if is_abandoned ".harness/001-test-feature/plan.md"; then
    echo "PASS: Plan detected as abandoned"
    PASSED=$((PASSED + 1))
  else
    echo "FAIL: Plan should be detected as abandoned"
    FAILED=$((FAILED + 1))
  fi
}

# Test 5: Multiple plans - tests independent tracking
test_multiple_plans() {
  echo "Test 5: Multiple plans"
  setup_test_repo

  # Complete phase 1 of first plan BEFORE adding second plan
  git commit -q --allow-empty -m "phase(1): complete"

  # Add second plan after the phase completion
  mkdir -p .harness/002-other-feature
  cat > .harness/002-other-feature/plan.md << 'EOF'
# Other Feature

**Phases:**
1. Phase 1: Only phase (2 tasks)

---

## Phase 1: Only phase
### Task 1.1: Task
### Task 1.2: Task
EOF
  git add .harness/002-other-feature/
  git commit -q -m "docs: add second plan"

  local completed1=$(count_completed_phases ".harness/001-test-feature/plan.md")
  local completed2=$(count_completed_phases ".harness/002-other-feature/plan.md")

  # First plan should see the phase completion (it was added before)
  # Second plan should NOT see it (it was added after the completion)
  assert_eq "1" "$completed1" "First plan: 1 phase complete"
  assert_eq "0" "$completed2" "Second plan: 0 phases complete"
}

# Run all tests
echo "=== Git Progress Tracking Tests ==="
echo ""

test_no_completions
echo ""
test_partial_completion
echo ""
test_full_completion
echo ""
test_abandoned_plan
echo ""
test_multiple_plans

echo ""
echo "=== Results ==="
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
