# RESULTS

## Run 2026-09-25 12:31 UTC

Runner: `ubuntu-latest` (4 vCPU, 16 GB) | clean build | release/opt-level=3

### cross-10m | arm64 | 1 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 8.07 | 8.07 | 12.15 MB |
| rust-lto | 0.04 | 4.44 | 4.48 | 10.42 MB |

Rust(rust-lto) / Go total time ratio: **0.56x**

### cross-10m | arm64 | 2 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 4.48 | 4.48 | 12.15 MB |
| rust-lto | 0.03 | 2.89 | 2.92 | 10.42 MB |

Rust(rust-lto) / Go total time ratio: **0.65x**

### cross-10m | arm64 | 4 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 3.86 | 3.86 | 12.15 MB |
| rust-lto | 0.04 | 4.74 | 4.77 | 10.42 MB |

Rust(rust-lto) / Go total time ratio: **1.24x**

### cross-30m | arm64 | 1 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 8.20 | 8.20 | 32.15 MB |
| rust-lto | 0.04 | 2.88 | 2.92 | 30.42 MB |

Rust(rust-lto) / Go total time ratio: **0.36x**

### cross-30m | arm64 | 2 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 4.53 | 4.53 | 32.15 MB |
| rust-lto | 0.03 | 2.09 | 2.12 | 30.42 MB |

Rust(rust-lto) / Go total time ratio: **0.47x**

### cross-30m | arm64 | 4 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 4.00 | 4.00 | 32.15 MB |
| rust-lto | 0.04 | 2.81 | 2.85 | 30.42 MB |

Rust(rust-lto) / Go total time ratio: **0.71x**

### crypto | amd64 | 1 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 20.85 | 20.85 | 4.75 MB |
| rust-lto | 0.08 | 54.90 | 54.98 | 0.76 MB |
| rust-no-lto | 0.07 | 46.93 | 47.01 | 0.94 MB |

Rust(rust-lto) / Go total time ratio: **2.64x**

### crypto | amd64 | 2 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 10.65 | 10.65 | 4.75 MB |
| rust-lto | 0.05 | 27.39 | 27.44 | 0.76 MB |
| rust-no-lto | 0.05 | 23.61 | 23.67 | 0.94 MB |

Rust(rust-lto) / Go total time ratio: **2.58x**

### crypto | amd64 | 4 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 8.54 | 8.54 | 4.75 MB |
| rust-lto | 0.07 | 22.75 | 22.83 | 0.76 MB |
| rust-no-lto | 0.07 | 18.72 | 18.79 | 0.94 MB |

Rust(rust-lto) / Go total time ratio: **2.67x**

### size-10m | amd64 | 1 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 14.42 | 14.42 | 12.15 MB |
| rust-lto | 0.04 | 12.21 | 12.25 | 10.36 MB |
| rust-no-lto | 0.04 | 0.38 | 0.42 | 10.44 MB |

Rust(rust-lto) / Go total time ratio: **0.85x**

### size-10m | amd64 | 2 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 7.14 | 7.14 | 12.15 MB |
| rust-lto | 0.03 | 3.17 | 3.20 | 10.36 MB |
| rust-no-lto | 0.03 | 0.19 | 0.22 | 10.44 MB |

Rust(rust-lto) / Go total time ratio: **0.45x**

### size-10m | amd64 | 4 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 7.64 | 7.64 | 12.15 MB |
| rust-lto | 0.04 | 11.77 | 11.80 | 10.36 MB |
| rust-no-lto | 0.04 | 0.33 | 0.37 | 10.44 MB |

Rust(rust-lto) / Go total time ratio: **1.54x**

### size-30m | amd64 | 1 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 8.37 | 8.37 | 32.15 MB |
| rust-lto | 0.04 | 2.80 | 2.84 | 30.36 MB |
| rust-no-lto | 0.04 | 0.55 | 0.59 | 30.44 MB |

Rust(rust-lto) / Go total time ratio: **0.34x**

### size-30m | amd64 | 2 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 4.18 | 4.18 | 32.15 MB |
| rust-lto | 0.03 | 2.06 | 2.09 | 30.36 MB |
| rust-no-lto | 0.03 | 0.37 | 0.40 | 30.44 MB |

Rust(rust-lto) / Go total time ratio: **0.50x**

### size-30m | amd64 | 4 core(s)

| Language | Deps (s) | Build (s) | Total (s) | Binary size |
|---|---|---|---|---|
| go | 0.00 | 4.09 | 4.09 | 32.15 MB |
| rust-lto | 0.04 | 2.69 | 2.73 | 30.36 MB |
| rust-no-lto | 0.04 | 0.55 | 0.59 | 30.44 MB |

Rust(rust-lto) / Go total time ratio: **0.67x**


