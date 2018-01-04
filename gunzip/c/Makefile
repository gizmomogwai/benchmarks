gunzip_benchmark_malloc_free: src/main/c/main.c Makefile
	gcc \
    -DVARIANT_MALLOC_FREE \
    src/main/c/main.c \
    -o $@ \
    -lz \
#    -fsanitize=address \
#    -fno-omit-frame-pointer \

gunzip_benchmark_realloc: src/main/c/main.c Makefile
	gcc \
    -DVARIANT_REALLOC \
    src/main/c/main.c \
    -o $@ \
    -lz \
#    -fsanitize=address \
#    -fno-omit-frame-pointer \

all: gunzip_benchmark_malloc_free gunzip_benchmark_realloc

clean:
	rm -f gunzip_benchmark*
