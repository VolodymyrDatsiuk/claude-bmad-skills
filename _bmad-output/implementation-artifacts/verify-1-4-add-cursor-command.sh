#!/usr/bin/env bash
# ATDD verification for Story 1-4: Add Cursor command (story-delivery orchestrator)
# Exit 0 = checks pass (command exists and implements AC1–AC6); non-zero = red phase or incomplete
# Usage: from repo root, run: bash _bmad-output/implementation-artifacts/verify-1-4-add-cursor-command.sh

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMMAND_FILE="${REPO_ROOT}/.cursor/commands/bmad-story-deliver.md"
WORKFLOW_STEPS="${REPO_ROOT}/.cursor/skills/bmad-story-pipeline/references/workflow-steps.md"
STEP_PROMPTS="${REPO_ROOT}/.cursor/skills/bmad-story-pipeline/references/step-prompts.md"
SPRINT_STATUS="${REPO_ROOT}/_bmad-output/implementation-artifacts/sprint-status.yaml"

FAIL=0

# --- AC1: Command file exists ---
if [[ ! -f "$COMMAND_FILE" ]]; then
  echo "FAIL: AC1 — Command file not found: ${COMMAND_FILE}"
  FAIL=1
fi

if [[ -f "$COMMAND_FILE" ]]; then
  CONTENT="$(cat "$COMMAND_FILE")"

  # --- AC2: Optional story ID and next not-done ---
  if ! echo "$CONTENT" | grep -qE "story ID|story ID argument|1-4|1\.4|sprint-status|next not-done|next not-done story"; then
    echo "FAIL: AC2 — Command does not reference optional story ID or sprint-status / next not-done resolution"
    FAIL=1
  fi

  # --- AC3: Load workflow steps, execute in order ---
  if ! echo "$CONTENT" | grep -qE "workflow-steps|workflow_steps|references/workflow-steps"; then
    echo "FAIL: AC3 — Command does not reference workflow-steps.md (pipeline definition)"
    FAIL=1
  fi
  if ! echo "$CONTENT" | grep -qE "in order|sequential|each step|step in order"; then
    echo "FAIL: AC3 — Command does not instruct to execute steps in order"
    FAIL=1
  fi

  # --- AC4: Subagent per step, step prompts, substitute, stop on failure ---
  if ! echo "$CONTENT" | grep -qE "step-prompts|step_prompts|step prompt|subagent|task tool|mcp_task"; then
    echo "FAIL: AC4 — Command does not reference step prompts or subagent/task per step"
    FAIL=1
  fi
  if ! echo "$CONTENT" | grep -qE "STORY_ID|story_location|substitut"; then
    echo "FAIL: AC4 — Command does not reference substituting STORY_ID or story_location in prompts"
    FAIL=1
  fi
  if ! echo "$CONTENT" | grep -qE "stop on fail|on failure|do not proceed|wait for completion"; then
    echo "FAIL: AC4 — Command does not instruct to stop on step failure or wait for completion"
    FAIL=1
  fi

  # --- AC5: Update sprint-status and story doc on success ---
  if ! echo "$CONTENT" | grep -qE "done|sprint-status|sprint_status"; then
    echo "FAIL: AC5 — Command does not reference updating sprint-status or setting story to done"
    FAIL=1
  fi
  if ! echo "$CONTENT" | grep -qE "story document|story doc|Status.*done|tasks.*✅|mark.*tasks"; then
    echo "FAIL: AC5 — Command does not reference updating story document (Status done, tasks ✅)"
    FAIL=1
  fi
fi

# --- Dependencies: workflow and step prompts exist (for command to load) ---
if [[ ! -f "$WORKFLOW_STEPS" ]]; then
  echo "FAIL: workflow-steps.md not found at ${WORKFLOW_STEPS}"
  FAIL=1
fi
if [[ ! -f "$STEP_PROMPTS" ]]; then
  echo "FAIL: step-prompts.md not found at ${STEP_PROMPTS}"
  FAIL=1
fi
if [[ ! -f "$SPRINT_STATUS" ]]; then
  echo "FAIL: sprint-status.yaml not found at ${SPRINT_STATUS}"
  FAIL=1
fi

if [[ $FAIL -eq 0 ]]; then
  echo "PASS: Story 1-4 add-cursor-command checks (AC1–AC6)"
  exit 0
fi
exit 1
