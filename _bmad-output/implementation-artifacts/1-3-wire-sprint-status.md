# Story 1.3: Wire sprint-status read/write

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a **developer/orchestrator**,
I want **the pipeline to read sprint-status for "next not-done story" and write the story as done on success**,
so that **the orchestrator can resolve story ID when no arg is provided and persist completion (sprint-status + story doc)**.

## Acceptance Criteria

1. **AC1:** The system reads `sprint-status.yaml` (or configured path from skill/sprint-status) to get the list of stories and their statuses.
2. **AC2:** When no story ID is provided, the system resolves the "next not-done" story (first story whose status is not `done`, e.g. `ready-for-dev`, `in-progress`, `review`, `backlog`).
3. **AC3:** When the pipeline completes successfully for a story, the system sets that story's key to `done` in sprint-status and persists the file.
4. **AC4:** When the pipeline completes successfully, the system updates the story document (set Status to `done`, mark all tasks with ✅) when specified by the pipeline definition.
5. **AC5:** Sprint-status path is configurable (e.g. from sprint-status file itself, skill reference, or default `_bmad-output/implementation-artifacts/sprint-status.yaml`).

## Tasks / Subtasks

- [x] Task 1 (AC: 1, 5): Define and document sprint-status path resolution
  - [x] 1.1 Document where sprint-status path is read from (sprint-status.md reference, skill, or default)
  - [x] 1.2 Implement or document read of sprint-status.yaml from the resolved path
- [x] Task 2 (AC: 2): Implement "next not-done" story resolution
  - [x] 2.1 Parse development_status (or equivalent) to get story keys and statuses
  - [x] 2.2 Return first story key whose status is not `done` (respect story_order if defined)
- [x] Task 3 (AC: 3): Implement write of story status to done on pipeline success
  - [x] 3.1 Update the story's entry in sprint-status to `done` and write the file
- [x] Task 4 (AC: 4): Update story document on success when specified
  - [x] 4.1 Set story file Status to `done` and mark all tasks with ✅ when pipeline post-step specifies it

## Dev Notes

- **Relevant architecture:** Sprint status at `_bmad-output/implementation-artifacts/sprint-status.yaml`; story_location in same file; keys like `1-3-wire-sprint-status`; status values: backlog, ready-for-dev, in-progress, review, done.
- **Source:** `_bmad-output/planning-artifacts/implementation-plan-story-delivery.md` § Step 4; epics.md § Story 1.3.
- **Testing:** Verify read (next not-done) and write (mark done) with existing sprint-status; ensure story doc update works when story file exists.

### References

- [Source: _bmad-output/planning-artifacts/implementation-plan-story-delivery.md § Step 4]
- [Source: _bmad-output/planning-artifacts/epics.md § Epic 1, Story 1.3]
- [Source: _bmad-output/implementation-artifacts/sprint-status.yaml]
- [Source: .cursor/skills/bmad-story-pipeline/references/sprint-status.md]

## Dev Agent Record

### Agent Model Used

(Cursor agent; BMAD story pipeline.)

### Completion Notes List

- Updated `.cursor/skills/bmad-story-pipeline/references/sprint-status.md`: path resolution order, story_location for story docs, explicit "next not-done" algorithm (parse development_status, first key where value != done), persist file and story doc path pattern.
- Updated `.cursor/skills/bmad-story-pipeline/SKILL.md` Post-Pipeline: explicit sprint-status path from references, persist file; story document path from story_location + {STORY_ID}-*.md.
- Verification: `verify-1-3-sprint-status.sh` passes (AC1–AC5).

### File List

- `.cursor/skills/bmad-story-pipeline/references/sprint-status.md` (modified)
- `.cursor/skills/bmad-story-pipeline/SKILL.md` (modified)
- `_bmad-output/implementation-artifacts/verify-1-3-sprint-status.sh` (created)
- `_bmad-output/implementation-artifacts/1-3-wire-sprint-status-atdd-checklist.md` (created)
