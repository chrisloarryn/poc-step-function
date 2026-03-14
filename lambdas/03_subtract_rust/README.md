# Subtract Lambda

## Purpose

This Lambda performs the `subtract` operation for the calculator workflow.

## Runtime

Rust compiled for `provided.al2023`.

## Responsibilities

- receive normalized calculator input
- return `left - right`
- tag the response with `handledBy: "rust-subtract"`

## Input

```json
{
  "left": 10,
  "right": 5,
  "operation": "subtract"
}
```

## Output

```json
{
  "left": 10,
  "right": 5,
  "operation": "subtract",
  "result": 5,
  "handledBy": "rust-subtract"
}
```

## Notes

- source file: `src/main.rs`
- output binary name: `bootstrap`
- the build script prefers a local `rustup` toolchain and falls back to Docker when needed
