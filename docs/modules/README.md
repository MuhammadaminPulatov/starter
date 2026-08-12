# Module documentation

One file per significant module (auth, payment, notification, search…):
`docs/modules/<module-name>.md`.

Read it before working on the module. Update it when the module changes.

## When to write one

Write one for a module that spans several services, integrates a third party,
or encodes non-obvious business rules.

Skip it for a single-file helper — a comment is enough there.

## Template

```markdown
# <Module name>

## Purpose
What problem this module solves. Two or three sentences.

## Entry points
| File | Purpose |
| --- | --- |
| `services/api-node/src/...` | ... |

## Data flow
Who calls it → what happens → what comes back. Include external services.

## Data
Relevant tables, key columns, important indexes.

## Business rules
- The rule and the reason behind it.

## Errors
| Condition | Response | What happens |
| --- | --- | --- |

## Environment
The `.env` variables this module needs.

## Tests
Which tests cover it and how to run them.

## Known limitations
What is deliberately unsolved for now.
```
