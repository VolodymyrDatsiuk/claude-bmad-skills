#!/usr/bin/env bash
# ATDD verification for Story 1-2: Implement subagent prompts per pipeline step
# Exit 0 = structural checks (AC1–AC3) pass; non-zero = red phase or incomplete
# Usage: from repo root, run: bash _bmad-output/implementation-artifacts/verify-1-2-subagent-prompts.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SKILL_REF="${REPO_ROOT}/.cursor/skills/bmad-story-pipeline/references"
STEP_PROMPTS="${SKILL_REF}/step-prompts.md"

FAIL=0

# --- AC3/AC1: Prompts artifact exists in defined location ---
if [[ ! -f "$STEP_PROMPTS" ]]; then
  echo "FAIL: AC1/AC3 — step-prompts.md not found at ${STEP_PROMPTS}"
  FAIL=1
fi

if [[ $FAIL -eq 0 ]]; then
  # --- AC2: No slash commands in prompts ---
  if grep -qE '/bmad-|`/bmad-|run /bmad-|Command:.*bmad-' "$STEP_PROMPTS" 2>/dev/null; then
    echo "FAIL: AC2 — step-prompts.md contains slash command references (/bmad-...)"
    FAIL=1
  fi

  # --- AC1: Each of the five steps has a prompt (section or block) ---
  STEP_NAMES=(
    "Create User Story"
    "Generate ATDD Tests"
    "Development"
    "Code Review"
    "Trace Test Coverage"
  )
  for name in "${STEP_NAMES[@]}"; do
    if ! grep -qF "$name" "$STEP_PROMPTS" 2>/dev/null; then
      echo "FAIL: AC1 — step prompt missing for: $name"
      FAIL=1
    fi
  done

  # --- AC2: Prompts include outcome/context (minimal: contain placeholder or path hint) ---
  if ! grep -qE '\{STORY_ID\}|story_id|story_location|sprint-status|planning' "$STEP_PROMPTS" 2>/dev/null; then
    echo "FAIL: AC2 — step-prompts.md does not appear to include context (e.g. {STORY_ID}, paths, sprint-status)"
    FAIL=1
  fi
fi

# --- AC3: Location documented (skill or story references step-prompts) ---
SKILL_MD="${REPO_ROOT}/.cursor/skills/bmad-story-pipeline/SKILL.md"
STORY_12="${REPO_ROOT}/_bmad-output/implementation-artifacts/1-2-implement-subagent-prompts.md"
DOCUMENTED=0
if [[ -f "$SKILL_MD" ]] && grep -qE 'step-prompts|references/step-prompts' "$SKILL_MD" 2>/dev/null; then
  DOCUMENTED=1
fi
if [[ -f "$STORY_12" ]] && grep -qE 'step-prompts|references/step-prompts' "$STORY_12" 2>/dev/null; then
  DOCUMENTED=1
fi
if [[ $FAIL -eq 0 && $DOCUMENTED -eq 0 ]]; then
  echo "FAIL: AC3 — prompt location (step-prompts.md) not documented in skill or story 1-2"
  FAIL=1
fi

if [[ $FAIL -eq 0 ]]; then
  echo "PASS: Story 1-2 subagent prompts checks (AC1–AC3)"
  exit 0
fi
exit 1
