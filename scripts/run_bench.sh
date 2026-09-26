#!/usr/bin/env bash
# run_bench.sh — clean-build a project under a CPU constraint, emit JSON result.
#
# usage: run_bench.sh <lang: go|rust-lto|rust-no-lto> <test-name> <arch> <cores> <project-dir> <result-out>
set -euo pipefail

LANG_="$1"; TEST="$2"; ARCH="$3"; CORES="$4"; DIR="$5"; OUT="$6"
# Resolve OUT to absolute before cd'ing into the project dir.
OUT=$(realpath -m "$OUT")
CPUS=$(python3 -c "print(','.join(str(i) for i in range($CORES)))")

cd "$DIR"
rm -rf target
go clean -cache 2>/dev/null || true

START=$(date +%s.%N)
DEPS=0

if [ "$LANG_" = "go" ]; then
  # Go stdlib only: no separate deps phase.
  taskset -c "$CPUS" env GOMAXPROCS="$CORES" GOFLAGS='' go build -o /tmp/bench-out-bin .
  BIN=/tmp/bench-out-bin
else
  # deps: cargo fetch (network phase, counted separately)
  D0=$(date +%s.%N)
  cargo fetch
  D1=$(date +%s.%N)
  DEPS=$(python3 -c "print(f'{$D1 - $D0:.4f}')")
  if [ "$LANG_" = "rust-lto" ]; then
    export CARGO_PROFILE_RELEASE_LTO=fat
    export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
  fi
  taskset -c "$CPUS" env CARGO_BUILD_JOBS="$CORES" cargo build --release
  BIN=$(find target/release -maxdepth 1 -type f -executable | head -1)
fi

END=$(date +%s.%N)
SIZE=$(stat -c%s "$BIN")

python3 -c "
import json
print(json.dumps([{
  'test': '$TEST',
  'arch': '$ARCH',
  'cores': int('$CORES'),
  'lang': '$LANG_',
  'deps_seconds': float('$DEPS'),
  'build_seconds': float('$END') - float('$START') - float('$DEPS'),
  'total_seconds': float('$END') - float('$START'),
  'binary_bytes': int('$SIZE'),
  'runner': 'ubuntu-latest',
}]))" > "$OUT"

cat "$OUT"
