# ATDD Checklist: Story 1-2 — Implement subagent prompts per pipeline step

**Story ID:** 1-2  
**Generated:** 2026-03-06  
**Purpose:** Failing acceptance checks (TDD red). All must pass after story implementation.

---

## AC1: Concrete prompt per pipeline step

Each of the five pipeline steps has a concrete prompt that a subagent can execute in isolation to achieve that step's outcome.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 1.1 | Step 1 (Create User Story) has a concrete prompt | ⬜ | |
| 1.2 | Step 2 (Generate ATDD Tests) has a concrete prompt | ⬜ | |
| 1.3 | Step 3 (Development) has a concrete prompt | ⬜ | |
| 1.4 | Step 4 (Code Review) has a concrete prompt | ⬜ | |
| 1.5 | Step 5 (Trace Test Coverage) has a concrete prompt | ⬜ | |

**AC1 Pass:** All 1.1–1.5 checked ✅

---

## AC2: Self-contained prompts (no slash commands)

Each prompt is self-contained: outcome, context (story ID, paths, relevant docs), and does not depend on "run /bmad-…" or other slash commands.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 2.1 | No prompt contains "run `/bmad-…`" or "run /bmad-…" or "Command: /bmad-…" | ⬜ | |
| 2.2 | Each prompt includes outcome (what to do for that step) | ⬜ | |
| 2.3 | Each prompt includes context: story ID (or placeholder), paths (sprint-status, story_location, planning artifacts, story file), and relevant docs | ⬜ | |

**AC2 Pass:** All 2.1–2.3 checked ✅

---

## AC3: Defined location and documentation

Prompts are stored in a defined location; location is documented.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 3.1 | Prompts exist in a defined artifact: e.g. `references/step-prompts.md` or per-step files in the skill, or config the command reads | ⬜ | |
| 3.2 | Prompt location is documented (e.g. in skill SKILL.md, Dev Notes, or implementation-artifacts) | ⬜ | |
| 3.3 | Orchestrator/command can resolve prompt by step ID or step title | ⬜ | |

**AC3 Pass:** All 3.1–3.3 checked ✅

---

## AC4: Step outcome alignment with workflow-steps.md

For each step, running a subagent with the corresponding prompt completes the step's outcome as specified in `workflow-steps.md`.

| # | Check | Pass? | Notes |
|---|--------|------|--------|
| 4.1 | Create User Story prompt leads to: story file created; return story ID, title, path | ⬜ | Per workflow-steps Expected return |
| 4.2 | Generate ATDD Tests prompt leads to: ATDD checklist + test assets; checks in red | ⬜ | Per workflow-steps Expected return |
| 4.3 | Development prompt leads to: implementation; tests green; tasks marked complete; status → review | ⬜ | Per workflow-steps Expected return |
| 4.4 | Code Review prompt leads to: conclusion (pass/needs-fix/blocked) + issues by severity | ⬜ | Per workflow-steps Expected return |
| 4.5 | Trace Test Coverage prompt leads to: coverage/gate decision; optional traceability artifact | ⬜ | Per workflow-steps Expected return |

**AC4 Pass:** All 4.1–4.5 checked ✅ (validated by manual or automated run of subagent per step)

---

## Verification

- **Preferred prompt artifact:** `.cursor/skills/bmad-story-pipeline/references/step-prompts.md` (or per-step files in that directory).
- **Automated check:** Run `verify-1-2-subagent-prompts.sh` from repo root; exit 0 = structural checks (AC1–AC3) pass. AC4 requires running each step with a subagent and is not fully automated by the script.
