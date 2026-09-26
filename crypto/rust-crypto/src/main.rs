use aes_gcm::aead::{Aead, KeyInit, Payload};
use aes_gcm::{AesGcm, Key, Nonce};
use blake2::Blake2s256;
use chacha20poly1305::ChaCha20Poly1305;
use sha2::Digest;
use ed25519_dalek::{Signer, SigningKey};
use hmac::Hmac;
use pbkdf2::pbkdf2_hmac;
use rand_core::OsRng;
use rsa::pkcs1v15::SigningKey as RsaSigningKey;
use rsa::sha2::Sha256;
use rsa::{RsaPrivateKey, RsaPublicKey};
use scrypt::scrypt;
use sha1::Sha1;
use sha2::Sha256 as Sha2_256;
use x25519_dalek::{EphemeralSecret, PublicKey as XPublicKey};

type AesGcm256 = AesGcm<aes::Aes256, aes_gcm::aead::consts::U12>;

fn main() {
    let key = [7u8; 32];
    let nonce = Nonce::from_slice(b"unique-nonce"); // 12 bytes

    // AES-GCM (pure Rust)
    let cipher = AesGcm256::new(Key::<AesGcm256>::from_slice(&key));
    let ct = cipher
        .encrypt(nonce, Payload { msg: b"hello benchmark", aad: b"" })
        .unwrap();

    // ChaCha20-Poly1305 (uses 12-byte nonce too, same slice works)
    let c20 = ChaCha20Poly1305::new((&key).into());
    let cct = c20
        .encrypt(&nonce, Payload { msg: b"hello benchmark", aad: b"" })
        .unwrap();

    // SHA family
    let _ = Sha2_256::digest(b"hello");
    let _ = Sha1::digest(b"hello");
    let _ = Blake2s256::digest(b"hello");

    // HMAC-SHA256
    type HmacSha256 = Hmac<Sha2_256>;
    let mut mac = <HmacSha256 as hmac::Mac>::new_from_slice(&key).unwrap();
    use hmac::Mac as HmacMac;
    mac.update(b"hello");
    let _ = mac.finalize();

    // RSA 2048 keygen + sign
    let mut rng = OsRng;
    let rsa_key = RsaPrivateKey::new(&mut rng, 2048).expect("rsa gen");
    let _pub = RsaPublicKey::from(&rsa_key);
    let signing = RsaSigningKey::<Sha256>::new(rsa_key);
    use rsa::signature::RandomizedSigner;
    let _sig = signing.sign_with_rng(&mut rng, b"hello");

    // Ed25519
    let ekey = SigningKey::from_bytes(&key);
    let _esig = ekey.sign(b"hello");

    // X25519
    let secret = EphemeralSecret::random_from_rng(OsRng);
    let _xpub = XPublicKey::from(&secret);

    // KDFs
    let mut out = [0u8; 32];
    pbkdf2_hmac::<Sha256>(b"pw", b"salt", 10000, &mut out);
    let mut s_out = [0u8; 32];
    scrypt(b"pw", b"salt", &scrypt::Params::default(), &mut s_out).unwrap();

    // ring (assembly-backed)
    let _ = ring::digest::digest(&ring::digest::SHA256, b"hello");
    let _ = ring::agreement::X25519;

    println!("aes={} chacha={} sha256={:02x?}", ct.len(), cct.len(), &out[..4]);
}
