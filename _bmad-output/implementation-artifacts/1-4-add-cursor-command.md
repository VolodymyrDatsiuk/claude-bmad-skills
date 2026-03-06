# Story 1.4: Add Cursor command (story-delivery orchestrator)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a **developer/orchestrator**,
I want **a single Cursor command that runs the full story delivery pipeline (create → ATDD → dev → review → trace)**,
so that **I can deliver a story end-to-end with one invocation, using one subagent per step and automatic status updates on success**.

## Acceptance Criteria

1. **AC1:** A Cursor command exists (e.g. `.cursor/commands/bmad-story-deliver.md`) that is invokable from the IDE.
2. **AC2:** The command accepts an optional story ID argument (e.g. `1-4` or `1.4`); when missing, the command reads `sprint-status.yaml` and resolves the "next not-done" story.
3. **AC3:** The command loads the pipeline definition from the skill's `references/workflow-steps.md` (or embedded reference) and executes each step in order.
4. **AC4:** For each enabled step, the command launches one subagent with that step's prompt (from `references/step-prompts.md`), waits for completion, and does not proceed to the next step if the step fails.
5. **AC5:** On full pipeline success, the command updates `sprint-status.yaml` (sets the story's status to `done`) and updates the story document (Status to `done`, all tasks marked ✅).
6. **AC6:** Invoking the command with a story ID (or no arg when sprint-status exists) runs the pipeline end-to-end and updates status as specified.

## Tasks / Subtasks

- [x] Task 1 (AC: 1): Create the Cursor command file
  - [x] 1.1 Create `.cursor/commands/bmad-story-deliver.md` (or equivalent name)
  - [x] 1.2 Define command description and how to pass optional story ID
- [x] Task 2 (AC: 2): Implement story ID resolution
  - [x] 2.1 Parse optional story ID from command args; normalize format (e.g. 1.4 → 1-4)
  - [x] 2.2 When no story ID: read sprint-status from configured path, resolve next not-done story
- [x] Task 3 (AC: 3, 4): Wire pipeline execution
  - [x] 3.1 Load workflow steps from skill `references/workflow-steps.md`
  - [x] 3.2 Load step prompts from `references/step-prompts.md`; substitute {STORY_ID} and {story_location}
  - [x] 3.3 For each step: invoke subagent with step prompt; wait for result; on failure stop and report
- [x] Task 4 (AC: 5): Implement post-pipeline status update
  - [x] 4.1 On success: set story key to `done` in sprint-status and persist file
  - [x] 4.2 On success: set story document Status to `done` and mark all tasks with ✅
- [x] Task 5 (AC: 6): Verify end-to-end
  - [x] 5.1 Document how to run the command with/without story ID; confirm pipeline runs and status updates

## Dev Notes

- **Relevant architecture:** Skill at `.cursor/skills/bmad-story-pipeline/`; workflow at `references/workflow-steps.md`; step prompts at `references/step-prompts.md`; sprint-status at `_bmad-output/implementation-artifacts/sprint-status.yaml`; story_location in sprint-status.
- **Source:** `_bmad-output/planning-artifacts/implementation-plan-story-delivery.md` § Step 1 (Add Cursor command); epics.md § Story 1.4.
- **Cursor commands:** Typically markdown with description and instructions; agent executes them. Use task tool or equivalent to run subagent per step with substituted prompt.
- **Testing:** Run command with story ID 1-4 (or a small story); confirm all steps run and sprint-status + story doc are updated on success.

### References

- [Source: _bmad-output/planning-artifacts/implementation-plan-story-delivery.md § Step 1]
- [Source: _bmad-output/planning-artifacts/epics.md § Epic 1, Story 1.4]
- [Source: .cursor/skills/bmad-story-pipeline/references/workflow-steps.md]
- [Source: .cursor/skills/bmad-story-pipeline/references/step-prompts.md]
- [Source: .cursor/skills/bmad-story-pipeline/references/sprint-status.md]

## Dev Agent Record

### Agent Model Used

(Cursor agent; BMAD story pipeline.)

### Completion Notes List

- Created `.cursor/commands/bmad-story-deliver.md`: single command that resolves story ID (arg or next not-done from sprint-status), loads workflow-steps and step-prompts, runs five steps via subagent with substituted prompts, stops on failure, and on success updates sprint-status and story document.
- Verification: `verify-1-4-add-cursor-command.sh` passes (AC1–AC6).

### File List

- `.cursor/commands/bmad-story-deliver.md` (created)
- `_bmad-output/implementation-artifacts/1-4-add-cursor-command-atdd-checklist.md` (created)
- `_bmad-output/implementation-artifacts/verify-1-4-add-cursor-command.sh` (created)
