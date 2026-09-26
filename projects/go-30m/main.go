package main

import (
	_ "embed"
	"fmt"
	"hash/crc32"
	"os"
)

//go:embed payload-30m.bin
var payload []byte

func main() {
	sum := crc32.ChecksumIEEE(payload[:1024*1024])
	fmt.Printf("payload bytes=%d crc32=%08x\n", len(payload), sum)
	os.Exit(0)
}
