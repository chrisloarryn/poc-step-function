# Format Result Lambda

## Purpose

This Lambda builds the final workflow response after an operation Lambda completes.

## Runtime

Node.js 22.

## Responsibilities

- receive the intermediate calculator payload
- generate a human-readable `summary`
- add a `completedAt` timestamp
- keep the final response shape consistent across operations

## Input

```json
{
  "left": 120,
  "right": 15,
  "operation": "percentage",
  "result": 18,
  "handledBy": "typescript-percentage"
}
```

## Output

```json
{
  "left": 120,
  "right": 15,
  "operation": "percentage",
  "result": 18,
  "handledBy": "typescript-percentage",
  "summary": "120 * 15% = 18",
  "completedAt": "2026-03-14T18:00:01.000Z"
}
```

## Notes

- source file: `main.js`
- packaged directly by the shared repository build script
