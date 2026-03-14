# Multiply Lambda

## Purpose

This Lambda performs the `multiply` operation for the calculator workflow.

## Runtime

Python 3.12.

## Responsibilities

- receive normalized calculator input
- return `left * right`
- tag the response with `handledBy: "python-multiply"`

## Input

```json
{
  "left": 10,
  "right": 5,
  "operation": "multiply"
}
```

## Output

```json
{
  "left": 10,
  "right": 5,
  "operation": "multiply",
  "result": 50,
  "handledBy": "python-multiply"
}
```

## Notes

- source file: `main.py`
- packaged directly by the shared repository build script
