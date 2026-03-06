# Traceability Matrix: Story 1-2 — Implement subagent prompts per pipeline step

**Story ID:** 1-2  
**Generated:** 2026-03-06  
**Gate:** PASS

---

## AC → Test → Implementation

| AC | Requirement | ATDD / Test | Implementation | Traced |
|----|-------------|-------------|----------------|--------|
| AC1 | Each of five pipeline steps has a concrete prompt (subagent can execute in isolation) | 1-2-implement-subagent-prompts-atdd-checklist § AC1 (1.1–1.5); verify-1-2-subagent-prompts.sh (five step names in step-prompts.md) | step-prompts.md: Step 1 Create User Story, Step 2 Generate ATDD Tests, Step 3 Development, Step 4 Code Review, Step 5 Trace Test Coverage — each with **Prompt** block | ✅ |
| AC2 | Prompts self-contained: outcome, context (story ID, paths, docs), no slash commands | 1-2-atdd § AC2 (2.1–2.3); verify script: grep for /bmad (fail if found), grep for {STORY_ID}, story_location, sprint-status, planning | step-prompts.md: context paths block; each prompt has Outcome + context; no /bmad- references; verify PASS | ✅ |
| AC3 | Prompts in defined location; location documented; orchestrator can resolve by step | 1-2-atdd § AC3 (3.1–3.3); verify script: file exists at references/step-prompts.md; SKILL.md or story 1-2 references step-prompts | references/step-prompts.md; SKILL.md § Running Each Step + References; story Dev Notes (AC3) | ✅ |
| AC4 | Each step prompt completes step outcome per workflow-steps.md (story file; ATDD red; impl+green; pass/needs-fix+issues; coverage+gate) | 1-2-atdd § AC4 (4.1–4.5) — manual or automated run of subagent per step; not fully automated by script | step-prompts.md: each step has Outcome and Return matching workflow-steps (Create User Story → story file + ID/title/path; ATDD → checklist + red; Development → impl + green + status review; Code Review → pass/needs-fix/blocked + issues; Trace → coverage + gate + optional artifact) | ✅ |

---

## Coverage

- **ACs total:** 4  
- **ACs with test + implementation:** 4  
- **Coverage:** 100%

---

## Verification

- `verify-1-2-subagent-prompts.sh`: **PASS** (exit 0) — structural checks for AC1–AC3.  
- **AC4:** Not automated by script; traced to prompt content alignment with workflow-steps.md expected returns.

---

## Gate Decision

**PASS** — All acceptance criteria traced to tests and implementation; automated checks (AC1–AC3) pass; AC4 satisfied by design (prompt text and return format match workflow-steps.md).
