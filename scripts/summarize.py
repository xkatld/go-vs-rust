#!/usr/bin/env python3
"""Build benchmark results into a Markdown table.

Reads one or more JSON result files (each produced by a workflow step),
aggregates them, and renders a Markdown section to append to RESULTS.md
and to the GitHub Job Summary.

JSON schema per entry:
{
  "test": "size-10m" | "crypto" | "cross",
  "arch": "amd64" | "arm64",
  "cores": 1|2|4,
  "lang": "go" | "rust-lto" | "rust-no-lto",
  "deps_seconds": float,     # dependency download/compile phase (0 if n/a)
  "build_seconds": float,    # main compile+link wall time
  "total_seconds": float,
  "binary_bytes": int,
  "runner": "ubuntu-latest"
}
"""
import json
import sys
from datetime import datetime, timezone


def fmt_bytes(n: int) -> str:
    return f"{n / 1024 / 1024:.2f} MB"


def load(paths):
    entries = []
    for p in paths:
        with open(p) as f:
            data = json.load(f)
        entries.extend(data if isinstance(data, list) else [data])
    return entries


def render(entries):
    lines = []
    lines.append(f"## Run {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}")
    lines.append("")
    runner = entries[0].get("runner", "ubuntu-latest") if entries else "ubuntu-latest"
    lines.append(f"Runner: `{runner}` (4 vCPU, 16 GB) | clean build | release/opt-level=3")
    lines.append("")
    # Group by test, then arch, then cores.
    groups = {}
    for e in entries:
        groups.setdefault((e["test"], e.get("arch", "-"), e["cores"]), []).append(e)
    for (test, arch, cores) in sorted(groups):
        es = sorted(groups[(test, arch, cores)], key=lambda x: x["lang"])
        lines.append(f"### {test} | {arch} | {cores} core(s)")
        lines.append("")
        lines.append("| Language | Deps (s) | Build (s) | Total (s) | Binary size |")
        lines.append("|---|---|---|---|---|")
        for e in es:
            lines.append(
                f"| {e['lang']} | {e['deps_seconds']:.2f} | {e['build_seconds']:.2f} "
                f"| {e['total_seconds']:.2f} | {fmt_bytes(e['binary_bytes'])} |"
            )
        # speed ratio for same binary sizes
        go = next((e for e in es if e["lang"] == "go"), None)
        rust = next((e for e in es if e["lang"] != "go"), None)
        if go and rust:
            r = rust["total_seconds"] / go["total_seconds"]
            lines.append("")
            lines.append(f"Rust({rust['lang']}) / Go total time ratio: **{r:.2f}x**")
        lines.append("")
    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        print("usage: summarize.py result1.json [result2.json ...]", file=sys.stderr)
        sys.exit(2)
    entries = load(sys.argv[1:])
    print(render(entries))


if __name__ == "__main__":
    main()
