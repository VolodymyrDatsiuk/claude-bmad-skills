# ATDD Checklist: Story 1-3 — Wire sprint-status read/write

**Story ID:** 1-3  
**Generated:** 2026-03-06  
**Purpose:** Failing acceptance checks (TDD red). All must pass after story implementation.

---

## AC1: Read sprint-status from configured path

The system reads `sprint-status.yaml` (or configured path) to get the list of stories and their statuses.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 1.1 | Sprint-status path is documented (e.g. in references/sprint-status.md or skill) | ⬜ | |
| 1.2 | Default or configured path exists and is a valid YAML file with story statuses | ⬜ | |
| 1.3 | Pipeline/skill instructs orchestrator to read sprint-status from the resolved path | ⬜ | |

**AC1 Pass:** All 1.1–1.3 checked ✅

---

## AC2: Resolve "next not-done" story

When no story ID is provided, the system resolves the first story whose status is not `done`.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 2.1 | Procedure or code exists to parse `development_status` (or equivalent) from sprint-status | ⬜ | |
| 2.2 | Procedure or code returns the first story key whose status is not `done` (e.g. ready-for-dev, in-progress, review, backlog) | ⬜ | |
| 2.3 | Story ID derived from key (e.g. `1-3` from `1-3-wire-sprint-status`) is documented or implemented | ⬜ | |

**AC2 Pass:** All 2.1–2.3 checked ✅

---

## AC3: Write story status to done on pipeline success

When the pipeline completes successfully, the system sets that story's entry to `done` in sprint-status and persists the file.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 3.1 | Skill or pipeline post-step instructs to set the story's status to `done` in sprint-status | ⬜ | |
| 3.2 | Procedure or code can update the story key's value to `done` and write the file (persist) | ⬜ | |
| 3.3 | Verification script or manual run confirms the file is updated and persisted | ⬜ | |

**AC3 Pass:** All 3.1–3.3 checked ✅

---

## AC4: Update story document on success

When the pipeline completes successfully, the system updates the story document (Status → done, tasks → ✅) when specified.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 4.1 | Skill or pipeline post-step instructs to update story document (Status: done, mark tasks ✅) | ⬜ | |
| 4.2 | Story document path is resolved (e.g. from story_location + story ID or story key) | ⬜ | |
| 4.3 | Procedure or verification confirms story file can be updated (Status and task checkboxes) | ⬜ | |

**AC4 Pass:** All 4.1–4.3 checked ✅

---

## AC5: Configurable sprint-status path

Sprint-status path is configurable (e.g. from sprint-status reference, skill, or default).

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 5.1 | Path resolution order or default is documented (e.g. sprint-status.md lists paths to try) | ⬜ | |
| 5.2 | Default path is `_bmad-output/implementation-artifacts/sprint-status.yaml` or documented equivalent | ⬜ | |

**AC5 Pass:** All 5.1–5.2 checked ✅

---

## Verification

- **Sprint-status reference:** `.cursor/skills/bmad-story-pipeline/references/sprint-status.md`
- **Sprint-status file:** `_bmad-output/implementation-artifacts/sprint-status.yaml` (or path from reference)
- **Automated check:** Run `verify-1-3-sprint-status.sh` from repo root; exit 0 = all automated checks pass (red until implementation complete).
