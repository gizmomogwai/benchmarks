#!/usr/bin/env ruby
require "zlib"
start_time = Time.now
uncompressed_data = nil
Zlib::GzipReader.open("../out/nist/2011.json.gz") { | gz |
  uncompressed_data = gz.read
}
end_time = Time.now
puts("Ruby: Decompressing took #{((end_time - start_time)*1000).to_i}ms to #{uncompressed_data.size} bytes")
