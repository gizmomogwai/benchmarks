extern crate libflate;

use std::io::Read;

fn main() {
    let now = std::time::Instant::now();
    let mut file = std::fs::File::open("../out/nist/2011.json.gz").expect("Failed to open file");
    let mut buffer = vec!();
    file.read_to_end(&mut buffer).expect("Failed to read file");

    let mut input = std::io::Cursor::new(buffer);
    let mut decoder = libflate::gzip::Decoder::new(&mut input).expect("Failed to create decoder");
    let mut output = vec!();

    std::io::copy(&mut decoder, &mut output).expect("Failed to decode");
    let duration = now.elapsed();

    let duration = duration.as_secs() * 1000 + (duration.subsec_nanos() / 1000_000) as u64;
    println!("- Rust: Decompressing took {} ms to {} bytes", duration, output.len());
}