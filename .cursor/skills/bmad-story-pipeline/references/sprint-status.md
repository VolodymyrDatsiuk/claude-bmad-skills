# Sprint Status and Story Selection

## File locations (path resolution)

**Sprint-status path:** Resolve by trying in order; use the first path where the file exists:

1. `_bmad-output/implementation-artifacts/sprint-status.yaml`
2. `docs/sprint/sprint-status.yaml`

**Story document location:** Read `story_location` from the sprint-status YAML (e.g. `_bmad-output/implementation-artifacts`). Story files live under that path as `{STORY_ID}-*.md` (e.g. `1-3-wire-sprint-status.md`).

## Story status values

Stories use these statuses:

| Status           | Meaning                          |
|------------------|----------------------------------|
| `backlog`        | Not yet started                  |
| `ready-for-dev`  | Story file created, ready to run |
| `in-progress`    | Currently being worked on        |
| `review`         | Implementation done, in review   |
| `done`           | Completed                        |

Legacy: `drafted` is treated as `ready-for-dev`.

## Choosing the next story (next not-done)

1. Parse the sprint-status YAML and read the `development_status` section (key-value pairs; keys are story keys, values are status strings).
2. Iterate over entries in document order; return the **first** story key whose value is not `done` (e.g. `backlog`, `ready-for-dev`, `in-progress`, `review`).
3. Derive story ID from the key: numeric prefix before the slug (e.g. `1-3` from `1-3-wire-sprint-status`).

Story keys look like: `1-1-adapt-workflow-config`, `1-3-wire-sprint-status`. The story ID for pipeline steps is the numeric part: `1-1`, `1-3`.

## Updating status after pipeline

When all pipeline steps succeed:

1. Open the sprint-status file (same path used for read) and find the story entry under `development_status`.
2. Set that story's value to `done`.
3. **Persist** the sprint-status file (write to disk).
4. Update the story document: path = `{story_location}/{STORY_ID}-*.md` (e.g. `_bmad-output/implementation-artifacts/1-3-wire-sprint-status.md`). Set `Status:` to `done` and mark all task checkboxes with ✅.
