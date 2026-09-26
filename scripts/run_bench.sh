#!/usr/bin/env bash
# run_bench.sh — clean-build one project under a CPU constraint, append a JSON result.
#
# usage: run_bench.sh <lang> <test> <arch> <cores> <project-dir> <result-file>
#   lang   : go | rust-lto | rust-no-lto
#   arch   : amd64 | arm64   (arm64 => real cross-compile)
#
# The result file is APPENDED to: each call adds one JSON array. summarize.py
# reads multi-document files, so a whole suite can share one output file.
set -euo pipefail

LANG_="$1"; TEST="$2"; ARCH="$3"; CORES="$4"; DIR="$5"; OUT="$6"
OUT=$(realpath -m "$OUT")            # resolve before cd
CPUS=$(python3 -c "print(','.join(str(i) for i in range($CORES)))")

echo "::group::$TEST | $ARCH | ${CORES}c | $LANG_"
cd "$DIR"

# --- clean slate: no cached artifacts may leak into the measurement ---
rm -rf target
if [ "${LANG_}" = "go" ]; then
  go clean -cache
fi

DEPS=0

if [ "$LANG_" = "go" ]; then
  GOARCH_=amd64
  [ "$ARCH" = "arm64" ] && GOARCH_=arm64
  START=$(date +%s.%N)
  taskset -c "$CPUS" env GOOS=linux GOARCH="$GOARCH_" GOMAXPROCS="$CORES" \
    go build -o /tmp/bench-bin .
  END=$(date +%s.%N)
  BIN=/tmp/bench-bin
else
  # Dependency fetch is a network phase; time it separately from compilation.
  D0=$(date +%s.%N)
  cargo fetch >/dev/null
  D1=$(date +%s.%N)
  DEPS=$(python3 -c "print(f'{$D1 - $D0:.4f}')")

  if [ "$LANG_" = "rust-lto" ]; then
    export CARGO_PROFILE_RELEASE_LTO=fat
    export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
  fi

  TARGET_ARGS=()
  OUTDIR=target/release
  if [ "$ARCH" = "arm64" ]; then
    TARGET_ARGS=(--target aarch64-unknown-linux-gnu)
    OUTDIR=target/aarch64-unknown-linux-gnu/release
  fi

  START=$(date +%s.%N)
  taskset -c "$CPUS" env CARGO_BUILD_JOBS="$CORES" \
    cargo build --release --offline "${TARGET_ARGS[@]}"
  END=$(date +%s.%N)
  BIN=$(find "$OUTDIR" -maxdepth 1 -type f -perm -u+x ! -name '*.d' | head -1)
fi

if [ -z "${BIN:-}" ] || [ ! -f "$BIN" ]; then
  echo "::error::no binary produced for $TEST/$LANG_/$ARCH"
  exit 1
fi
SIZE=$(stat -c%s "$BIN")

python3 -c "
import json
print(json.dumps([{
  'test': '$TEST',
  'arch': '$ARCH',
  'cores': int('$CORES'),
  'lang': '$LANG_',
  'deps_seconds': float('$DEPS'),
  'build_seconds': float('$END') - float('$START'),
  'total_seconds': float('$END') - float('$START') + float('$DEPS'),
  'binary_bytes': int('$SIZE'),
  'runner': '${RUNNER_LABEL:-ubuntu-latest}',
}]))" | tee -a "$OUT"

rm -rf target
echo "::endgroup::"
