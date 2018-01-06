#include <zlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define CHUNK_SIZE 8192

struct Buffer {
  char* data;
  size_t size;
  size_t offset;
};

void buffer_init(struct Buffer* buffer, size_t initialSize) {
  buffer->data = (char*)malloc(initialSize);
  buffer->size = initialSize;
  buffer->offset = 0;
}

void buffer_grow(struct Buffer* buffer) {
  #ifdef VARIANT_REALLOC
  char* old = buffer->data;
  buffer->data = realloc(buffer->data, buffer->size * 2);
  /*
  if (old != buffer->data) {
    printf("did a real realloc\n");
  } else {
    printf("did not a real realloc\n");
  }
  */
  #else
  char* old = buffer->data;
  buffer->data = malloc(buffer->size * 2);
  memcpy(buffer->data, old, buffer->size);
  free(old);
  #endif
  buffer->size = buffer->size * 2;
  // printf("buffer size: %ld\n", buffer->size);
}

char* buffer_get(struct Buffer* buffer, size_t minimalSize) {
  while ((buffer->size - buffer->offset) < minimalSize) {
    buffer_grow(buffer);
  }
  return buffer->data + buffer->offset;
}

void buffer_append(struct Buffer* buffer, size_t read) {
  buffer->offset += read;
}

size_t buffer_total(struct Buffer* buffer) {
  return buffer->offset;
}

int main(int argc, char** args) {
  gzFile gzip;
  int bytesRead;
  int res;
  struct timeval startTime;
  struct timeval endTime;
  struct Buffer uncompressed;

  res = gettimeofday(&startTime, 0);

#ifdef VARIANT_PREALLOCATED
  buffer_init(&uncompressed, 200*1024*1024);
#else
  buffer_init(&uncompressed, CHUNK_SIZE);
#endif

  gzip = gzopen("../out/nist/2011.json.gz", "rb");

  do {
#ifdef VARIANT_PREALLOCATED
    bytesRead = gzread(gzip, buffer_get(&uncompressed, 200*1024*1024), 200*1024*1024);
#else
    bytesRead = gzread(gzip, buffer_get(&uncompressed, CHUNK_SIZE), CHUNK_SIZE);
#endif
    buffer_append(&uncompressed, bytesRead);
#ifdef VARIANT_PREALLOCATED
    break;
#endif
  } while (bytesRead > 0);

  gzclose(gzip);

  res = gettimeofday(&endTime, 0);
  {
    struct timeval delta;
    long ms;

    timersub(&endTime, &startTime, &delta);
    ms = delta.tv_sec * 1000 + delta.tv_usec / 1000;
    #ifdef VARIANT_REALLOC
    #define NAME "realloc"
    #else
    #ifdef VARIANT_PREALLOCATED
    #define NAME "preallocated"
    #else
    #define NAME "malloc_free"
    #endif
    #endif
    printf("- C(%s): Decompressing took %ld ms to %ld bytes\n", NAME, ms, buffer_total(&uncompressed));
  }

  return 0;
}
