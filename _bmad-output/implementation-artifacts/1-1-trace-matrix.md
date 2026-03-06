# Traceability Matrix: Story 1-1 — Adapt workflow config for Cursor

**Story ID:** 1-1  
**Generated:** 2026-03-06  
**Gate:** PASS

---

## AC → Test → Implementation

| AC | Requirement | ATDD / Test | Implementation | Traced |
|----|-------------|-------------|----------------|--------|
| AC1 | Step format: ID/title, description, prompt focus, expected return | 1-1-atdd-checklist § AC1 (1.1–1.4); verify-1-1-workflow-config.sh (Prompt focus, Expected return) | workflow-steps.md: each of 5 steps has Description, Prompt focus, Expected return | ✅ |
| AC2 | No step instructs "run /bmad-…"; outcome-focused | 1-1-atdd-checklist § AC2 (2.1–2.3); verify script grep for Command:/bmad, run /bmad | workflow-steps.md: no slash commands; verify script PASS | ✅ |
| AC3 | Orchestrator can derive subagent prompt per step | 1-1-atdd-checklist § AC3 (3.1–3.2) | workflow-steps.md: explicit Prompt focus + Expected return per step; SKILL.md uses them for subagent prompts | ✅ |
| AC4 | Pipeline order and step count unchanged | 1-1-atdd-checklist § AC4 (4.1–4.3); verify script (5 step titles in order) | workflow-steps.md: Create User Story → ATDD → Development → Code Review → Trace Test Coverage; Post-Pipeline, Customization aligned | ✅ |

---

## Coverage

- **ACs total:** 4  
- **ACs with test + implementation:** 4  
- **Coverage:** 100%

---

## Verification

- `verify-1-1-workflow-config.sh`: **PASS** (exit 0)

---

## Gate Decision

**PASS** — All acceptance criteria traced to tests and implementation; automated checks pass.
