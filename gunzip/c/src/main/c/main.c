#include <zlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdlib.h>

struct Buffer {
  char* data;
  size_t size;
  size_t offset;
};

void buffer_init(struct Buffer* buffer) {
  buffer->data = malloc(4*1024);
  buffer->size = 4*1024;
  buffer->offset = 0;
}

void buffer_grow(struct Buffer* buffer) {
  buffer->data = realloc(buffer->data, buffer->size * 2);
  buffer->size = buffer->size * 2;
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
  char buffer[4096];
  z_size_t bytesRead;
  int res;
  struct timeval startTime;
  struct timeval endTime;
  struct Buffer uncompressed;

  res = gettimeofday(&startTime, 0);

  buffer_init(&uncompressed);

  gzip = gzopen("../out/nist/2011.json.gz", "rb");

  bytesRead = gzread(gzip, buffer_get(&uncompressed, 4096), 4096);
  buffer_append(&uncompressed, bytesRead);

  while (bytesRead > 0) {
    bytesRead = gzread(gzip, buffer_get(&uncompressed, 4096), 4096);
    if (bytesRead > 0) {
      buffer_append(&uncompressed, bytesRead);
    }
  }

  gzclose(gzip);

  res = gettimeofday(&endTime, 0);
  {
    struct timeval delta;
    long ms;

    timersub(&endTime, &startTime, &delta);
    ms = delta.tv_sec * 1000 + delta.tv_usec / 1000;

    printf("- C: Decompressing took %ld ms to %ld bytes\n", ms, buffer_total(&uncompressed));
  }

  return 0;
}
