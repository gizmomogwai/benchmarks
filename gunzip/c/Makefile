all: gunzip_benchmark_malloc_free gunzip_benchmark_realloc gunzip_benchmark_preallocated

gunzip_benchmark_malloc_free: src/main/c/main.c Makefile
	gcc \
    -O3 \
    -DVARIANT_MALLOC_FREE \
    src/main/c/main.c \
    -o $@ \
    -lz \
#    -fsanitize=address \
#    -fno-omit-frame-pointer \

gunzip_benchmark_realloc: src/main/c/main.c Makefile
	gcc \
    -O3 \
    -DVARIANT_REALLOC \
    src/main/c/main.c \
    -o $@ \
    -lz \

gunzip_benchmark_preallocated: src/main/c/main.c Makefile
	gcc \
    -O3 \
    -DVARIANT_PREALLOCATED \
    src/main/c/main.c \
    -o $@ \
    -lz \

#    -fsanitize=address \
#    -fno-omit-frame-pointer \


clean:
	rm -f gunzip_benchmark*
