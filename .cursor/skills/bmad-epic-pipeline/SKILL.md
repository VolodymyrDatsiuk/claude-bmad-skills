---
name: bmad-epic-pipeline
description: Deliver entire Epic using configurable pipeline in the main repo (no worktrees). Use when the user asks to deliver an epic or run the epic pipeline without worktrees; optionally with an epic number (e.g. 1 or 2); if omitted, auto-select smallest epic with incomplete stories.
---

# BMAD Epic Pipeline (No Worktrees)

Deliver all incomplete user stories in Epic `{EPIC}` using the configurable pipeline; each story is delivered in the main working tree by running the story pipeline sequentially.

## Pre-step: Determine Epic Number

**If the user did not provide an epic number:**

1. Read sprint-status from the locations in **references/sprint-status.md**
2. Find all stories with status not `done` (keys like `X-Y-story-name`)
3. Collect epic numbers X from those stories
4. Choose the smallest such epic number as `{EPIC}`
5. Output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📌 Auto-selected Epic: {EPIC} (has incomplete stories)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Example:** Status has `3-2-llm-prompt-template: backlog`, `3-3-xxx: in-progress`, `4-1-xxx: done` → incomplete epics include 3 → use Epic 3.

---

## Difference from single-story and worktree epic

| Feature | bmad-story-pipeline | bmad-epic-pipeline | bmad-epic-pipeline-worktree |
|---------|---------------------|--------------------|-----------------------------|
| Scope | One story | All incomplete stories in one epic | Same |
| Story delivery | Single run | Sequential runs of story pipeline | Sequential in worktrees |
| Workflow config | workflow-steps.md | Same (via story pipeline) | Same |
| Isolation | Main repo | Main repo | Worktree per story |

---

## Execution Strategy

1. Collect all incomplete stories for Epic `{EPIC}` (from sprint-status).
2. Sort by story number ascending.
3. For **each** story, run the full **bmad-story-pipeline** flow (workflow steps in main repo; update status when done). Run stories **sequentially**; only start the next after the previous completes.
4. If any story's pipeline fails, stop and report; do not run the next story.

---

## Step 1: Collect Epic Story List

- Read sprint-status from **references/sprint-status.md** (file locations listed there).
- Filter entries whose key matches `{EPIC}-Y-*` (same epic).
- Keep only stories with status not `done`.
- Sort by story number Y ascending.
- Produce a list: Story ID (e.g. `{EPIC}.1`), name, status; and total count.

**Progress output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Epic {EPIC} - Story List

   Story  | Name                    | Status
   -------|-------------------------|--------
   {EPIC}.1 | {story-name-1}     | backlog
   {EPIC}.3 | {story-name-3}     | in-progress
   ...

   📊 Total: {N} incomplete stories
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If there are no incomplete stories, output "Epic {EPIC} has no incomplete stories" and stop.

---

## Step 2–N: Deliver Each Story (Sequentially)

For each story in the list (in order):

1. Set `STORY_NUM` = story ID (e.g. `1-1`, `2-3`).
2. Call the task tool with `subagent_type: "generalPurpose"`, description e.g. "Deliver story {STORY_NUM} (Epic {EPIC})", and a prompt that:
   - Instructs the subagent to run the **bmad-story-pipeline** flow for story `STORY_NUM`:
     - Read workflow steps from references/workflow-steps.md (in bmad-story-pipeline skill)
     - Execute each step in sequence in the main repo
     - Update sprint-status and story doc to done only after all steps succeed
   - Asks for: (1) completion status, (2) key outputs, (3) any issues or failure point
3. Wait for the result before starting the next story.
4. If the step fails, stop the epic and report (see Error handling).

**Per-story progress:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 Story [{i}/{N}]: {STORY_NUM}
   📝 Name: {story-name}
   ⏳ Executing configurable pipeline...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Story [{i}/{N}]: {STORY_NUM} Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**If a story fails:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Story [{i}/{N}]: {STORY_NUM} Failed
   ⚠️ Stopping subsequent story delivery
   💡 Fix this story in the main repo, then re-run epic to continue
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Final Delivery Report

**All stories complete:**
```
╔════════════════════════════════════════════════════════╗
║         🎉 BMAD Epic Pipeline Complete!                ║
╠════════════════════════════════════════════════════════╣
║  Epic: {EPIC}                                          ║
║  ✅ Story 1: {story-1} - done                          ║
║  ✅ Story 2: {story-2} - done                          ║
║  ...                                                   ║
║  📊 Total: {N}/{N} stories completed                   ║
╚════════════════════════════════════════════════════════╝
```

**Partial (some failed):**
```
╔════════════════════════════════════════════════════════╗
║      ⚠️ BMAD Epic Pipeline - Partial Completion        ║
╠════════════════════════════════════════════════════════╣
║  Epic: {EPIC}                                          ║
║  ✅ Story 1: ... - done   ❌ Story 3: ... - failed     ║
║  📊 Progress: {completed}/{total}                       ║
║  💡 Fix failed story in main repo, then re-run to continue ║
╚════════════════════════════════════════════════════════╝
```

---

## Error Handling

If a story delivery fails:

1. Stop; do not run the next story.
2. Output failure and how many stories completed.
3. Suggest fixing the failed story in the main repo, then re-running this skill for the same epic; completed stories will already be `done` and will be excluded from the list.

**Resume:** Fix the failed story, run bmad-story-pipeline for that story (or fix manually and set status to done), then run this skill again for the same epic; remaining incomplete stories will be delivered.

---

## Configuration

Pipeline steps are defined in **bmad-story-pipeline**'s **references/workflow-steps.md**. Customize the pipeline there (add/remove/reorder steps or change commands).

## References

- **Sprint status and story list**: [references/sprint-status.md](references/sprint-status.md) — file locations, story keys, epic grouping, and how to list incomplete stories for an epic.
