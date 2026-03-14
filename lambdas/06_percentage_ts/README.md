# Percentage Lambda

## Purpose

This Lambda performs the `percentage` operation for the calculator workflow.

## Runtime

TypeScript compiled to Node.js 22.

## Responsibilities

- receive normalized calculator input
- compute `left * right / 100`
- tag the response with `handledBy: "typescript-percentage"`

## Input

```json
{
  "left": 120,
  "right": 15,
  "operation": "percentage"
}
```

## Output

```json
{
  "left": 120,
  "right": 15,
  "operation": "percentage",
  "result": 18,
  "handledBy": "typescript-percentage"
}
```

## Notes

- source file: `src/main.ts`
- compiled by the shared repository build script
- uses `NodeNext` TypeScript module settings to stay aligned with modern compiler behavior
