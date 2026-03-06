# Story 1.1: Adapt workflow config for Cursor (skill + steps)

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a **developer/orchestrator**,
I want **the pipeline definition in the skill to use prompt-focused steps (description + prompt focus + expected return) instead of slash commands**,
so that **the orchestrator can read workflow-steps.md and derive a self-contained subagent prompt per step without requiring "run /bmad-…"**.

## Acceptance Criteria

1. **AC1:** `references/workflow-steps.md` in the skill defines each pipeline step with: step ID/title, short description, **prompt focus** (what the subagent must achieve), and **expected return** (e.g. story ID and created files, or pass/fail + issues).
2. **AC2:** No step instructs the subagent to "run `/bmad-…`" or similar slash command; each step is an **outcome** the subagent achieves using project files and `_bmad/` workflows as needed.
3. **AC3:** The orchestrator (or any consumer) can read this file and, for each step, derive a subagent prompt that produces the intended outcome (create story, generate ATDD tests, development, code review, trace coverage).
4. **AC4:** Pipeline order and step list remain consistent with current design (Create User Story → ATDD → Development → Code Review → Trace Test Coverage); only the representation of each step changes from "command" to "prompt focus + return".

## Tasks / Subtasks

- [x] Task 1 (AC: 1, 2): Rewrite each step in workflow-steps.md to prompt-focused format
  - [x] 1.1 Replace "Command: /bmad-…" with "Prompt focus:" and "Expected return:" per step
  - [x] 1.2 Ensure step description clarifies the outcome (e.g. "Create user story file for {STORY_ID} from planning docs")
- [x] Task 2 (AC: 3): Add brief "Subagent prompt (derived)" or "Prompt focus" text per step so orchestrator can build prompts without interpreting commands
  - [x] 2.1 Document expected return format (e.g. "Story ID, Title, Created files") so step completion can be validated
- [x] Task 3 (AC: 4): Preserve pipeline order and step count; add note on "yolo" mode if applicable
  - [x] 3.1 Keep Post-Pipeline and Customization sections aligned with new step format

## Dev Notes

- **Relevant architecture patterns:** Pipeline defined in skill at `references/workflow-steps.md`; one subagent per step; steps are self-contained outcomes (see project-context.md § Cursor Story Delivery Pipeline).
- **Source tree:** `.cursor/skills/bmad-story-pipeline/references/workflow-steps.md` (project skill) — or the path documented in sprint-status / project-context for the pipeline skill.
- **Testing:** After edit, verify that the skill's SKILL.md (or orchestrator command) can read workflow-steps.md and construct a prompt for "Create User Story" that does not reference any slash command.

### Project Structure Notes

- Skill lives under `.cursor/skills/bmad-story-pipeline/` (or `skills/bmad-story-pipeline/` per project layout).
- `references/workflow-steps.md` is the single source of truth for pipeline steps; orchestrator reads it to drive subagent invocations.
- Alignment: implementation-plan-story-delivery.md § "Order of implementation" puts workflow config (this story) first.

### References

- [Source: _bmad-output/planning-artifacts/implementation-plan-story-delivery.md § Step 2]
- [Source: _bmad-output/planning-artifacts/epics.md § Epic 1, Story 1.1]
- [Source: _bmad-output/project-context.md § Cursor Story Delivery Pipeline]
- [Source: .cursor/skills/bmad-story-pipeline/references/workflow-steps.md — current format to adapt]

## Dev Agent Record

### Agent Model Used

(Cursor agent; dev-story workflow.)

### Debug Log References

(Optional.)

### Completion Notes List

- Rewrote `.cursor/skills/bmad-story-pipeline/references/workflow-steps.md` to prompt-focused format: each of the 5 steps now has Description, Prompt focus, and Expected return (no slash commands).
- Orchestrator can derive subagent prompts from Prompt focus and validate outcomes via Expected return.
- Pipeline order unchanged: Create User Story → ATDD → Development → Code Review → Trace Test Coverage. Post-Pipeline and Customization sections updated; "yolo" mode noted in intro.
- Verified with `verify-1-1-workflow-config.sh`: PASS.

### File List

- `.cursor/skills/bmad-story-pipeline/references/workflow-steps.md` (modified)
- `.cursor/skills/bmad-story-pipeline/SKILL.md` (modified — orchestrator now uses Prompt focus + Expected return from workflow-steps.md)
