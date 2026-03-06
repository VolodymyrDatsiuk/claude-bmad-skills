# ATDD Checklist: Story 1-1 — Adapt workflow config for Cursor

**Story ID:** 1-1  
**Generated:** 2026-03-06  
**Purpose:** Failing acceptance checks (TDD red). All must pass after story implementation.

---

## AC1: Step format (ID/title, description, prompt focus, expected return)

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 1.1 | Each of the 5 steps has a step ID/title (e.g. "Step 1: Create User Story") | ⬜ | |
| 1.2 | Each step has a short description | ⬜ | |
| 1.3 | Each step has a **Prompt focus:** line (what the subagent must achieve) | ⬜ | No "Command: /bmad-…" |
| 1.4 | Each step has an **Expected return:** line (e.g. story ID + files, or pass/fail + issues) | ⬜ | |

**AC1 Pass:** All 1.1–1.4 checked ✅

---

## AC2: No slash commands

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 2.1 | File contains no line "Command: `/bmad-…`" or "Command: /bmad-…" | ⬜ | |
| 2.2 | No instruction to "run `/bmad-…`" or "run /bmad-…" | ⬜ | |
| 2.3 | Step text describes an **outcome** (create story, generate ATDD tests, etc.), not a command to run | ⬜ | |

**AC2 Pass:** All 2.1–2.3 checked ✅

---

## AC3: Derivable subagent prompt per step

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 3.1 | For each step, "Prompt focus" (or equivalent) is explicit so a consumer can build a subagent prompt without interpreting slash commands | ⬜ | |
| 3.2 | Expected return format is documented per step (e.g. "Story ID, Title, Created files") so step completion can be validated | ⬜ | |

**AC3 Pass:** All 3.1–3.2 checked ✅

---

## AC4: Pipeline order and step count unchanged

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 4.1 | Exactly 5 steps in order: Create User Story → Generate ATDD Tests → Development → Code Review → Trace Test Coverage | ⬜ | |
| 4.2 | Post-Pipeline section still describes: update sprint-status to done, update story document | ⬜ | |
| 4.3 | Customization section (if present) aligned with new step format; "yolo" mode noted if applicable | ⬜ | |

**AC4 Pass:** All 4.1–4.3 checked ✅

---

## Verification

- **Target file:** `.cursor/skills/bmad-story-pipeline/references/workflow-steps.md` (or `skills/bmad-story-pipeline/references/workflow-steps.md` per project layout).
- **Automated check:** Run `verify-1-1-workflow-config.sh` from repo root; exit 0 = all checks pass.
