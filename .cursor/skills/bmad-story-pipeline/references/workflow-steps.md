# BMAD Story Pipeline Workflow Steps

## Pipeline Configuration

Execute the following steps in order using the task tool (subagent).
Each step is defined by **prompt focus** (what the subagent must achieve) and **expected return** (for validation). Use "yolo" mode for auto-approval when invoking the pipeline.

---

### Step 1: Create User Story

- **Description:** Create the user story file for `{STORY_ID}` using planning docs (epics, PRD, implementation plan) and project context; place it in the implementation-artifacts (or story_location from sprint-status).
- **Prompt focus:** Create the story document for `{STORY_ID}`: read sprint-status and planning artifacts, derive story title and acceptance criteria from the epic/plan, write the story file with Story, ACs, Tasks/Subtasks, Dev Notes, and set Status to ready-for-dev.
- **Expected return:** Story ID, story title, path to created story file (and optionally list of source files used).

---

### Step 2: Generate ATDD Tests

- **Description:** Generate failing acceptance tests (TDD red phase) for `{STORY_ID}` from the story file and acceptance criteria.
- **Prompt focus:** For `{STORY_ID}`, read the story file and ACs; produce an ATDD checklist and any test assets (e.g. scripts or specs) that encode acceptance checks; tests must fail before implementation (red phase).
- **Expected return:** ATDD checklist path (and any test file paths); confirmation that checks are in "red" state for the current codebase.

---

### Step 3: Development

- **Description:** Implement the story for `{STORY_ID}` so that acceptance tests pass (TDD green phase); follow story tasks and dev-story workflow.
- **Prompt focus:** For `{STORY_ID}`, load the story file and dev-story workflow; implement each task/subtask in order (red–green–refactor), run tests and validations, then mark tasks complete and update story status to review.
- **Expected return:** List of modified/created files (paths relative to repo root); short summary of changes; any issues or blockers encountered.

---

### Step 4: Code Review

- **Description:** Perform an adversarial code review of the implementation for `{STORY_ID}` and report findings.
- **Prompt focus:** For `{STORY_ID}`, review the story file, changed files, and acceptance criteria; identify defects, risks, and improvements; conclude with pass, needs-fix, or blocked and list issues by severity.
- **Expected return:** Conclusion (pass / needs-fix / blocked); list of issues with severity (e.g. High/Medium/Low) and, if needed, suggested fixes.

---

### Step 5: Trace Test Coverage

- **Description:** Produce traceability from requirements/tests to implementation and a quality gate decision for `{STORY_ID}`.
- **Prompt focus:** For `{STORY_ID}`, map story ACs and tests to implemented artifacts; build a traceability matrix (or equivalent); compute coverage and decide quality gate (e.g. pass/fail or go/no-go).
- **Expected return:** Coverage percentage (or equivalent metric); gate decision (e.g. pass/fail); optional path to traceability artifact.

---

## Post-Pipeline

After all steps complete:

1. Update **sprint-status.yaml**: set the story’s status to `done`.
2. Update the **story document**: set `Status:` to `done` and mark all tasks with ✅.

---

## Customization

To modify the pipeline:

- Add, remove, or reorder steps in this file (keep step IDs/titles clear).
- Adjust **Prompt focus** and **Expected return** per step so the orchestrator can derive subagent prompts and validate outcomes.
- "yolo" mode (auto-approval) can be noted in the pipeline runner (e.g. skill or command) when invoking these steps.
