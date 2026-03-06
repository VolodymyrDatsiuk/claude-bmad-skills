# Roadmap: BMAD for Cursor (Same as Claude Code)

This repo was built to automate the BMAD story delivery pipeline. You've installed BMAD here to support **Cursor** as well as Claude Code. This roadmap gets BMAD to the same level of support in Cursor.

---

## Current State

| Aspect | Claude Code | Cursor |
|--------|-------------|--------|
| **Commands** | `.claude/commands/` (57 commands) | `.cursor/commands/` (57 commands, mirrored) |
| **Workflows** | `_bmad/` — shared | Same `_bmad/` — shared |
| **Execution** | AI loads `workflow.xml` + `workflow.yaml` per command | Same — commands tell AI to load same files |
| **Skills** | `~/.claude/skills/` or project `skills/` | Cursor uses `~/.cursor/skills-cursor/` or project-attached skills |
| **Project context** | `project-context.md` used by workflows | Same file; currently sparse (see below) |

So: **BMAD is already wired for Cursor** — same commands and workflows. The gaps are configuration, project context, and Cursor-specific glue (rules/skills discovery).

---

## Phase 1: Fix Sparse project-context.md

**Why it's almost empty**

- **Generate project-context** is a two-step, interactive workflow:
  1. **Step 1 (discover)** — Scans codebase, writes initial file from template. You got this (technology_stack + placeholder sections).
  2. **Step 2 (generate)** — For each category (Technology Stack, Language-Specific, Framework-Specific, Testing, etc.) the AI asks you and only appends when you choose **C (Continue)**. If you didn’t run step 2 or didn’t continue through all categories, the file stays with “_Documented after discovery phase_”.
- This repo has little “app” to discover: mostly BMAD framework + skills, no `architecture.md`, no app `package.json` in the usual sense, and `project_knowledge` is `docs/` (often empty). So discovery finds few patterns.

**What to do**

1. **Option A — Complete the interactive flow**  
   Run `/bmad-bmm-generate-project-context` again. When the AI finishes discovery and shows the first “[C] Continue to context generation”, choose **C**. Then for each rule category (Technology Stack, Language-Specific, Framework-Specific, Testing, etc.) answer the prompts and choose **C** until the workflow finishes. That will fill every section.

2. **Option B — Hand-edit for this repo**  
   Edit `_bmad-output/project-context.md` and replace placeholders with:
   - **Technology Stack & Versions**: e.g. Node/TS, BMAD structure, Cursor/Claude commands.
   - **Critical Implementation Rules**: e.g. “When running BMAD commands, always load the full workflow file from `_bmad/`”; “Follow Conventional Commits”; “Use existing BMAD workflow YAML paths.”

3. **Option C — Add a “minimal context” path (future)**  
   In `generate-project-context`, support a “yolo” or “minimal” mode that, when discovery finds little, still writes a small set of default rules so the file is never just placeholders.

**Recommended:** Do **Option A** once so you see the full flow, then **Option B** to tailor this repo (BMAD + skills, not a typical app).

---

## Phase 2: Ensure Cursor Commands and Workflows Run Correctly

**Goal:** In Cursor, `/bmad-bmm-create-story 1.1`, `/bmad-bmm-dev-story 1.1`, etc. behave like in Claude Code.

**Checklist**

1. **Verify one full workflow**  
   In Cursor, run:
   - `/bmad-bmm-create-story 1.1` (or a story id you have in sprint-status).  
   Confirm the AI loads `workflow.xml` and `create-story/workflow.yaml` and follows the steps. If it doesn’t, the issue is usually that the AI didn’t load the workflow file — ensure the command text says “LOAD the FULL … workflow.xml” and “workflow.yaml” so the model actually reads them.

2. **Ensure paths are correct**  
   Commands use `{project-root}`. In Cursor, project root is the workspace root. No change needed if your workspace root is the repo root.

3. **Optional: Cursor rule for BMAD**  
   Add a Cursor rule (e.g. `.cursor/rules/bmad.mdc`) so that when the user talks about “create story”, “dev story”, “code review”, “sprint”, etc., the AI is nudged to use BMAD commands and load workflow files from `_bmad/`. This makes behavior consistent without relying only on the user typing the exact slash command.

---

## Phase 3: Story Pipeline in Cursor (One Entry Point)

**Goal:** One action in Cursor that runs the full pipeline for a story (create → dev → qa-automate → code-review → status update), like your existing skills.

**Design decided (2026-03-06):** One **Cursor command** as orchestrator; **one subagent per step** (steps run in separate context); workflow config in skill `references/workflow-steps.md`; story from arg or `sprint-status.yaml`; status updated at end. See **project-context.md § Cursor Story Delivery Pipeline** and **brainstorming-session-2026-03-06.md § Implementation Checklist** for the full design and implementation steps.

**Current:**  
- `skills/bmad-story-pipeline/SKILL.md` (and worktree variant) define the pipeline and reference slash commands.  
- In Claude Code, skills are installed under `~/.claude/skills/` or the project.  
- In Cursor, skills are under `~/.cursor/skills-cursor/` or attached to the project; the repo’s `skills/` may not be auto-discovered unless you copy or link them.

**Steps**

1. **Make the pipeline skill available in Cursor**
   - Copy or symlink the pipeline skill into Cursor’s skill dir, e.g.  
     `cp -r skills/bmad-story-pipeline ~/.cursor/skills-cursor/`  
     so Cursor’s agent can “see” the skill, or  
   - Ensure your Cursor project is open at this repo root and that Cursor is configured to use skills from the project (if your Cursor version supports that).

2. **Align workflow steps with installed commands**  
   Your `references/workflow-steps.md` mentions:
   - `/bmad-bmm-create-story`
   - `/bmad-tea-testarch-atdd` (TEA module)
   - `/bmad-bmm-dev-story`
   - `/bmad-bmm-code-review`
   - `/bmad-tea-testarch-trace` (TEA module)  

   If TEA (testarch) commands are not installed in this repo, either:
   - Add TEA workflows/commands under `_bmad/` and `.cursor/commands/`, or  
   - Change `workflow-steps.md` to use only what you have, e.g. create-story → dev-story → qa-automate → code-review (and drop or replace trace with something else).

3. **Single Cursor command (optional)**  
   Add a Cursor command, e.g. `/bmad-pipeline 1.1`, that:
   - Reads `skills/bmad-story-pipeline/references/workflow-steps.md` (or the same path under `~/.cursor/skills-cursor/`),
   - Runs each step in order (each step = “load workflow / run command” for that step),
   - Updates `sprint-status.yaml` and story status at the end.  
   That gives you “one click” in Cursor equivalent to your multi-command pipeline.

---

## Phase 4: Cursor Rules and Project Context (Ongoing)

- **Cursor rules**  
  - At least one rule that ties “story”, “sprint”, “BMAD”, “create story”, “dev story”, “code review” to “use BMAD commands and _bmad workflows”.  
  - Optionally a short rule that says: “When generating or changing code in this repo, follow _bmad-output/project-context.md.”

- **Keep project-context.md updated**  
  When you add new conventions (e.g. new commands, new workflow steps), update **Critical Implementation Rules** so both Claude and Cursor agents stay aligned.

---

## Summary Order

1. **Phase 1** — Fix `project-context.md` (Option A or B above).  
2. **Phase 2** — Run one full BMAD workflow in Cursor (e.g. create-story), fix path/load behavior if needed; add a BMAD Cursor rule.  
3. **Phase 3** — Expose the story pipeline in Cursor (skill in `~/.cursor/skills-cursor/` or project), align `workflow-steps.md` with available commands, optionally add `/bmad-pipeline`.  
4. **Phase 4** — Keep Cursor rules and project-context in sync with how you use BMAD.

After this, BMAD in Cursor will match “the same thing we have here” (Claude Code): same workflows, same pipeline, one place to run it, and a project context that tells agents how to behave.
