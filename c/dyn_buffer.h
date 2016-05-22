#ifndef _DYN_RUNE_BUFFER_H_
#define _DYN_RUNE_BUFFER_H_

#include <stddef.h>
#include <stdbool.h>

#define DYN_BUFFER_CHUNK_SIZE 64

typedef struct dyn_buffer {
  void *base;
  size_t element_size;
  size_t element_count;
  size_t current_cap;
} dyn_buffer;

// Does not initialize elements
dyn_buffer *create_dyn_buffer(size_t element_size);
void clean_dyn_buffer(dyn_buffer *buffer);

// Wraps existing flat array with a dyn_buffer
dyn_buffer *dyn_buffer_wrap(void *base, size_t element_size, size_t element_count);

// Frees the dyn_buffer, returning the underlying array ptr
void *dyn_buffer_unwrap(dyn_buffer *buffer);

bool dyn_buffer_push(dyn_buffer *buffer, void *element);
bool dyn_buffer_copy(dyn_buffer *buffer, void *src_elements, size_t count);
void *dyn_buffer_get_at(dyn_buffer *buffer, size_t index);

#endif
