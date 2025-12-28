#!/usr/bin/env bash
# SessionStart hook for harness plugin

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

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

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have harness skills.\n\n**Below is the full content of your 'harness:using-harness' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n${using_harness_escaped}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
