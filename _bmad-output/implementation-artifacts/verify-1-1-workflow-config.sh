#!/usr/bin/env bash
# ATDD verification for Story 1-1: Adapt workflow config for Cursor
# Exit 0 = all checks pass (story done); non-zero = at least one check fails (red phase)
# Usage: from repo root, run: bash _bmad-output/implementation-artifacts/verify-1-1-workflow-config.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORKFLOW_STEPS="${REPO_ROOT}/.cursor/skills/bmad-story-pipeline/references/workflow-steps.md"
if [[ ! -f "$WORKFLOW_STEPS" ]]; then
  WORKFLOW_STEPS="${REPO_ROOT}/skills/bmad-story-pipeline/references/workflow-steps.md"
fi
if [[ ! -f "$WORKFLOW_STEPS" ]]; then
  echo "FAIL: workflow-steps.md not found"
  exit 1
fi

FAIL=0

# AC2: No slash commands
if grep -qE 'Command:\s*`?/bmad-' "$WORKFLOW_STEPS" 2>/dev/null || grep -qE 'run\s+`?/bmad-' "$WORKFLOW_STEPS" 2>/dev/null; then
  echo "FAIL: AC2 — workflow-steps.md still contains 'Command: /bmad-...' or 'run /bmad-...'"
  FAIL=1
fi

# AC1: Each step has Prompt focus and Expected return
if ! grep -q 'Prompt focus:' "$WORKFLOW_STEPS" 2>/dev/null; then
  echo "FAIL: AC1 — workflow-steps.md has no 'Prompt focus:' line"
  FAIL=1
fi
if ! grep -q 'Expected return:' "$WORKFLOW_STEPS" 2>/dev/null; then
  echo "FAIL: AC1 — workflow-steps.md has no 'Expected return:' line"
  FAIL=1
fi

# AC4: Five steps in expected order (step titles present)
for title in "Create User Story" "Generate ATDD Tests" "Development" "Code Review" "Trace Test Coverage"; do
  if ! grep -q "$title" "$WORKFLOW_STEPS" 2>/dev/null; then
    echo "FAIL: AC4 — missing step: $title"
    FAIL=1
  fi
done

if [[ $FAIL -eq 0 ]]; then
  echo "PASS: Story 1-1 workflow config checks"
  exit 0
fi
exit 1
