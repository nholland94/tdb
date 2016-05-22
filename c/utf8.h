#ifndef _UTF8_DECODER_H_
#define _UTF8_DECODER_H_

#include <stddef.h>

#include "unicode.h"

rune *decode_utf8_string(char *str, size_t str_len, size_t *unicode_length);
char *encode_utf8_string(rune *utf8_string, size_t utf8_length, size_t *char_string_length);

#endif
