#include <stdlib.h>
#include <stdio.h>

#include "utf8.h"
#include "dyn_buffer.h"

static rune read_utf8_packed_character(rune base, char *str, int size) {
  rune character = (base << (6 * size));
  while(--size >= 0) {
    rune value = (0x3F & *str);

    character = (value << (6 * size)) | character;

    str++;
  }

  return character;
}

rune *decode_utf8_string(char *str, size_t str_len, size_t *unicode_length) {
  dyn_buffer *raw_unicode_buffer = create_dyn_buffer(sizeof(char));

  // #define BUFFER_SIZE 64
  // rune *unicode = (rune *)malloc(BUFFER_SIZE);
  // if(unicode == NULL) {
  //   return NULL;
  // }

  // size_t unicode_cap = BUFFER_SIZE;
  // *unicode_length = 0;
  char *str_top = str + str_len;

  while(str_len > 0) {
    rune root = (rune)*(str_top - str_len);
    str_len--;

    int extra_bytes = 0;
    switch(0xF8 & (char)root) {
    case 0xC0:
      extra_bytes = 1;
      root = 0x1F & root;
      break;
    case 0xE0:
      root = 0x0F & root;
      extra_bytes = 2;
      break;
    case 0xF0:
      root = 0x07 & root;
      extra_bytes = 3;
    }

    rune character;
    if(extra_bytes == 0) {
      character = root;
    } else {
      if(extra_bytes > str_len) {
        clean_dyn_buffer(raw_unicode_buffer);
        return NULL;
      }

      character = read_utf8_packed_character(root, str_top - str_len, extra_bytes);
      str_len -= extra_bytes;
    }

    dyn_buffer_push(raw_unicode_buffer, &character);

    // if(*unicode_length == unicode_cap) {
    //   unicode_cap += BUFFER_SIZE;

    //   printf("%u\n", unicode_cap);
    //   fflush(stdout);

    //   unicode = realloc(unicode, unicode_cap);
    //   if(unicode == NULL) {
    //     return NULL;
    //   }
    // }

    // *(unicode + *unicode_length) = character;
    // (*unicode_length)++;
  }

  *unicode_length = raw_unicode_buffer->element_count;
  return dyn_buffer_unwrap(raw_unicode_buffer);
}

char *encode_utf8_string(rune *utf8_string, size_t utf8_length, size_t *char_string_length) {
  dyn_buffer *output_buffer = create_dyn_buffer(sizeof(char));
  char *char_buffer = malloc(sizeof(char) * 4);

  for(int i = 0; i < utf8_length; i++) {
    rune r = *(utf8_string + i);
    int character_length;

    if(r < 0x0080) {
      *char_buffer = (char)r;
      character_length = 1;
    } else {
      // Could be done mathematically, but this is faster
      if(r < 0x0800) {
        character_length = 2;
        *char_buffer = 0xC0 | (0x1F & (r >> 6));
      } else if(r < 0x00010000) {
        character_length = 3;
        *char_buffer = 0xE0 | (0x0F & (r >> 12));
      } else {
        character_length = 4;
        *char_buffer = 0xF0 | (0x07 & (r >> 18));
      }

      int extra_bytes = character_length - 1;
      char *char_buffer_top = char_buffer + extra_bytes;

      for(int j = 0; j < extra_bytes; j++) {
        int shift_width = 6 * j;
        char c = (char)(0x3F & (r >> shift_width));
        *(char_buffer_top - j) = 0x80 | c;
      }
    }

    if(!dyn_buffer_copy(output_buffer, char_buffer, character_length)) {
      free(char_buffer);
      return NULL;
    }
  }

  free(char_buffer);

  *char_string_length = output_buffer->element_count;
  return dyn_buffer_unwrap(output_buffer);
}
