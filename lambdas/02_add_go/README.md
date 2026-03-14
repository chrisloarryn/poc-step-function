# Add Lambda

## Purpose

This Lambda performs the `add` operation for the calculator workflow.

## Runtime

Go compiled for `provided.al2023`.

## Responsibilities

- receive normalized calculator input
- return the sum of `left` and `right`
- tag the response with `handledBy: "go-add"`

## Input

```json
{
  "left": 10,
  "right": 5,
  "operation": "add"
}
```

## Output

```json
{
  "left": 10,
  "right": 5,
  "operation": "add",
  "result": 15,
  "handledBy": "go-add"
}
```

## Notes

- source file: `main.go`
- output binary name: `bootstrap`
- built for Linux by the shared repository build script
