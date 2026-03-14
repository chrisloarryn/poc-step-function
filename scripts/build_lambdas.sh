#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/lambdas"
TS_TEMP_DIR="$ROOT_DIR/build/.ts"
RUST_TARGET_DIR="$ROOT_DIR/build/.cargo-target"
RUST_IMAGE="${RUST_DOCKER_IMAGE:-messense/rust-musl-cross:x86_64-musl}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

reset_dir() {
  rm -rf "$1"
  mkdir -p "$1"
}

ensure_node_tooling() {
  if [ ! -x "$ROOT_DIR/node_modules/.bin/tsc" ]; then
    require_command npm
    npm ci --prefix "$ROOT_DIR"
  fi
}

build_typescript_lambda() {
  local name="$1"
  local source_dir="$ROOT_DIR/lambdas/$name"
  local ts_out_dir="$TS_TEMP_DIR/$name"
  local artifact_dir="$BUILD_DIR/$name"

  reset_dir "$ts_out_dir"
  reset_dir "$artifact_dir"

  "$ROOT_DIR/node_modules/.bin/tsc" --project "$source_dir/tsconfig.json" --outDir "$ts_out_dir"
  cp "$ts_out_dir/main.js" "$artifact_dir/main.js"
}

build_node_lambda() {
  local name="$1"
  local source_dir="$ROOT_DIR/lambdas/$name"
  local artifact_dir="$BUILD_DIR/$name"

  reset_dir "$artifact_dir"
  cp "$source_dir/main.js" "$artifact_dir/main.js"
}

build_python_lambda() {
  local name="$1"
  local source_dir="$ROOT_DIR/lambdas/$name"
  local artifact_dir="$BUILD_DIR/$name"

  reset_dir "$artifact_dir"
  cp "$source_dir/main.py" "$artifact_dir/main.py"
}

build_go_lambda() {
  local name="$1"
  local source_dir="$ROOT_DIR/lambdas/$name"
  local artifact_dir="$BUILD_DIR/$name"

  require_command go
  reset_dir "$artifact_dir"

  (
    cd "$source_dir"
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -tags lambda.norpc -o "$artifact_dir/bootstrap" .
  )
}

build_rust_lambda() {
  local name="$1"
  local artifact_dir="$BUILD_DIR/$name"
  local rustup_cargo=""
  local rustup_rustc=""

  reset_dir "$artifact_dir"
  mkdir -p "$RUST_TARGET_DIR"

  if command -v rustup >/dev/null 2>&1; then
    rustup target add x86_64-unknown-linux-musl >/dev/null
    rustup_cargo="$(rustup which cargo 2>/dev/null || true)"
    rustup_rustc="$(rustup which rustc 2>/dev/null || true)"

    if [ -n "$rustup_cargo" ] && [ -n "$rustup_rustc" ]; then
      if (
        cd "$ROOT_DIR/lambdas/$name"
        CARGO_TARGET_DIR="$RUST_TARGET_DIR" \
        RUSTC="$rustup_rustc" \
        "$rustup_cargo" build --release --target x86_64-unknown-linux-musl
      ); then
        cp "$RUST_TARGET_DIR/x86_64-unknown-linux-musl/release/bootstrap" "$artifact_dir/bootstrap"
        return 0
      fi
    fi
  fi

  require_command docker

  if ! docker info >/dev/null 2>&1; then
    echo "Rust build requires rustup with x86_64-unknown-linux-musl or a running Docker daemon." >&2
    exit 1
  fi

  docker run --rm \
    -v "$ROOT_DIR:/workspace" \
    -w "/workspace/lambdas/$name" \
    -e CARGO_TARGET_DIR=/workspace/build/.cargo-target \
    "$RUST_IMAGE" \
    cargo build --release --target x86_64-unknown-linux-musl

  cp "$RUST_TARGET_DIR/x86_64-unknown-linux-musl/release/bootstrap" "$artifact_dir/bootstrap"
}

main() {
  rm -rf "$BUILD_DIR" "$TS_TEMP_DIR"
  mkdir -p "$BUILD_DIR" "$TS_TEMP_DIR"

  ensure_node_tooling
  build_typescript_lambda "01_validate_request_ts"
  build_go_lambda "02_add_go"
  build_rust_lambda "03_subtract_rust"
  build_python_lambda "04_multiply_python"
  build_node_lambda "05_divide_node"
  build_typescript_lambda "06_percentage_ts"
  build_node_lambda "07_format_result_node"
}

main "$@"
