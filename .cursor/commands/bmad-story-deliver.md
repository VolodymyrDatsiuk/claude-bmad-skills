---
name: bmad-story-deliver
description: Run the full BMAD story delivery pipeline (create story → ATDD tests → development → code review → trace coverage). Optionally pass a story ID (e.g. 1-4 or 1.4); when omitted, resolve the next not-done story from sprint-status.yaml. One subagent per step; on success updates sprint-status and story document to done.
---

# BMAD Story Deliver — Full Pipeline

Run the story delivery pipeline for a single story. Execute each step in order using a subagent; on full success, update sprint-status and the story document.

## 1. Resolve story ID

- **If the user provided a story ID** (e.g. `1-4`, `1.4`): Normalize it to the form `X-Y` (e.g. `1.4` → `1-4`). Use this as `STORY_ID`.
- **If no story ID was provided:** Read sprint-status from `_bmad-output/implementation-artifacts/sprint-status.yaml` (or the path in `.cursor/skills/bmad-story-pipeline/references/sprint-status.md`). Parse `development_status` and find the **first story key whose value is not `done`**. Derive `STORY_ID` from that key (e.g. `1-4` from `1-4-add-cursor-command`). If all stories are done, ask the user to specify a story ID.

## 2. Resolve story_location

- Read `story_location` from the sprint-status YAML (e.g. `_bmad-output/implementation-artifacts`). If absent, use `_bmad-output/implementation-artifacts`.

## 3. Load pipeline definition and step prompts

- **Workflow steps:** Read `.cursor/skills/bmad-story-pipeline/references/workflow-steps.md`. Execute the steps **in order**: Create User Story, Generate ATDD Tests, Development, Code Review, Trace Test Coverage.
- **Step prompts:** Read `.cursor/skills/bmad-story-pipeline/references/step-prompts.md`. For each step, use the corresponding **Prompt** block. In that text, **substitute** `{STORY_ID}` with the resolved story ID and `{story_location}` with the resolved story_location value.

## 4. Run each step (one subagent per step)

For **each** of the five steps, in order:

1. Build the prompt for that step by substituting `{STORY_ID}` and `{story_location}` in the step’s prompt from step-prompts.md.
2. Invoke **one subagent** (e.g. task tool / `mcp_task` with `subagent_type: "generalPurpose"`) with that prompt. Use a short description (e.g. “Step N: &lt;Step Name&gt;”).
3. **Wait for the subagent to complete** before starting the next step.
4. If the step **fails** or reports an error: **stop**; do not run later steps. Report the failure and the step number to the user. Do not update sprint-status or the story document.

## 5. Post-pipeline (only after all steps succeed)

When **all** steps have completed successfully:

1. **Sprint-status:** Open the sprint-status file (same path you used to read it). Find the story entry under `development_status` (key like `1-4-add-cursor-command`). Set its value to `done`. **Persist** the file (write to disk).
2. **Story document:** Resolve the story file path as `{story_location}/{STORY_ID}-*.md` (e.g. `_bmad-output/implementation-artifacts/1-4-add-cursor-command.md`). Open that file. Set `Status:` to `done`. Mark all task/subtask checkboxes with ✅. Save the file.

Then report: Pipeline complete; story &lt;STORY_ID&gt; marked done in sprint-status and story document.

## Summary

- **Optional story ID** (e.g. 1-4 or 1.4); when missing, **read sprint-status** and resolve **next not-done** story.
- **Load pipeline** from `references/workflow-steps.md`; **load step prompts** from `references/step-prompts.md`; **substitute** `{STORY_ID}` and `{story_location}` in each prompt.
- **One subagent per step**, wait for completion; **stop on failure**.
- **On full success:** set story to **done** in sprint-status and **persist**; set story document **Status** to **done** and mark all tasks with ✅.
