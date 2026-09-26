#!/usr/bin/env python3
"""Generate binary payload assets used to control output binary size.

Each payload is high-entropy random bytes so neither Go nor Rust
compilers/linkers can compress, deduplicate, or strip it away.
Sizes: 10 MiB and 30 MiB. Deterministic (seeded) for reproducibility.
"""
import os
import sys

ASSETS = {
    "payload-10m.bin": 10 * 1024 * 1024,
    "payload-30m.bin": 30 * 1024 * 1024,
}


def main(outdir: str) -> None:
    os.makedirs(outdir, exist_ok=True)
    for name, size in ASSETS.items():
        path = os.path.join(outdir, name)
        if os.path.exists(path) and os.path.getsize(path) == size:
            print(f"skip {name} (exists, size ok)")
            continue
        # Seeded PRNG stream written in 1 MiB blocks.
        block = bytearray(1024 * 1024)
        with open(path, "wb") as f:
            remaining = size
            seed = 0x9E3779B9
            while remaining > 0:
                n = min(remaining, len(block))
                # xorshift64* per 8 bytes - fast and deterministic
                i = 0
                state = seed
                while i < n:
                    state ^= (state >> 12) & 0xFFFFFFFFFFFFFFFF
                    state = (state * 0x2545F4914F6CDD1D) & 0xFFFFFFFFFFFFFFFF
                    state ^= (state >> 25) & 0xFFFFFFFFFFFFFFFF
                    state = (state * 0x2545F4914F6CDD1D) & 0xFFFFFFFFFFFFFFFF
                    state ^= (state >> 27) & 0xFFFFFFFFFFFFFFFF
                    val = (state * 0x2545F4914F6CDD1D) & 0xFFFFFFFFFFFFFFFF
                    take = min(8, n - i)
                    block[i : i + take] = val.to_bytes(8, "little")[:take]
                    i += take
                f.write(block[:n])
                remaining -= n
                seed = (seed + 1) & 0xFFFFFFFFFFFFFFFF
        print(f"wrote {name} ({size} bytes)")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "assets")
