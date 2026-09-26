# go-vs-rust — Go vs Rust 编译速度对比

利用 GitHub Actions 对 Go 和 Rust 做干净的 clean-build 编译测试。

## 测试项

| # | Workflow | 内容 | 矩阵 |
|---|---|---|---|
| 1 | `bench-size.yml` | 合成项目编译（二进制 ~10MB / ~30MB） | Go×2、Rust×2 项目 × 1/2/4 核 |
| 2 | `bench-crypto.yml` | 加密组件编译（Go x/crypto vs Rust ring+RustCrypto） | 2 语言 × 1/2/4 核 |
| 3 | `bench-cross.yml` | 交叉编译 Linux 二进制（amd64 + arm64） | 4 项目 × 2 架构 |
| 4 | `bench-all.yml` | 一键全跑 + 结果汇总追加到 `RESULTS.md` | — |

## 说明

- Rust 测两档：`rust-lto`（LTO=fat, codegen-units=1）与 `rust-no-lto`
- 线程限制：`taskset` + `GOMAXPROCS` / `CARGO_BUILD_JOBS`，1、2、4 核三档
- 环境均为 `ubuntu-latest`（4 vCPU），clean build，Rust release / Go 默认优化
- 二进制大小由嵌入的随机 payload 控制（`scripts/gen_payload.py`），保证两语言输入一致
- 手动触发：Actions 页面对应 workflow → Run workflow

## 目录结构

```
projects/       # 合成大小测试项目 (go-10m/go-30m/rust-10m/rust-30m)
crypto/         # 加密组件测试项目 (go-crypto/rust-crypto)
scripts/        # benchmark 执行与结果汇总脚本
RESULTS.md      # 历次测试结果（自动追加）
```
