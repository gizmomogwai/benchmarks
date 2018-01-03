current_dir := $(shell pwd)
run: out/nist/2011.json.gz
	cd dlang && dub --quiet clean && dub run --quiet --build=release --compiler=ldc2
	cd dlang && dub --quiet clean && dub run --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --quiet --build=release --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --config=Appender --quiet --build=release --compiler=ldc2
	cd dlang-iopipe && dub --quiet clean && dub run --config=Appender --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --quiet --build=release --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --config=FastAppender --quiet --build=release --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --config=FastAppender --quiet --build=release-nobounds --compiler=ldc2
	cd dlang-lowlevel && dub --quiet clean && dub run --config=NoCopy --quiet --build=release-nobounds --compiler=ldc2
	cd $(current_dir) && cd java && ./gradlew --quiet
	cd $(current_dir) && cd ruby && ./gunzip_benchmark.rb
	cd $(current_dir) && cd python && ./gunzip_benchmark.py
	cd $(current_dir) && cd c && make clean gunzip_benchmark && ./gunzip_benchmark
	cd ${current_dir} && cd rust && cargo run -q --release

out/nist/2011.json.gz:
	mkdir -p out/nist
	curl -s https://static.nvd.nist.gov/feeds/json/cve/1.0/nvdcve-1.0-2011.json.gz > out/nist/2011.json.gz

clean:
	rm -rf out

format:
	find . -name "*.d" | xargs dfmt -i
