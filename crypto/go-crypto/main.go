package main

import (
	"crypto"
	"crypto/aes"
	"crypto/cipher"
	"crypto/ecdsa"
	"crypto/ed25519"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"fmt"
	"os"

	"golang.org/x/crypto/chacha20poly1305"
	"golang.org/x/crypto/curve25519"
	"golang.org/x/crypto/pbkdf2"
	"golang.org/x/crypto/scrypt"
)

func main() {
	// AES-GCM
	key := make([]byte, 32)
	rand.Read(key)
	block, _ := aes.NewCipher(key)
	gcm, _ := cipher.NewGCM(block)
	nonce := make([]byte, gcm.NonceSize())
	ct := gcm.Seal(nil, nonce, []byte("hello benchmark"), nil)

	// ChaCha20-Poly1305
	c20, _ := chacha20poly1305.New(key)
	cct := c20.Seal(nil, nonce[:c20.NonceSize()], []byte("hello benchmark"), nil)

	// RSA
	rk, _ := rsa.GenerateKey(rand.Reader, 2048)
	_, _ = rsa.SignPKCS1v15(rand.Reader, rk, crypto.SHA256, make([]byte, 32))

	// ECDSA
	ek, _ := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	_, _ = ecdsa.SignASN1(rand.Reader, ek, make([]byte, 32))

	// Ed25519
	_, ek2, _ := ed25519.GenerateKey(rand.Reader)
	_ = ed25519.Sign(ek2, make([]byte, 32))

	// X25519
	xk, _ := curve25519.X25519(curve25519.Basepoint, key)

	// KDFs
	_ = pbkdf2.Key([]byte("pw"), make([]byte, 16), 10000, 32, sha256.New)
	_, _ = scrypt.Key([]byte("pw"), make([]byte, 16), 16384, 8, 1, 32)

	// SHA
	h := sha256.Sum256([]byte("hello"))

	// x509 minimal cert create/parse roundtrip
	tmpl := x509.Certificate{}
	der, _ := x509.CreateCertificate(rand.Reader, &tmpl, &tmpl, &rk.PublicKey, rk)
	_, _ = x509.ParseCertificate(der)

	fmt.Printf("aes=%d chacha=%d x25519=%d sha=%x\n", len(ct), len(cct), xk[0], h[:4])
	os.Exit(0)
}
