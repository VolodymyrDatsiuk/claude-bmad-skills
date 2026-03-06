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

## Story keys and Epic grouping

Story keys in `development_status` look like: `1-1-user-authentication`, `2-3-llm-integration`. Format: `{EPIC}-{STORY}-{slug}`.

- Epic number: first segment (e.g. `1`, `2`).
- Story ID for commands: first two segments (e.g. `1-1`, `2-3`).

To list incomplete stories for Epic `{EPIC}`: filter keys that start with `{EPIC}-`, keep only entries whose status is not `done`, sort by story number (second segment) ascending.

## Updating status after pipeline

When a story pipeline succeeds: set that story's value to `done` in the sprint-status file; update the story document Status and tasks as in the story-pipeline skill.
