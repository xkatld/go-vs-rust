fn crc32_simple(data: &[u8]) -> u32 {
    let mut crc: u32 = 0xFFFFFFFF;
    for &b in data {
        crc ^= b as u32;
        for _ in 0..8 {
            let mask = (crc & 1).wrapping_neg();
            crc = (crc >> 1) ^ (0xEDB88320 & mask);
        }
    }
    !crc
}

fn main() {
    const PAYLOAD: &[u8] = include_bytes!("../payload-30m.bin");
    let sum = crc32_simple(&PAYLOAD[..1024 * 1024]);
    println!("payload bytes={} crc32={:08x}", PAYLOAD.len(), sum);
}
