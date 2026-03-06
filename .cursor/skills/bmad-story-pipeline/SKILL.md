---
name: bmad-story-pipeline
description: Runs the configurable BMAD story delivery pipeline by executing create-story, ATDD tests, development, code review, and trace coverage steps via subagent. Use when the user asks to run the story pipeline, deliver a story, or execute BMAD story steps; optionally with a story number (e.g. 1-1, 2-3).
---

# BMAD Story Pipeline

Complete the delivery pipeline for a story by running configured workflow steps in order, using a subagent per step.

## Pre-step: Determine Story Number

If the user did not provide a story number:

1. Read sprint-status from the locations in **references/sprint-status.md**
2. Find the first story that is not `done` (e.g. `ready-for-dev`, `in-progress`, `review`)
3. Use that story’s ID as `{STORY_ID}` (e.g. `1-1`, `2-3` from keys like `1-1-user-authentication`)
4. If none found, ask the user to specify the story number

## Execution Strategy

1. Read workflow steps from **references/workflow-steps.md**
2. Execute each step in sequence using the task tool (subagent)
3. Report progress after each step
4. When the pipeline finishes, set the story status to done

## Running Each Step

For every step in **references/workflow-steps.md**:

1. **Load the prompt text** for that step from **references/step-prompts.md** (concrete, self-contained prompt per step).
2. **Substitute placeholders** in the prompt:
   - `{STORY_ID}` → actual story number (e.g. `1-2`)
   - `{story_location}` → value of `story_location` from sprint-status (e.g. `sprint-status.yaml`), or default `_bmad-output/implementation-artifacts` if not set
3. Call the task tool with `subagent_type: "generalPurpose"`, a short description, and the substituted prompt
4. Wait for the result before starting the next step
5. Emit progress: `[X/N] Step Name - Status`

Use **workflow-steps.md** only for step order and for a one-line summary in progress (e.g. “Step 1: Create User Story”). The **prompt text** the subagent receives must come from **step-prompts.md** so it includes full context and expected return.

## Progress Display

After each step, output:

```
📊 Pipeline Progress: [X/N] ████████░░░░ <percent>%

✅ Step X: <Step Name>
   Result: <Brief result summary>
```

## Error Handling

If a step fails:

1. Stop; do not run later steps
2. Output:
   ```
   ❌ Pipeline Failed at Step X: <Step Name>

   Error: <Error details>

   💡 Suggested actions:
   - Check the story file for issues
   - Run the failed step manually: <command>
   - Fix the issue and restart pipeline
   ```
3. Do not continue to the next steps

## Post-Pipeline: Update Status

Only after all steps succeed:

1. **sprint-status:** Open the sprint-status file (path from **references/sprint-status.md**), find the story key under `development_status`, set its value to `done`, and **persist** the file (write to disk).
2. **Story document:** Resolve path from `story_location` in the sprint-status YAML (default `_bmad-output/implementation-artifacts`). Story file pattern: `{story_location}/{STORY_ID}-*.md`. Set `Status:` to `done` and mark all tasks with ✅.

Then output:

```
🎉 Pipeline Complete!

Story: {STORY_ID}
Status: done

📋 Steps completed: N/N
✅ <Step 1 name>
...
```

## Configuration

Pipeline steps and order are defined in **references/workflow-steps.md**. To change the pipeline, edit that file (add/remove/reorder steps or adjust Prompt focus / Expected return).

## References

- **Workflow steps**: [references/workflow-steps.md](references/workflow-steps.md) — pipeline steps (Prompt focus + Expected return per step); read at start to build subagent prompts.
- **Step prompts**: [references/step-prompts.md](references/step-prompts.md) — concrete, self-contained prompts per pipeline step for subagent execution (no slash commands); use these when invoking the task tool for each step.
- **Sprint and story selection**: [references/sprint-status.md](references/sprint-status.md) — where sprint-status lives, story status values, how to pick the next story and update it to done.
