# Divide Lambda

## Purpose

This Lambda performs the `divide` operation for the calculator workflow.

## Runtime

Node.js 22.

## Responsibilities

- receive normalized calculator input
- return `left / right`
- reject division by zero as a defensive check
- tag the response with `handledBy: "node-divide"`

## Input

```json
{
  "left": 10,
  "right": 5,
  "operation": "divide"
}
```

## Output

```json
{
  "left": 10,
  "right": 5,
  "operation": "divide",
  "result": 2,
  "handledBy": "node-divide"
}
```

## Notes

- source file: `main.js`
- packaged directly by the shared repository build script
