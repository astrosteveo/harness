#!/usr/bin/env bash
# SessionStart hook for harness plugin

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check for incomplete plans in .harness/*/plan.md
INCOMPLETE_PLANS=""
if [ -d ".harness" ]; then
    for plan_file in .harness/*/plan.md; do
        [ -f "$plan_file" ] || continue

        # Extract feature name from path
        feature_dir=$(dirname "$plan_file")
        feature_name=$(basename "$feature_dir")

        # Check if plan was abandoned
        if git log --all --format=%B 2>/dev/null | grep -q "plan: abandoned.*${feature_name}"; then
            continue
        fi

        # Count total phases from plan header (look for "Phase N:" patterns)
        total_phases=$(grep -cE "^## Phase [0-9]+:" "$plan_file" 2>/dev/null || echo "0")

        if [ "$total_phases" = "0" ]; then
            continue
        fi

        # Count completed phases from git log
        completed_phases=$(git log --format=%B 2>/dev/null | grep -cE "^phase\([0-9]+\): complete$" || echo "0")

        # If not all phases complete, add to list
        if [ "$completed_phases" -lt "$total_phases" ]; then
            next_phase=$((completed_phases + 1))
            # Get next phase name
            next_phase_name=$(grep -E "^## Phase ${next_phase}:" "$plan_file" 2>/dev/null | sed 's/^## Phase [0-9]*: //' || echo "Unknown")
            INCOMPLETE_PLANS="${INCOMPLETE_PLANS}Feature: ${feature_name}\\nProgress: ${completed_phases} of ${total_phases} phases complete\\nNext: Phase ${next_phase}: ${next_phase_name}\\nPlan: ${plan_file}\\n\\n"
        fi
    done
fi

# Also check for legacy PENDING_EXECUTION marker
MARKER_FILE=".harness/PENDING_EXECUTION.md"
MARKER_CONTENT=""
if [ -f "$MARKER_FILE" ]; then
    MARKER_CONTENT=$(cat "$MARKER_FILE" 2>/dev/null || echo "")
fi

# Read using-harness content
using_harness_content=$(cat "${PLUGIN_ROOT}/skills/using-harness/SKILL.md" 2>&1 || echo "Error reading using-harness skill")

# Escape for JSON - prefer jq if available, fallback to bash
if command -v jq &> /dev/null; then
    using_harness_escaped=$(jq -Rs '.' <<< "$using_harness_content" | sed 's/^"//;s/"$//')
else
    # Fallback to bash escaping
    escape_for_json() {
        local input="$1"
        local output=""
        local i char
        for (( i=0; i<${#input}; i++ )); do
            char="${input:$i:1}"
            case "$char" in
                $'\\') output+='\\\\' ;;
                '"') output+='\\"' ;;
                $'\n') output+='\\n' ;;
                $'\r') output+='\\r' ;;
                $'\t') output+='\\t' ;;
                *) output+="$char" ;;
            esac
        done
        printf '%s' "$output"
    }
    using_harness_escaped=$(escape_for_json "$using_harness_content")
fi

# Build notifications for incomplete work
WORK_NOTIFICATION=""

# Add incomplete plans notification if any found
if [ -n "$INCOMPLETE_PLANS" ]; then
    WORK_NOTIFICATION="\\n\\n---\\n\\n**⛔ INCOMPLETE WORK DETECTED - YOU MUST ADDRESS THIS FIRST**\\n\\n${INCOMPLETE_PLANS}\\n**You MUST ask the user BEFORE doing anything else:** \\\"Resume? [Yes / No / Abandon]\\\"\\n\\n- **Yes**: Read the plan, invoke harness:subagent-driven-development\\n- **No**: Continue normal session (will prompt again next session)\\n- **Abandon**: Create abandon commit, continue normal session\\n\\n**DO NOT skip this prompt. DO NOT respond to the user's message until they answer.**"
fi

# Add legacy marker notification if exists
if [ -n "$MARKER_CONTENT" ]; then
    # Escape marker content for JSON
    if command -v jq &> /dev/null; then
        marker_escaped=$(jq -Rs '.' <<< "$MARKER_CONTENT" | sed 's/^"//;s/"$//')
    else
        marker_escaped=$(escape_for_json "$MARKER_CONTENT")
    fi
    WORK_NOTIFICATION="${WORK_NOTIFICATION}\\n\\n---\\n\\n**PENDING EXECUTION MARKER DETECTED**\\n\\nA .harness/PENDING_EXECUTION.md marker file exists:\\n\\n\`\`\`\\n${marker_escaped}\\n\`\`\`\\n\\n**You MUST ask the user:** \\\"Resume execution? [Yes / No / Cancel]\\\"\\n\\n- **Yes**: Invoke harness:subagent-driven-development with marker context\\n- **No**: Continue normal session (marker remains)\\n- **Cancel**: Delete marker file, continue normal session"
fi

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have harness skills.\n\n**Below is the full content of your 'harness:using-harness' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n---\n\n${using_harness_escaped}${WORK_NOTIFICATION}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
