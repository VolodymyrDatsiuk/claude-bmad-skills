# Step Prompts for BMAD Story Pipeline

Concrete, self-contained prompts for each pipeline step. A subagent can run any step in isolation using the prompt below (substitute `{STORY_ID}` and `{story_location}` with actual values). No slash commands required.

**Context paths (resolve from project):**

- **sprint-status:** `_bmad-output/implementation-artifacts/sprint-status.yaml` (or `docs/sprint/sprint-status.yaml`)
- **story_location:** `_bmad-output/implementation-artifacts` (from sprint-status or config)
- **planning artifacts:** `_bmad-output/planning-artifacts/epics.md`, `_bmad-output/planning-artifacts/implementation-plan-story-delivery.md`, `_bmad-output/planning-artifacts/prd.md`, `_bmad-output/project-context.md`
- **story file:** `{story_location}/{STORY_ID}-*.md` (e.g. `_bmad-output/implementation-artifacts/1-1-adapt-workflow-config.md`)

---

## Step 1: Create User Story

**Outcome:** Create the story document for `{STORY_ID}` and write it to story_location.

**Prompt:**

Achieve the following for story `{STORY_ID}`:

1. Read sprint-status from `_bmad-output/implementation-artifacts/sprint-status.yaml` and planning artifacts: `_bmad-output/planning-artifacts/epics.md`, `_bmad-output/planning-artifacts/implementation-plan-story-delivery.md`, `_bmad-output/planning-artifacts/prd.md`, and `_bmad-output/project-context.md`.
2. Derive the story title and acceptance criteria from the epic and implementation plan for `{STORY_ID}`.
3. Write the story file to `{story_location}` (e.g. `_bmad-output/implementation-artifacts/`) with: Story, Acceptance Criteria, Tasks/Subtasks, Dev Notes; set Status to `ready-for-dev`.
4. Use the story_location value from sprint-status when present (e.g. `_bmad-output/implementation-artifacts`).

Return: 1) Story ID 2) Story title 3) Path to created story file 4) Optionally, list of source files used.

---

## Step 2: Generate ATDD Tests

**Outcome:** Produce ATDD checklist and test assets in red state for `{STORY_ID}`.

**Prompt:**

Achieve the following for story `{STORY_ID}`:

1. Load the story file from `{story_location}` (e.g. `_bmad-output/implementation-artifacts/{STORY_ID}-*.md`). Resolve story_location from `_bmad-output/implementation-artifacts/sprint-status.yaml` if needed.
2. Read the story’s acceptance criteria (ACs).
3. Produce an ATDD checklist and any test assets (e.g. verification scripts or specs) that encode acceptance checks for the ACs.
4. Ensure checks are in "red" state (failing before implementation) for the current codebase.

Return: 1) Path to ATDD checklist 2) Any test/verification file paths 3) Confirmation that checks are in red state.

---

## Step 3: Development

**Outcome:** Implement the story so tests pass; mark tasks complete and set status to review.

**Prompt:**

Achieve the following for story `{STORY_ID}`:

1. Load the story file at `{story_location}/{STORY_ID}-*.md` (e.g. `_bmad-output/implementation-artifacts/1-1-adapt-workflow-config.md`). Use story_location from `_bmad-output/implementation-artifacts/sprint-status.yaml` if needed.
2. Follow the dev-story workflow: implement each task/subtask in order (red–green–refactor). Run tests and any verification scripts referenced in the story.
3. Mark each task/subtask complete in the story file and set the story Status to `review`.

Return: 1) List of modified/created files (paths relative to repo root) 2) Short summary of changes 3) Any issues or blockers encountered.

---

## Step 4: Code Review

**Outcome:** Review implementation and conclude pass / needs-fix / blocked with issues by severity.

**Prompt:**

Achieve the following for story `{STORY_ID}`:

1. Load the story file from `{story_location}` (e.g. `_bmad-output/implementation-artifacts/{STORY_ID}-*.md`) and read acceptance criteria. Resolve story_location from sprint-status at `_bmad-output/implementation-artifacts/sprint-status.yaml` if needed.
2. Review the changed files (from the story’s File List or implementation artifacts) and the ACs.
3. Identify defects, risks, and improvements. Conclude with one of: **pass**, **needs-fix**, or **blocked**.
4. List issues by severity (e.g. High / Medium / Low) and, if needed, suggested fixes.

Return: 1) Conclusion (pass / needs-fix / blocked) 2) List of issues with severity 3) Suggested fixes where applicable.

---

## Step 5: Trace Test Coverage

**Outcome:** Map ACs and tests to implementation; produce traceability matrix and quality gate decision.

**Prompt:**

Achieve the following for story `{STORY_ID}`:

1. Load the story file from `{story_location}` (e.g. `_bmad-output/implementation-artifacts/{STORY_ID}-*.md`). Use story_location from `_bmad-output/implementation-artifacts/sprint-status.yaml` when needed.
2. Map story ACs and tests (ATDD checklist, verification scripts) to implemented artifacts.
3. Build a traceability matrix (or equivalent document) showing coverage of ACs by tests and implementation.
4. Compute coverage (e.g. percentage or count) and decide quality gate: pass/fail or go/no-go.

Return: 1) Coverage percentage or equivalent metric 2) Gate decision (pass/fail) 3) Optional path to traceability artifact.
