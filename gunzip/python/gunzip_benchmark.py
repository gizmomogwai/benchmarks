#!/usr/bin/env python3
import gzip
import time

start_time = time.time()
with gzip.open('../out/nist/2011.json.gz') as f:
    uncompressed_data = f.read();
end_time = time.time()
print("- Python: Decompressing took {} ms to {} bytes".format(int((end_time-start_time)*1000), len(uncompressed_data)))
