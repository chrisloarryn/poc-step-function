# Validate Request Lambda

## Purpose

This Lambda validates calculator input before the Step Functions workflow routes execution to an operation-specific Lambda.

## Runtime

TypeScript compiled to Node.js 22.

## Responsibilities

- parse `left` and `right` as numbers
- normalize `operation` or `action`
- accept aliases such as `+`, `sum`, `-`, `*`, `/`, `%`, and `percent`
- reject invalid numeric input
- reject division by zero before the divide Lambda runs

## Input

```json
{
  "left": 12,
  "right": 3,
  "operation": "divide"
}
```

## Output

```json
{
  "left": 12,
  "right": 3,
  "operation": "divide",
  "requestedAt": "2026-03-14T18:00:00.000Z"
}
```

## Notes

- source file: `src/main.ts`
- compiled by the shared repository build script
- all public error messages are kept in English for consistent workflow output
