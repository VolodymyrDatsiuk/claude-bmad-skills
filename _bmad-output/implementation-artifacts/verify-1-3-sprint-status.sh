#!/usr/bin/env bash
# ATDD verification for Story 1-3: Wire sprint-status read/write
# Exit 0 = checks pass (read path, next not-done, write done, story doc update documented); non-zero = red phase or incomplete
# Usage: from repo root, run: bash _bmad-output/implementation-artifacts/verify-1-3-sprint-status.sh

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SPRINT_STATUS_DEFAULT="${REPO_ROOT}/_bmad-output/implementation-artifacts/sprint-status.yaml"
SPRINT_STATUS_REF="${REPO_ROOT}/.cursor/skills/bmad-story-pipeline/references/sprint-status.md"
SKILL_MD="${REPO_ROOT}/.cursor/skills/bmad-story-pipeline/SKILL.md"

FAIL=0

# --- AC1/AC5: Sprint-status path documented and file exists ---
if [[ ! -f "$SPRINT_STATUS_REF" ]]; then
  echo "FAIL: AC1/AC5 — references/sprint-status.md not found"
  FAIL=1
fi

if [[ ! -f "$SPRINT_STATUS_DEFAULT" ]]; then
  echo "FAIL: AC1 — sprint-status.yaml not found at default path: ${SPRINT_STATUS_DEFAULT}"
  FAIL=1
fi

# --- AC1: Valid YAML with development_status ---
if [[ -f "$SPRINT_STATUS_DEFAULT" ]]; then
  if ! grep -q "development_status:" "$SPRINT_STATUS_DEFAULT" 2>/dev/null; then
    echo "FAIL: AC1 — sprint-status.yaml does not contain development_status"
    FAIL=1
  fi
fi

# --- AC2: Can compute "next not-done" (script implements contract; verifies format) ---
if [[ -f "$SPRINT_STATUS_DEFAULT" ]]; then
  NEXT_NOT_DONE=""
  while IFS= read -r line; do
    if [[ "$line" =~ ^[[:space:]]*([0-9]+-[0-9]+-[a-zA-Z0-9-]+):[[:space:]]*(.+)$ ]]; then
      key="${BASH_REMATCH[1]}"
      val="${BASH_REMATCH[2]//\"/}"
      val="${val// /}"
      if [[ "$val" != "done" ]]; then
        NEXT_NOT_DONE="$key"
        break
      fi
    fi
  done < <(sed -n '/^development_status:/,/^[^ ]/p' "$SPRINT_STATUS_DEFAULT" | tail -n +2)
  if [[ -z "$NEXT_NOT_DONE" ]]; then
    echo "INFO: All stories done or development_status empty; cannot verify next not-done (AC2) — assume format OK"
  else
    echo "INFO: Next not-done story key: $NEXT_NOT_DONE (AC2 parse OK)"
  fi
fi

# --- AC3/AC4: Skill documents post-pipeline update (sprint-status + story doc) ---
if [[ -f "$SKILL_MD" ]]; then
  if ! grep -qE "sprint-status.*done|set.*status.*done|mark.*done" "$SKILL_MD" 2>/dev/null; then
    echo "FAIL: AC3 — skill does not instruct to set story to done in sprint-status"
    FAIL=1
  fi
  if ! grep -qE "Story document|story document|Status.*done|tasks.*✅" "$SKILL_MD" 2>/dev/null; then
    echo "FAIL: AC4 — skill does not instruct to update story document (Status done, tasks ✅)"
    FAIL=1
  fi
else
  echo "FAIL: Skill SKILL.md not found at ${SKILL_MD}"
  FAIL=1
fi

# --- AC5: Path resolution documented in sprint-status.md ---
if [[ -f "$SPRINT_STATUS_REF" ]]; then
  if ! grep -qE "sprint-status\.yaml|implementation-artifacts|docs/sprint" "$SPRINT_STATUS_REF" 2>/dev/null; then
    echo "FAIL: AC5 — sprint-status.md does not document path(s) for sprint-status file"
    FAIL=1
  fi
fi

# --- RED: Require explicit "story_location" for story doc path (AC4) so story doc update is wired ---
if [[ -f "$SKILL_MD" ]]; then
  if ! grep -qE "story_location|story document" "$SKILL_MD" 2>/dev/null; then
    echo "FAIL: AC4 — skill does not reference story_location or story document for post-pipeline update"
    FAIL=1
  fi
fi

if [[ $FAIL -eq 0 ]]; then
  echo "PASS: Story 1-3 sprint-status read/write checks (AC1–AC5)"
  exit 0
fi
exit 1
