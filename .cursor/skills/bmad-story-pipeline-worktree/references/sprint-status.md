# Sprint Status and Story Selection

## File locations

Sprint status is stored in one of (try in order):

- `_bmad-output/implementation-artifacts/sprint-status.yaml`
- `docs/sprint/sprint-status.yaml`

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

## Choosing the next story

For the pipeline, use the first story that is **not** `done` (e.g. `ready-for-dev`, `in-progress`, or `review`). If the skill says "todo or in-progress", treat that as: any story whose status is not `done`.

Story keys in `development_status` look like: `1-1-user-authentication`, `2-3-llm-integration`. The story ID for pipeline commands is the numeric part: `1-1`, `2-3` (first two segments before the slug).

## Updating status after pipeline

When all pipeline steps succeed:

1. Open the sprint-status file and find the story entry under `development_status`.
2. Set its value to `done`.
3. In the story document (path may be in `story_location` or next to planning artifacts), set `Status:` to `done` and mark tasks with ✅.
