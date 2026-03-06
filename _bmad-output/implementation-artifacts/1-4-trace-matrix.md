# Traceability Matrix: Story 1-4 — Add Cursor command

**Story ID:** 1-4  
**Generated:** 2026-03-06  
**Gate:** PASS

---

## AC → Test → Implementation

| AC | Requirement | ATDD / Test | Implementation | Traced |
|----|-------------|-------------|----------------|--------|
| AC1 | Cursor command exists and is invokable | 1-4-add-cursor-command-atdd-checklist § AC1 (1.1–1.2); verify-1-4-add-cursor-command.sh (command file exists) | .cursor/commands/bmad-story-deliver.md with name + description | ✅ |
| AC2 | Optional story ID; next not-done from sprint-status | ATDD § AC2 (2.1–2.3); verify script (story ID, sprint-status, next not-done in command content) | Command §1: resolve story ID from arg or sprint-status; first story key not done | ✅ |
| AC3 | Load pipeline from workflow-steps.md; execute in order | ATDD § AC3 (3.1–3.2); verify script (workflow-steps reference, in order) | Command §3: read workflow-steps.md; §4: execute five steps in order | ✅ |
| AC4 | One subagent per step; step prompts; substitute; wait; stop on failure | ATDD § AC4 (4.1–4.4); verify script (step-prompts, STORY_ID/story_location, subagent/task, stop on failure) | Command §3–4: step-prompts.md, substitute STORY_ID/story_location, mcp_task/subagent, wait, stop on failure | ✅ |
| AC5 | On success update sprint-status and story doc | ATDD § AC5 (5.1–5.3); verify script (done, sprint-status, story document) | Command §5: set story to done in sprint-status, persist; story doc Status done, tasks ✅ | ✅ |
| AC6 | E2E invocation runs pipeline and updates status | ATDD § AC6 (6.1–6.2); verify script exit 0 when command implements AC1–AC5 | verify-1-4-add-cursor-command.sh PASS; command describes full flow | ✅ |

---

## Coverage

- **ACs total:** 6  
- **ACs with test + implementation:** 6  
- **Coverage:** 100%

---

## Verification

- `verify-1-4-add-cursor-command.sh`: **PASS** (exit 0)

---

## Gate Decision

**PASS** — All acceptance criteria traced to ATDD checks and implementation; automated verification script passes.
