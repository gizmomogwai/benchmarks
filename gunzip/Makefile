current_dir := $(shell pwd)
run: out/nist/2011.json.gz
	cd dlang && dub --quiet clean && dub run --quiet --build=release --compiler=ldc2
	cd dlang && dub --quiet clean && dub run --quiet --build=release --compiler=dmd
#	cd dlang && dub --quiet clean && dub run --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --quiet --build=release --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --quiet --build=release --compiler=dmd
#	cd dlang-iopipe && dub --quiet clean && dub run --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --config=Appender --quiet --build=release --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --config=Appender --quiet --build=release --compiler=dmd
#	cd dlang-iopipe && dub --quiet clean && dub run --config=Appender --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --quiet --build=release --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --quiet --build=release --compiler=dmd
#	cd dlang-lowlevel && dub --quiet clean && dub run --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --config=FastAppender --quiet --build=release --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --config=FastAppenderMallocator --quiet --build=release --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --config=FastAppender --quiet --build=release --compiler=dmd
#	cd dlang-lowlevel && dub --quiet clean && dub run --config=FastAppender --quiet --build=release-nobounds --compiler=ldc2
#	cd dlang-lowlevel && dub --quiet clean && dub run --config=FastAppenderMallocator --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --config=NoCopy --quiet --build=release --compiler=ldc2
#	cd dlang-lowlevel && dub --quiet clean && dub run --config=NoCopy --quiet --build=release-nobounds --compiler=dmd
	cd dlang-lowlevel && dub --quiet clean && dub run --config=Preallocated --quiet --build=release --compiler=ldc2
	cd $(current_dir) && cd java && ./gradlew --quiet
	cd $(current_dir) && cd ruby && ./gunzip_benchmark.rb
	cd $(current_dir) && cd python && ./gunzip_benchmark.py
	cd $(current_dir) && cd c && make clean gunzip_benchmark_realloc && ./gunzip_benchmark_realloc
	cd $(current_dir) && cd c && make clean gunzip_benchmark_malloc_free && ./gunzip_benchmark_malloc_free
	cd $(current_dir) && cd c && make clean gunzip_benchmark_preallocated && ./gunzip_benchmark_preallocated
	cd ${current_dir} && cd rust && cargo build --bins --release -q && target/release/flate_benchmark && target/release/flate2_benchmark

out/nist/2011.json.gz:
	mkdir -p out/nist
	curl -s https://static.nvd.nist.gov/feeds/json/cve/1.0/nvdcve-1.0-2011.json.gz > out/nist/2011.json.gz

clean:
	rm -rf out

format:
	find . -iwholename "dlang/**/*.d" | xargs dfmt -i
