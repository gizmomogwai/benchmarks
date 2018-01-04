extern crate flate2;
extern crate libflate;

use std::fs::File;
use std::io::BufReader;
use std::io::{copy, Read};
use std::time::Instant;

fn run (d: &mut Box<Read>) -> u64 {
    let start = Instant::now();
    copy(d, &mut vec![]).expect("Failed to decode") as usize;
    let duration = start.elapsed();
    duration.as_secs() * 1_000 + duration.subsec_nanos() as u64 / 1000_000
}

fn main() {
    let reader = || -> BufReader<File> {
        File::open("../out/nist/2011.json.gz")
            .map(BufReader::new)
            .expect("Failed to open file")
    };

    let mut d = Box::new(libflate::gzip::Decoder::new(reader()).expect("Failed to create decoder")) as Box<Read>;
    println!("- Rust (libflate): Decompressing took {} ms", run(&mut d));

    let mut d = Box::new(flate2::read::GzDecoder::new(reader())) as Box<Read>;
    println!("- Rust (flate2 - zlib): Decompressing took {} ms", run(&mut d));
}
