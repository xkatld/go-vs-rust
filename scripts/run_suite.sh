#!/usr/bin/env bash
# run_suite.sh — run the full benchmark suite at one CPU-core tier.
#
# usage: run_suite.sh <cores> <result-file>
#
# Every build in the suite runs on this one runner, so Go and Rust numbers
# for the same test are directly comparable (identical hardware, same run).
set -euo pipefail

CORES="$1"
OUT=$(realpath -m "$2")
: > "$OUT"

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
B="$HERE/run_bench.sh"

run() { "$B" "$1" "$2" "$3" "$CORES" "$ROOT/$4" "$OUT"; }

# --- 1. binary-size projects, native amd64 ---
for mb in 10 30; do
  run go          "size-${mb}m" amd64 "projects/go-${mb}m"
  run rust-lto    "size-${mb}m" amd64 "projects/rust-${mb}m"
  run rust-no-lto "size-${mb}m" amd64 "projects/rust-${mb}m"
done

# --- 2. crypto components ---
run go          crypto amd64 crypto/go-crypto
run rust-lto    crypto amd64 crypto/rust-crypto
run rust-no-lto crypto amd64 crypto/rust-crypto

# --- 3. cross-compile to linux/arm64 ---
for mb in 10 30; do
  run go       "cross-${mb}m" arm64 "projects/go-${mb}m"
  run rust-lto "cross-${mb}m" arm64 "projects/rust-${mb}m"
done

echo "suite complete: $(grep -c . "$OUT") result record(s) -> $OUT"
