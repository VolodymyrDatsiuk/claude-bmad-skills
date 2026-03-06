---
stepsCompleted: []
inputDocuments:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/implementation-plan-story-delivery.md
  - _bmad-output/project-context.md
  - _bmad-output/ROADMAP-BMAD-FOR-CURSOR.md
  - _bmad-output/brainstorming/brainstorming-session-2026-03-06.md
---

# claude-bmad-skills - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for claude-bmad-skills, decomposing the requirements from the PRD, implementation plan, project context, ROADMAP, and brainstorming session into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: The system shall provide a single Cursor command that runs the full story delivery pipeline (create → dev → QA → review → auto-fix → status).

FR2: The command shall accept an optional story ID argument (e.g. 1.1); when missing, the system shall resolve the "next not-done" story from sprint-status.yaml.

FR3: The orchestrator shall load the pipeline definition from the skill's references/workflow-steps.md (or embedded reference).

FR4: For each enabled step (respecting skips from config or user), the orchestrator shall launch one subagent with the step's prompt and wait for completion.

FR5: On full pipeline success, the system shall update sprint-status.yaml (mark story as done) and update story document status/tasks as specified.

FR6: The pipeline definition (workflow-steps.md) shall define each step as description + prompt focus + expected return; steps must not reference "run /bmad-…" slash commands.

FR7: The orchestrator shall be able to read workflow-steps.md and, for each step, derive a subagent prompt that produces the intended outcome.

FR8: Each pipeline step shall have a concrete, self-contained prompt so a subagent can run it in isolation: Create User Story, Generate ATDD Tests, Development, Code Review, Trace Test Coverage.

FR9: The system shall read sprint-status.yaml (or configured path) to get "next not-done story" when no story ID is provided.

FR10: When the pipeline completes successfully, the system shall set that story's status to done in sprint-status and persist; and update story document status/tasks if specified.

### NonFunctional Requirements

NFR1: The first version shall run on the current branch (no worktree); worktree and epic batch are deferred to phase 2.

NFR2: Pipeline steps shall be skippable via config or user override.

NFR3: On step failure, the orchestrator shall stop or escalate per policy (no silent continuation).

NFR4: Subagent prompts shall be self-contained (outcome + context: story ID, paths, relevant docs) so each step can run in isolation.

NFR5: The pipeline shall work with Cursor commands and subagents; the skill shall be loadable by the command or equivalent logic shall live in the command.

NFR6: The implementation shall use _bmad/ workflows and project layout as described in project-context (e.g. _bmad-output/, planning-artifacts).

NFR7: Sprint-status schema and story ID format (e.g. 1.1, 2.3) shall be agreed and documented.

### Additional Requirements

- Use _bmad/ workflows and project layout per project-context.md (output_folder, planning_artifacts, project_knowledge paths).
- Config is read from _bmad/bmm/config.yaml (project_name, output_folder, planning_artifacts, etc.).
- Skills live in skills/ (e.g. bmad-story-pipeline); pipeline definition in skill at references/workflow-steps.md.
- Conventional Commits and commitlint are enforced (user/rule configuration).
- Implementation order: (1) workflow config (workflow-steps.md), (2) subagent prompts per step, (3) sprint-status read/write, (4) orchestrator command.
- Orchestrator command artifact: .cursor/commands/bmad-story-deliver.md (or equivalent name).
- Step prompts may live in the command file, in the skill (e.g. references/step-prompts.md or per-step files), or in a small config the command reads.
- Sprint-status path shall be configurable (e.g. sprint-status.yaml in repo root or _bmad-output/).
- Dependencies: Cursor commands and subagents available; skill loadable; _bmad/ workflows and project layout as in project-context; sprint-status schema and story IDs documented.

### FR Coverage Map

(To be populated per story implementation.)

## Epic List

### Epic 1: Story delivery pipeline

Stories derived from implementation plan (implementation-plan-story-delivery.md) and implementation order.

- **Story 1.1:** Adapt workflow config for Cursor (skill + steps) — pipeline definition in `references/workflow-steps.md`, prompt-focused steps.
- **Story 1.2:** Implement subagent prompts per pipeline step — Create User Story, ATDD Tests, Development, Code Review, Trace Test Coverage.
- **Story 1.3:** Wire sprint-status read/write — next not-done story resolution and mark done on pipeline success.
- **Story 1.4:** Add Cursor command (story-delivery orchestrator) — single command runs full pipeline, one subagent per step.
- **Epic 1 retrospective:** Optional.
