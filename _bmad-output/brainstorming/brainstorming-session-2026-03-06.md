---
stepsCompleted: [1, 2, 3]
inputDocuments: []
session_topic: 'Implementing a BMAD story delivery pipeline for Cursor (equivalent to terryso Claude skills)'
session_goals: 'Explore how to design and build one-command story delivery (create → dev → QA → review → auto-fix → status) and optional worktree/epic modes for Cursor'
selected_approach: 'ai-recommended'
techniques_used: ['First Principles Thinking', 'SCAMPER Method', 'Morphological Analysis']
ideas_generated: []
context_file: ''
---

# Brainstorming Session Results

**Facilitator:** Vova
**Date:** 2026-03-06

## Session Overview

**Topic:** Implementing a BMAD story delivery pipeline for Cursor (equivalent to terryso Claude skills)

**Goals:** Explore how to design and build one-command story delivery (create → dev → QA → review → auto-fix → status) and optional worktree/epic modes for Cursor

### Context Guidance

- Repo was built for automating the BMAD story delivery pipeline (Claude Code Skills).
- **Structure:** BMAD was installed on top of an existing repo (`.claude/`, `.cursor/`, etc.). `_bmad/` is the BMAD framework (workflows, BMM). Don’t confuse commands inside `_bmad/` with the Cursor story-delivery feature we’re designing — orchestration lives in Cursor (`.cursor/commands/`, skills), possibly calling or coordinating with `_bmad/` workflows.
- Target: same UX in Cursor — one command that runs create → dev → QA → code review → auto-fix → update status.
- Three modes to consider: no isolation (quick), story worktree (safe), epic worktree (batch).
- Cursor uses Commands (`.cursor/commands/`), Skills (`~/.cursor/skills-cursor/` or project skills).

### Session Setup

Session initialized from user intent: port the “one command delivers a story” experience from Claude to Cursor and brainstorm how it should be made.

## Technique Selection

**Approach:** AI-Recommended Techniques  
**Analysis Context:** Cursor story delivery pipeline design — technical port, orchestration layer, optional worktree/epic modes.

**Recommended Techniques:**

- **First Principles Thinking:** Strip "how Claude did it" and establish invariants (what must the pipeline do? what does Cursor provide?). Foundation so we don't copy assumptions that don't apply.
- **SCAMPER Method:** Systematically Substitute (Claude commands → Cursor commands/skills), Adapt (pipeline to Cursor's execution model), Modify/Eliminate/Reverse as needed. Structured adaptation of the existing pipeline.
- **Morphological Analysis:** Define parameters (trigger: command vs skill; step execution: subagent vs inline; isolation: none vs worktree; config: file vs hardcoded) and explore combinations to map the design space and pick an architecture.

**AI Rationale:** Goal is a technical port with clear architecture. First Principles avoids cargo-culting Claude's design; SCAMPER gives a repeatable way to adapt each piece; Morphological Analysis makes the option space explicit so we can choose and implement.

---

## Technique Execution Results

### Phase 1: First Principles Thinking (in progress)

**Invariants (agreed):**
- Single entry point (one command/skill).
- Story resolution: explicit arg (e.g. `1.1`) or from `sprint-status.yaml` → next not-done story.
- Fixed sequence of steps, but **skippable** if the developer asks to skip some.
- Each step has a defined outcome.
- Status updated at the end (e.g. story → done in sprint-status).

**Cursor primitives (user):**
- **Commands** — entry point (user invokes one thing).
- **Skills** — portable instructions, invoke via `/skill-name` or agent picks when relevant ([Cursor Skills](https://cursor.com/docs/skills)).
- **Subagents** — own context window, foreground/background ([Cursor Subagents](https://cursor.com/docs/subagents)).
- **Main purpose:** run the workflow **in not the same context** — i.e. each step runs in isolated context (subagent per step), no context bleed; orchestrator coordinates and gets results back.

**First Principles — concluded.** Design: one Command (or Skill) as orchestrator + subagent per pipeline step; story from arg or sprint-status; configurable/skippable steps; status update at end.

---

### Phase 2: SCAMPER Method (complete)

**Substitute:** Claude slash commands → Cursor subagent with step-specific prompt; Task tool → Cursor subagent; same workflow config + sprint-status.
**Adapt:** Step definitions become "prompt focus" not "command"; orchestrator = one Command or Skill; per-step prompt describes outcome; drop "yolo" (use instructions).
**Modify/Eliminate/Reverse:** Optional step list changes; eliminate "execute slash command" from step spec.

---

### Phase 3: Morphological Analysis (complete)

**Parameters and chosen options:**

| Parameter | Choice | Reason |
|-----------|--------|--------|
| Entry point | **Command** | Single clear entry; user runs one command with optional story arg. |
| Step execution | **One subagent per step** | Matches "run in not the same context"; simple and consistent. |
| Workflow config | **In skill** (`references/workflow-steps.md`) | Reuses existing pattern; skill holds pipeline definition. |
| Isolation mode | **None first**, then worktree variant | Ship "story deliver" on current branch first; worktree/epic as phase 2. |
| Skip steps | **Config + user override** | Default in workflow file; user can say "skip step X" when invoking. |

**Target design:** One Cursor command → loads skill (or embeds same logic) → reads workflow-steps.md → resolves story from arg or sprint-status.yaml → runs one subagent per step (prompts from config) → updates status at end. Worktree/epic = phase 2.

---

## Implementation Checklist

Use this for the next implementation session.

1. **Add Cursor command** (e.g. `bmad-story-deliver`) that implements the orchestrator: resolve story ID → loop steps → subagent per step → update status.
2. **Add or reuse Skill** with `references/workflow-steps.md` adapted for Cursor (step = prompt focus + outcome, no slash commands).
3. **Implement subagent prompts** per step (create story, ATDD, dev, code review, trace) so each runs in isolation.
4. **Wire sprint-status**: orchestrator reads for "next story" and writes "done" when pipeline completes.
5. **Later:** Worktree and epic variants (same pipeline, different isolation/scope).
