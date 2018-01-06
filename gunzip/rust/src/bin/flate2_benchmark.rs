extern crate flate2;
extern crate libflate;

use std::fs::File;
use std::io::BufReader;
use std::io::{copy, Read};
use std::time::Instant;

fn run (d: &mut Box<Read>, start: Instant) -> (u64, usize) {
    let mut v = vec![];
    let size = copy(d, &mut v).expect("Failed to decode") as usize;
    let duration = start.elapsed();
    return (duration.as_secs() * 1_000 + duration.subsec_nanos() as u64 / 1000_000, size)
}

fn main() {
    let reader = || -> BufReader<File> {
        File::open("../out/nist/2011.json.gz")
            .map(BufReader::new)
            .expect("Failed to open file")
    };

    let start = Instant::now();
    let mut d = Box::new(flate2::read::GzDecoder::new(reader())) as Box<Read>;
    let (duration, uncompressed_size) = run(&mut d, start);
    println!("- Rust (flate2 - zlib): Decompressing took {} ms to {} bytes", duration, uncompressed_size);
}
