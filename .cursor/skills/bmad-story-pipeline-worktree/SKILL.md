---
name: bmad-story-pipeline-worktree
description: Run configurable BMAD pipeline in isolated worktree, merge only after tests pass. Use when the user asks to deliver a story in a worktree or run the story pipeline in a worktree; optionally with a story number (e.g. 1-1, 2-3).
---

# BMAD Story Pipeline (Worktree Edition)

Complete the delivery pipeline for story `{STORY_ID}` using configurable workflow in an isolated git worktree, merge to main branch only after all tests pass.

## Pre-step: Determine Story Number

If the user did not provide a story number:

1. Read sprint-status from the locations in **references/sprint-status.md**
2. Find the first story that is not `done` (e.g. `ready-for-dev`, `in-progress`, `review`)
3. Use that story's ID as `{STORY_ID}` (e.g. `1-1`, `2-3` from keys like `1-1-user-authentication`)
4. If none found, ask the user to specify the story number

## Difference from bmad-story-pipeline

| Feature | bmad-story-pipeline | bmad-story-pipeline-worktree |
|---------|---------------------|------------------------------|
| Working method | Develop on current branch | Develop in isolated worktree |
| Code isolation | None | Complete isolation |
| Merge condition | None enforced | Tests pass + fixes complete |
| Workflow config | workflow-steps.md | workflow-steps.md |
| Safety level | Medium | High |

---

## Phase 1: Create Worktree

**Do this yourself (run commands / use tools; do not delegate to subagent):**

1. Get current project name, path and branch:
   - `ORIGINAL_REPO_PATH` = current working directory
   - `PROJECT_NAME` = basename of current directory
   - `CURRENT_BRANCH` = current git branch

2. Branch name: `feature/story-${STORY_ID}`

3. Worktree directory (sibling): `../${PROJECT_NAME}-story-${STORY_ID}` → set as `WORKTREE_PATH`

4. Create worktree:
   - `git worktree add -b feature/story-${STORY_ID} "$WORKTREE_PATH" $CURRENT_BRANCH`
   - If branch already exists: `git worktree add "$WORKTREE_PATH" feature/story-${STORY_ID}`

5. Verify: `git worktree list`

**Progress output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Create Worktree
   🌿 Branch: feature/story-${STORY_ID}
   📁 Path: ${WORKTREE_PATH}
   📦 Original: ${ORIGINAL_REPO_PATH}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Phase 2: Run Configurable Pipeline (in worktree)

**Context:** All pipeline steps run in the worktree directory (`WORKTREE_PATH`). Switch to that directory for step execution.

1. Read workflow steps from **references/workflow-steps.md**
2. For each step in order:
   - Substitute `{STORY_ID}` in the step command and prompt
   - Call the task tool with `subagent_type: "generalPurpose"`, a short description, and a prompt that:
     - Instructs the subagent to work in the worktree at `WORKTREE_PATH`
     - Tells the subagent to run the step (e.g. execute the create-story step for `{STORY_ID}`)
     - Asks for: (1) step completion status, (2) main outputs, (3) any issues
   - Wait for the result before starting the next step
   - Emit progress: `[X/N] Step Name - Status`

### Step prompt template

Use this pattern (replace command and step name from workflow-steps.md):

```
Working directory: ${WORKTREE_PATH}

Execute the step: <COMMAND_WITH_STORY_ID> (or equivalent create-story / ATDD / dev / code-review / trace step for story {STORY_ID}).

Return: 1) Step completion status 2) Key outputs 3) Any issues to note
```

### Progress display

After each step:
```
📊 Pipeline Progress: [X/N] ████████░░░░ <percent>%

✅ Step X: <Step Name>
   Result: <Brief result summary>
```

### Error handling in Phase 2

If a step fails: stop, do not run later steps. Output:
```
❌ Pipeline Failed at Step X: <Step Name>
Error: <Error details>
💡 Worktree preserved at: ${WORKTREE_PATH}
   Fix the issue there, then merge manually or re-run from Phase 3.
```

---

## Phase 3: Merge or Preserve

**Merge only if:** all pipeline steps completed successfully, no blocking issues (or all fixed), tests pass.

**If conditions met — perform merge yourself:**

1. In worktree: commit all changes (e.g. `git add .` and `git commit -m "feat: complete story ${STORY_ID}"`)
2. Switch back to `ORIGINAL_REPO_PATH`
3. Merge: `git merge feature/story-${STORY_ID} --no-edit`
4. Remove worktree: `git worktree remove ${WORKTREE_PATH}`
5. Optionally: `git branch -d feature/story-${STORY_ID}`
6. Verify: `git worktree list`

**Progress output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Merge Branch
   🔀 Merge: feature/story-${STORY_ID} → [current branch]
   🗑️ Cleanup: worktree removed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**If conditions not met — preserve worktree:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Merge Branch
   ❌ Merge conditions not met, preserving worktree
   📁 Path: ${WORKTREE_PATH}
   🔧 Manual handling needed: [list unmet conditions]
   After fixing: cd ${WORKTREE_PATH} → commit → cd ${ORIGINAL_REPO_PATH} → merge → worktree remove
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Phase 4: Update Status to Done

**Only after successful merge.**

1. **sprint-status.yaml**: Find the story in the file(s) from **references/sprint-status.md** and set its status to `done`
2. **Story document**: Set `Status:` to `done` and mark tasks with ✅

**Progress output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Update Status
   📝 sprint-status.yaml: ${STORY_ID} → done
   📄 Story doc: Status: done, Tasks: ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Final Report

**Success:**
```
🎉 BMAD Story Pipeline Complete!
Story: ${STORY_ID}
✅ Phase 1 - Create Worktree
✅ Phase 2 - Configurable Pipeline
✅ Phase 3 - Merge Branch
✅ Phase 4 - Update Status
Status: done
```

**Manual intervention:**
```
⚠️ BMAD Story Pipeline - Manual Intervention
Story: ${STORY_ID}
✅ Phase 1 - Create Worktree
❌ Phase 2 - Pipeline [failed at Step X] (or Phase 3 not merged)
📁 Worktree: ${WORKTREE_PATH}
💡 Fix and continue manually
```

---

## Configuration

Pipeline steps and order: **references/workflow-steps.md**. Edit that file to add/remove/reorder steps or change commands.

## References

- **Workflow steps**: [references/workflow-steps.md](references/workflow-steps.md)
- **Sprint and story selection**: [references/sprint-status.md](references/sprint-status.md)
