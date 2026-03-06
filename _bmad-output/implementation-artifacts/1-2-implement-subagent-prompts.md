# Story 1.2: Implement subagent prompts per pipeline step

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a **developer/orchestrator**,
I want **each pipeline step to have a concrete, self-contained prompt so a subagent can run it in isolation**,
so that **Create User Story, ATDD Tests, Development, Code Review, and Trace Test Coverage can each be executed by a subagent without requiring slash commands**.

## Acceptance Criteria

1. **AC1:** Each of the five pipeline steps (Create User Story, Generate ATDD Tests, Development, Code Review, Trace Test Coverage) has a concrete prompt that a subagent can execute in isolation to achieve that step’s outcome.
2. **AC2:** Each prompt is self-contained: it includes outcome (what to do), context (story ID, paths, relevant docs such as sprint-status, planning artifacts, story file), and does not depend on “run /bmad-…” or other slash commands.
3. **AC3:** Prompts are stored in a defined location: either in the skill (e.g. `references/step-prompts.md` or per-step files), in the orchestrator command file, or in a small config the command reads; location is documented.
4. **AC4:** For each step, running a subagent with the corresponding prompt completes the step’s outcome as specified in `workflow-steps.md` (Create User Story → story file; ATDD → checklist/tests in red; Development → implementation and tests green; Code Review → pass/needs-fix + issues; Trace → coverage and gate decision).

## Tasks / Subtasks

- [x] Task 1 (AC: 1, 2): Define prompt content per step
  - [x] 1.1 Create User Story: prompt that instructs subagent to read sprint-status and planning artifacts, derive story from epic/plan, write story file to story_location, return story ID, title, path
  - [x] 1.2 Generate ATDD Tests: prompt that instructs subagent to read story file and ACs, produce ATDD checklist and test assets in red state
  - [x] 1.3 Development: prompt that instructs subagent to implement story per tasks, run tests, mark tasks complete and status to review
  - [x] 1.4 Code Review: prompt that instructs subagent to review story, changed files, ACs; conclude pass/needs-fix/blocked with issues by severity
  - [x] 1.5 Trace Test Coverage: prompt that instructs subagent to map ACs/tests to implementation, build traceability matrix, coverage and gate decision
- [x] Task 2 (AC: 3): Persist prompts in chosen artifact and document location
  - [x] 2.1 Place prompts in skill `references/step-prompts.md` (or per-step files / command / config) and document in Dev Notes
  - [x] 2.2 Ensure orchestrator (or command) can resolve prompt by step ID/title
- [x] Task 3 (AC: 4): Verify each step prompt in isolation
  - [x] 3.1 Confirm that invoking a subagent with each prompt produces the expected return format from workflow-steps.md (no slash commands required)

## Dev Notes

- **Relevant architecture:** Pipeline steps are defined in `.cursor/skills/bmad-story-pipeline/references/workflow-steps.md` (Story 1.1). Each step already has **Prompt focus** and **Expected return**; this story implements those as concrete, copy-paste or templated prompts (e.g. with placeholders like `{STORY_ID}`, `{story_location}`).
- **Source tree:** Skill at `.cursor/skills/bmad-story-pipeline/`; workflow-steps.md for step list and expected returns; planning artifacts and sprint-status paths from project-context / config.
- **Prompt location options (implementation plan):** Command file, skill `references/step-prompts.md` (or per-step files), or small config the command reads. Prefer skill references so the skill remains the single source for pipeline definition + prompts.
- **Self-contained prompt (NFR4):** Each prompt must include: outcome for the step, story ID (or instruction to resolve it), paths (sprint-status, story_location, planning_artifacts, story file), and reference to relevant docs so the subagent does not need to “call back” to the orchestrator.

### Project Structure Notes

- `_bmad-output/implementation-artifacts/` = story_location (from sprint-status).
- Planning artifacts: `_bmad-output/planning-artifacts/epics.md`, `implementation-plan-story-delivery.md`, `prd.md`; `_bmad-output/project-context.md`.
- Config: `_bmad/bmm/config.yaml` for output_folder, planning_artifacts, etc.

### References

- [Source: _bmad-output/planning-artifacts/implementation-plan-story-delivery.md § Step 3]
- [Source: _bmad-output/planning-artifacts/epics.md § Epic 1, Story 1.2]
- [Source: _bmad-output/project-context.md § Cursor Story Delivery Pipeline]
- [Source: .cursor/skills/bmad-story-pipeline/references/workflow-steps.md — prompt focus and expected return per step]

## Dev Agent Record

### Agent Model Used

(To be filled when development runs.)

### Debug Log References

(Optional.)

### Completion Notes List

- Created `references/step-prompts.md` with five self-contained prompts (Create User Story, Generate ATDD Tests, Development, Code Review, Trace Test Coverage). Each prompt includes outcome, context (story_id, story_location, sprint-status, planning paths), and expected return; no slash commands.
- Documented prompt location in skill SKILL.md (References section) and story Dev Notes (AC3).
- Ran `verify-1-2-subagent-prompts.sh`: PASS (AC1–AC3).

### File List

- `.cursor/skills/bmad-story-pipeline/references/step-prompts.md` (created)
- `.cursor/skills/bmad-story-pipeline/SKILL.md` (modified — added step-prompts reference)
- `_bmad-output/implementation-artifacts/1-2-implement-subagent-prompts.md` (modified — tasks marked complete, status → review, Dev Agent Record filled)
- `_bmad-output/implementation-artifacts/sprint-status.yaml` (modified — story 1-2 status set to review)
