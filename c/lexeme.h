#ifndef _LEXEME_H_
#define _LEXEME_H_

#include <stdint.h>
#include "utf8.h"

typedef struct lexeme {
  char lexeme_type;
  rune *location;
  uint8_t size;
} lexeme;

#define LEXEME_ATOM          0
#define LEXEME_NUMBER        1
#define LEXEME_STRING        2
#define LEXEME_CHAR          3
#define LEXEME_LEFT_BRACKET  4
#define LEXEME_RIGHT_BRACKET 5
#define LEXEME_LEFT_ARROW    6
#define LEXEME_COMMENT       7
#define LEXEME_UNKNOWN       0xFF

const char *string_of_lexeme_type(char lexeme_type);
char *inspect_lexeme(lexeme lex);

#endif
