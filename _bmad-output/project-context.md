---
project_name: 'claude-bmad-skills'
user_name: 'Vova'
date: '2026-03-06'
sections_completed: ['technology_stack']
existing_patterns_found: 6
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Project type:** BMAD framework + skills repo (no application runtime; no root `package.json`).
- **BMAD structure:** Workflows under `_bmad/` (BMM module: `_bmad/bmm/`, BMB: `_bmad/bmb/`). Commands in `.cursor/commands/` (57) and `.claude/commands/` (57); same workflow files are used by both.
- **Config:** `_bmad/bmm/config.yaml` — `project_name`, `user_name`, `output_folder` (`{project-root}/_bmad-output`), `planning_artifacts`, `implementation_artifacts`, `project_knowledge` (`{project-root}/docs`).
- **Workflow definition:** Markdown (`.md`), YAML (`.yaml`), XML where used (e.g. `workflow.xml`). Step files in `workflows/*/steps/`; micro-file design, JIT loading, sequential execution.
- **Skills:** Project skills in `skills/` (e.g. `bmad-story-pipeline`, `bmad-epic-pipeline-worktree`). Cursor uses `~/.cursor/skills-cursor/` or project-attached skills.
- **Outputs:** Generated artifacts in `_bmad-output/` (e.g. `project-context.md`, `ROADMAP-BMAD-FOR-CURSOR.md`, planning/implementation artifacts when used).
- **Version control:** Git. Conventional Commits and commitlint enforced (see user/rule configuration).

## Cursor Story Delivery Pipeline (design decision)

**Goal:** One command delivers a story (create → dev → QA → review → auto-fix → status) in Cursor, with steps running in **separate context** (subagent per step).

**Decisions (from brainstorming 2026-03-06):**

- **Entry point:** One Cursor **command** (e.g. `bmad-story-deliver`); optional story arg or next not-done from `sprint-status.yaml`.
- **Orchestration:** Command runs the pipeline: resolve story ID → read workflow steps (from skill `references/workflow-steps.md`) → for each step, launch **subagent** with step-specific prompt → collect result → on success, update sprint-status to done. Steps are skippable (config or user says "skip X").
- **Step execution:** One **subagent per step** (foreground, sequential). Subagent prompt = outcome for that step (no "run slash command"); subagent uses project files and `_bmad/` workflows to achieve it.
- **Workflow config:** In skill, `references/workflow-steps.md` — step = description + prompt focus + expected return; no Claude slash commands.
- **Isolation:** First version = no worktree (current branch). Worktree and epic batch = phase 2.

**Implementation checklist:** See `_bmad-output/brainstorming/brainstorming-session-2026-03-06.md` § Implementation Checklist.

## Critical Implementation Rules

_Documented after discovery phase_
