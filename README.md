# go-vs-rust — Go vs Rust 编译速度对比

利用 GitHub Actions 做 clean-build 编译耗时对比，一个 workflow 跑完全部测试。

## 运行

Actions → **Go vs Rust build benchmark** → Run workflow。

## Job 结构

4 个 job：3 个 bench（1/2/4 核并行）+ 1 个 summarize。

同一测试的 Go 与 Rust 在**同一个 runner 内顺序执行**，确保硬件一致、结果可比；按核数切分 job 是唯一的并行维度。

每个核数档位跑 13 次 clean build：

| 测试 | 构建 |
|---|---|
| size-10m | go / rust-lto / rust-no-lto |
| size-30m | go / rust-lto / rust-no-lto |
| crypto | go / rust-lto / rust-no-lto |
| cross-10m (arm64) | go / rust-lto |
| cross-30m (arm64) | go / rust-lto |

## 测试说明

- **二进制大小**：由嵌入的确定性随机 payload 控制（`go:embed` / `include_bytes!`），两语言输入完全一致
- **加密组件**：Go `crypto` + `x/crypto` vs Rust `ring` + RustCrypto（sha2/aes-gcm/chacha20poly1305/rsa/ed25519/x25519/pbkdf2/scrypt）
- **交叉编译**：linux/arm64，Go 用 `GOARCH=arm64`，Rust 用 `aarch64-unknown-linux-gnu` + `gcc-aarch64-linux-gnu` 链接
- **核数限制**：`taskset` 绑核 + `GOMAXPROCS` / `CARGO_BUILD_JOBS`，对两语言同等施加
- **Rust 两档**：`rust-lto`（LTO=fat, codegen-units=1）与 `rust-no-lto`
- 每次构建前 `rm -rf target` / `go clean -cache`；依赖下载在计时区间外完成

结果写入 Job Summary，并自动追加到 `RESULTS.md`。

## 目录

```
projects/    合成大小测试项目 (go-10m / go-30m / rust-10m / rust-30m)
crypto/      加密组件测试项目 (go-crypto / rust-crypto)
scripts/     run_suite.sh 套件驱动 / run_bench.sh 单次构建 / summarize.py 汇总
RESULTS.md   历次结果（自动追加）
```
