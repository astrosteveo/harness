#!/bin/bash
# Run all explicit skill request tests
# Usage: ./run-all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

echo "=== Running All Explicit Skill Request Tests ==="
echo ""

PASSED=0
FAILED=0
RESULTS=""

# Test: subagent-driven-development, please
echo ">>> Test 1: subagent-driven-development-please"
if "$SCRIPT_DIR/run-test.sh" "subagent-driven-development" "$PROMPTS_DIR/subagent-driven-development-please.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: subagent-driven-development-please"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: subagent-driven-development-please"
fi
echo ""

# Test: use systematic-debugging
echo ">>> Test 2: use-systematic-debugging"
if "$SCRIPT_DIR/run-test.sh" "systematic-debugging" "$PROMPTS_DIR/use-systematic-debugging.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: use-systematic-debugging"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: use-systematic-debugging"
fi
echo ""

# Test: please use brainstorming
echo ">>> Test 3: please-use-brainstorming"
if "$SCRIPT_DIR/run-test.sh" "brainstorming" "$PROMPTS_DIR/please-use-brainstorming.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: please-use-brainstorming"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: please-use-brainstorming"
fi
echo ""

# Test: mid-conversation execute plan
echo ">>> Test 4: mid-conversation-execute-plan"
if "$SCRIPT_DIR/run-test.sh" "subagent-driven-development" "$PROMPTS_DIR/mid-conversation-execute-plan.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: mid-conversation-execute-plan"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: mid-conversation-execute-plan"
fi
echo ""

# Test: after-planning-flow (user chooses subagent-driven)
echo ">>> Test 5: after-planning-flow"
if "$SCRIPT_DIR/run-test.sh" "subagent-driven-development" "$PROMPTS_DIR/after-planning-flow.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: after-planning-flow"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: after-planning-flow"
fi
echo ""

# Test: autonomous mode selection (should trigger subagent-driven-development)
echo ">>> Test 6: autonomous-mode-selection"
if "$SCRIPT_DIR/run-test.sh" "subagent-driven-development" "$PROMPTS_DIR/autonomous-mode-selection.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: autonomous-mode-selection"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: autonomous-mode-selection"
fi
echo ""

# Test: checkpoint mode selection (should trigger subagent-driven-development)
echo ">>> Test 7: checkpoint-mode-selection"
if "$SCRIPT_DIR/run-test.sh" "subagent-driven-development" "$PROMPTS_DIR/checkpoint-mode-selection.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: checkpoint-mode-selection"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: checkpoint-mode-selection"
fi
echo ""

# Test: batch review selection (should trigger executing-plans)
echo ">>> Test 8: batch-review-selection"
if "$SCRIPT_DIR/run-test.sh" "executing-plans" "$PROMPTS_DIR/batch-review-selection.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: batch-review-selection"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: batch-review-selection"
fi
echo ""

echo "=== Summary ==="
echo -e "$RESULTS"
echo ""
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total: $((PASSED + FAILED))"

if [ "$FAILED" -gt 0 ]; then
    exit 1
fi
