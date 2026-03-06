# ATDD Checklist: Story 1-4 — Add Cursor command (story-delivery orchestrator)

**Story ID:** 1-4  
**Generated:** 2026-03-06  
**Purpose:** Failing acceptance checks (TDD red). All must pass after story implementation.

---

## AC1: Cursor command exists and is invokable

A Cursor command exists (e.g. `.cursor/commands/bmad-story-deliver.md`) that is invokable from the IDE.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 1.1 | File `.cursor/commands/bmad-story-deliver.md` (or equivalent) exists | ⬜ | |
| 1.2 | Command has a clear description so it appears in Cursor command palette / invocation | ⬜ | |

**AC1 Pass:** All 1.1–1.2 checked ✅

---

## AC2: Optional story ID and next not-done resolution

The command accepts an optional story ID argument (e.g. `1-4` or `1.4`); when missing, the command reads sprint-status and resolves the "next not-done" story.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 2.1 | Command instructions or description mention optional story ID (e.g. 1-4, 1.4) | ⬜ | |
| 2.2 | Command references reading sprint-status when no story ID is provided | ⬜ | |
| 2.3 | Command references resolving "next not-done" story from sprint-status | ⬜ | |

**AC2 Pass:** All 2.1–2.3 checked ✅

---

## AC3: Load pipeline definition and execute in order

The command loads the pipeline definition from the skill's `references/workflow-steps.md` and executes each step in order.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 3.1 | Command references `workflow-steps.md` (or skill references path) for pipeline definition | ⬜ | |
| 3.2 | Command instructs to execute steps in order (sequential, not parallel) | ⬜ | |

**AC3 Pass:** All 3.1–3.2 checked ✅

---

## AC4: One subagent per step with step prompt; stop on failure

For each enabled step, the command launches one subagent with that step's prompt, waits for completion, and does not proceed if the step fails.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 4.1 | Command references step prompts (e.g. `step-prompts.md` or equivalent) | ⬜ | |
| 4.2 | Command instructs to substitute {STORY_ID} and {story_location} in prompts | ⬜ | |
| 4.3 | Command instructs to run one subagent (or task/agent) per step and wait for result | ⬜ | |
| 4.4 | Command instructs to stop on step failure and not run later steps | ⬜ | |

**AC4 Pass:** All 4.1–4.4 checked ✅

---

## AC5: Post-pipeline update (sprint-status + story doc)

On full pipeline success, the command updates sprint-status (story → done) and story document (Status → done, tasks ✅).

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 5.1 | Command instructs to set story's status to `done` in sprint-status on success | ⬜ | |
| 5.2 | Command instructs to persist sprint-status file after update | ⬜ | |
| 5.3 | Command instructs to update story document: Status to `done`, all tasks marked ✅ | ⬜ | |

**AC5 Pass:** All 5.1–5.3 checked ✅

---

## AC6: End-to-end invocation

Invoking the command with a story ID (or no arg when sprint-status exists) runs the pipeline end-to-end and updates status as specified.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 6.1 | Verification script or manual run: command exists and contains required behaviour (AC1–AC5) | ⬜ | |
| 6.2 | Documented or verified: running command with story ID triggers full pipeline | ⬜ | |

**AC6 Pass:** All 6.1–6.2 checked ✅

---

## Verification

- **Command file:** `.cursor/commands/bmad-story-deliver.md` (or equivalent)
- **Skill workflow:** `.cursor/skills/bmad-story-pipeline/references/workflow-steps.md`
- **Step prompts:** `.cursor/skills/bmad-story-pipeline/references/step-prompts.md`
- **Sprint-status:** `_bmad-output/implementation-artifacts/sprint-status.yaml`
- **Automated check:** Run `verify-1-4-add-cursor-command.sh` from repo root; exit 0 = all automated checks pass (red until implementation complete).
