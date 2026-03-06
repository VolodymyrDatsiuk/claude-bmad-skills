# Implementation Plan: BMAD Story Delivery Pipeline for Cursor

**Source:** Brainstorming session 2026-03-06, project-context.md  
**Scope:** One-command story delivery (create → dev → QA → review → auto-fix → status) in Cursor; no worktree/epic in this phase.

---

## Design Summary

- **Entry point:** One Cursor command (e.g. `bmad-story-deliver`); story from arg (e.g. `1.1`) or next not-done from `sprint-status.yaml`.
- **Orchestration:** Resolve story ID → read workflow steps (from skill `references/workflow-steps.md`) → for each step run **one subagent** with step-specific prompt → on success, update sprint-status to done. Steps skippable (config or user override).
- **Step execution:** One subagent per step (foreground, sequential). Prompt = outcome for that step; no “run slash command”; subagent uses project files and `_bmad/` workflows as needed.
- **Isolation:** First version = current branch (no worktree). Worktree and epic batch = phase 2.

---

## Implementation Steps (in order)

### 1. Add Cursor command: story-delivery orchestrator

**Goal:** Single command that runs the full pipeline.

**Artifact:** `.cursor/commands/bmad-story-deliver.md` (or equivalent).

**Behaviour:**
- Parse optional story ID argument (e.g. `1.1`); if missing, read `sprint-status.yaml` and resolve “next not-done” story.
- Load pipeline definition from the skill’s `references/workflow-steps.md` (or embedded reference).
- For each enabled step (respecting skips from config or user): launch **one subagent** with the step’s prompt; wait for completion; on failure, stop or escalate per policy.
- On full success: update `sprint-status.yaml` (story → done) and story document status/tasks as needed.

**Acceptance:** Invoking the command with a story ID (or no arg when sprint-status exists) runs the pipeline end-to-end and updates status.

---

### 2. Adapt workflow config for Cursor (skill + steps)

**Goal:** Pipeline definition lives in the skill; steps are “prompt + outcome”, not slash commands.

**Artifacts:**
- Reuse or extend skill: `skills/bmad-story-pipeline/` (e.g. `SKILL.md`, `references/workflow-steps.md`).
- In `references/workflow-steps.md`: replace Claude slash commands with **step description + prompt focus + expected return**. No “run `/bmad-…`”; each step is an outcome the subagent must achieve using project and `_bmad/` as needed.

**Content per step (pattern):**
- Step ID, title, short description.
- **Prompt focus:** what the subagent must do (e.g. “Create user story file for {STORY_ID} from planning docs”).
- **Expected return:** e.g. story ID, created files, or “pass/fail + issues”.

**Acceptance:** Orchestrator can read this file and, for each step, derive a subagent prompt that produces the intended outcome.

---

### 3. Implement subagent prompts per pipeline step

**Goal:** Each pipeline step has a concrete prompt so a subagent can run it in isolation.

**Steps to cover (from existing workflow-steps):**
1. **Create User Story** — create story file with context from planning docs; return story ID, title, created files.
2. **Generate ATDD Tests** — generate failing acceptance tests (TDD red); return ATDD checklist and test files.
3. **Development** — implement story to pass tests (TDD green); return modified files, summary.
4. **Code Review** — adversarial code review; return conclusion (pass/needs-fix), issues by severity.
5. **Trace Test Coverage** — traceability matrix and quality gate; return coverage %, gate decision.

**Artifacts:** Prompts can live in the command file, in the skill (e.g. `references/step-prompts.md` or per-step files), or in a small config the command reads. Each prompt must be self-contained (outcome + context: story ID, paths, relevant docs).

**Acceptance:** For each step, running a subagent with the corresponding prompt completes the step’s outcome without requiring slash commands.

---

### 4. Wire sprint-status read/write

**Goal:** Orchestrator uses sprint-status for “next story” and writes “done”.

**Behaviour:**
- **Read:** Parse `sprint-status.yaml` (or configured path) to get “next not-done story” when no story ID is provided.
- **Write:** When pipeline completes successfully, set that story’s status to done and persist (and update story document status/tasks if specified).

**Acceptance:** With no args, command picks next not-done story from sprint-status; on success, that story is marked done in sprint-status (and story doc if applicable).

---

### 5. (Later) Worktree and epic variants

**Deferred:** Same pipeline logic, but with different isolation/scope (story worktree, epic worktree). Not in initial implementation plan.

---

## File / artifact map

| Item                         | Location / note                                      |
|------------------------------|------------------------------------------------------|
| Orchestrator command         | `.cursor/commands/bmad-story-deliver.md` (or name of choice) |
| Pipeline definition (steps)  | `skills/bmad-story-pipeline/references/workflow-steps.md`   |
| Step prompts                 | In command, or `skills/bmad-story-pipeline/references/`     |
| Sprint status                | Configurable path, e.g. `sprint-status.yaml` in repo root or `_bmad-output/` |
| Existing skill               | `skills/bmad-story-pipeline/` (reuse and adapt)      |

---

## Dependencies

- Cursor commands and subagents available.
- Skill loadable by the command (or equivalent logic in command).
- `_bmad/` workflows and project layout as in project-context.md (e.g. `_bmad-output/`, planning-artifacts).
- Sprint-status schema and story IDs agreed (e.g. `1.1`, `2.3`) and documented.

---

## Order of implementation

1. **Workflow config (step 2)** — define steps as prompt-focused outcomes in `workflow-steps.md` so the orchestrator has a single source of truth.
2. **Subagent prompts (step 3)** — implement one prompt per pipeline step and verify in isolation.
3. **Sprint-status (step 4)** — implement read (next story) and write (done); keep schema simple.
4. **Orchestrator command (step 1)** — implement the command that ties 2–4 together: resolve story → loop steps (subagent per step) → update status.

This order allows testing “resolve story + one step” before full pipeline, and avoids blocking on command wiring while steps and config are still being defined.
