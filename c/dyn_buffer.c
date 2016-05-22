#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "dyn_buffer.h"

dyn_buffer *create_dyn_buffer(size_t element_size) {
  size_t initial_cap = DYN_BUFFER_CHUNK_SIZE;
  dyn_buffer *buffer = (dyn_buffer *)malloc(sizeof(dyn_buffer));
  if(buffer == NULL) {
    return NULL;
  }

  buffer->element_size = element_size;
  buffer->element_count = 0;
  buffer->current_cap = initial_cap;

  buffer->base = (void *)malloc(initial_cap * element_size);
  if(buffer->base == NULL) {
    free(buffer);
    return NULL;
  }

  return buffer;
}

void clean_dyn_buffer(dyn_buffer *buffer) {
  free(buffer->base);
  free(buffer);
}

dyn_buffer *dyn_buffer_wrap(void *base, size_t element_size, size_t element_count) {
  dyn_buffer *buffer = (dyn_buffer *)malloc(sizeof(dyn_buffer));
  if(buffer == NULL) {
    return NULL;
  }

  buffer->base = base;
  buffer->element_size = element_size;
  buffer->element_count = element_count;

  return buffer;
}

void* dyn_buffer_unwrap(dyn_buffer *buffer) {
  void *array_ptr = buffer->base;
  free(buffer);
  return array_ptr;
}

void dyn_buffer_increment_size(dyn_buffer *buffer) {
  buffer->current_cap += DYN_BUFFER_CHUNK_SIZE;
  printf("%u\n", buffer->current_cap);
  fflush(stdout);
  buffer->base = realloc(buffer->base, buffer->current_cap * buffer->element_size);
}

bool dyn_buffer_push(dyn_buffer *buffer, void *element) {
  if(buffer->element_count >= buffer->current_cap) {
    dyn_buffer_increment_size(buffer);

    if(buffer->base == NULL) {
      return false;
    }
  }

  // something in here is fucked

  buffer->element_count++;

  size_t buffer_size = buffer->element_size * buffer->element_count;
  memcpy(buffer->base + buffer_size, element, buffer->element_size);

  return true;
}

bool dyn_buffer_copy(dyn_buffer *buffer, void *src_elements, size_t count) {
  // TODO write function to increment size to a requirement
  while(buffer->element_count + count > buffer->current_cap) {
    dyn_buffer_increment_size(buffer);

    if(buffer->base == NULL) {
      return false;
    }
  }

  size_t buffer_size = buffer->element_size * buffer->element_count;
  buffer->element_count += count;
  memcpy(buffer->base + buffer_size, src_elements, buffer->element_size * count);

  return true;
}

void *dyn_buffer_get_at(dyn_buffer *buffer, size_t index) {
  if(index >= buffer->element_count) {
    return NULL;
  }

  return buffer->base + (buffer->element_size * index);
}
