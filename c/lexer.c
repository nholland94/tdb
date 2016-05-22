#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

#include "dyn_buffer.h"

#include "lexer.h"

typedef struct buffer_reader {
  rune *buffer;
  size_t size;
  ptrdiff_t pos;
} buffer_reader;

static inline rune *buffer_reader_get_current_pointer(buffer_reader *reader) {
  return reader->buffer + reader->pos;
}

static void buffer_reader_skip(buffer_reader *reader) {
  // TODO: actual error handling
  if(reader->pos >= reader->size) {
    printf("overread buffer reader!\n");
    exit(1);
  }

  reader->pos++;
}

static rune buffer_reader_read_rune(buffer_reader *reader) {
  // TODO: actual error handling
  if(reader->pos >= reader->size) {
    printf("overread buffer reader!\n");
    exit(1);
  }

  rune r = *buffer_reader_get_current_pointer(reader);
  reader->pos++;
  return r;
}

static inline bool buffer_reader_eof(buffer_reader *reader) {
  return reader->pos >= reader->size;
}

bool is_whitespace(rune c) {
  return c == ' ' || c == '\n';
}

bool is_special_symbol(rune c) {
  #define OTHER_CHARACTERS_COUNT 24

  static rune other_characters[OTHER_CHARACTERS_COUNT] = {
    0x007C, // pipe(1)
    0x007E, // tilde(1)
    0x00AF, // macron
    0x00D7, // multiplication
    0x00F7, // division
    0x2218, // ring
    0x2223, // pipe(2)
    0x223C, // tilde(2)
    0x2260, // not equal
    0x2264, // less than or equal to
    0x2265, // greater than or equal to
    0x22C6, // star
    0x2227, // logical and
    0x2228, // logical or
    0x2229, // interesection
    0x222A, // union
    0x2308, // left ceiling
    0x230A, // left floor
    0x22A4, // down tack
    0x22A5, // up tack
    0x2282, // subset of
    0x2283  // superset of
  };


  // basic math symbols
  if(0x2A <= c && c <= 0x2F) {
    return true;
  }

  // apl characters
  if(0x2336 <= c && c <= 0x237A) {
    return true;
  }

  for(int i = 0; i < OTHER_CHARACTERS_COUNT; i++) {
    if(other_characters[i] == c) {
      return true;
    }
  }

  return false;
}

bool is_alpha(rune c) {
  return ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z');
}

bool is_numeric(rune c) {
  return '0' <= c && c <= '9';
}

size_t count_until(buffer_reader *reader, rune stop) {
  size_t size = 0;
  while(buffer_reader_read_rune(reader) != stop) {
    size++;
  }

  return size;
}

size_t count_atom(buffer_reader *reader) {
  size_t size = 1;
  while(is_alpha(buffer_reader_read_rune(reader))) {
    size++;
  }

  return size;
}

size_t count_number(buffer_reader *reader) {
  size_t size = 1;
  while(is_numeric(buffer_reader_read_rune(reader))) {
    size++;
  }

  return size;
}

void check_char(buffer_reader *reader) {
  buffer_reader_skip(reader);

  if(buffer_reader_read_rune(reader) != '\'') {
    printf("Invalid char literal!");
    exit(1);
  }
}

size_t count_string(buffer_reader *reader) {
  return count_until(reader, (rune)'\"');
}

lexeme read_token(buffer_reader *reader) {
  lexeme lex;
  rune c;

  lex.lexeme_type = LEXEME_UNKNOWN;

  do {
    lex.location = buffer_reader_get_current_pointer(reader);
    buffer_reader_skip(reader);
    c = *lex.location;
    // c = buffer_reader_read_rune(reader);
  } while(is_whitespace(c));

  if(is_special_symbol(c)) {
    lex.lexeme_type = LEXEME_ATOM;
    lex.size = 1;
  } else if(is_alpha(c)) {
    lex.lexeme_type = LEXEME_ATOM;
    lex.size = count_atom(reader);
  } else if(is_numeric(c)) {
    lex.lexeme_type = LEXEME_NUMBER;
    lex.size = count_number(reader);
  } else {
    switch(c) {
    case '\'':
      lex.lexeme_type = LEXEME_CHAR;
      lex.location++;
      lex.size = 1;
      check_char(reader);
      break;

    case '"':
      lex.lexeme_type = LEXEME_STRING;
      lex.location++;
      lex.size = count_string(reader);
      break;

    case '{':
      lex.lexeme_type = LEXEME_LEFT_BRACKET;
      lex.size = 1;
      break;

    case '}':
      lex.lexeme_type = LEXEME_RIGHT_BRACKET;
      lex.size = 1;
      break;

    case 0x2190: // left arrow
      lex.lexeme_type = LEXEME_LEFT_ARROW;
      lex.size = 1;
      break;

    case 0x235D: // up shoe jot
      lex.lexeme_type = LEXEME_COMMENT;
      lex.size = count_until(reader, '\n') + 1;
      break;

    default:
      printf("Unhandled character in lexer: %4x\n", c);
      lex.size = 1;
    }
  }

  return lex;
}

lexeme *lex_runes(rune *runes, size_t runes_size, size_t *lexemes_size) {
  buffer_reader *reader = (buffer_reader *)malloc(sizeof(buffer_reader));
  reader->buffer = runes;
  reader->size = runes_size;
  reader->pos = 0;

  dyn_buffer *lexbuf = create_dyn_buffer(sizeof(lexeme));

  while(!buffer_reader_eof(reader)) {
    lexeme lex = read_token(reader);
    if(!dyn_buffer_push(lexbuf, &lex)) {
      clean_dyn_buffer(lexbuf);
      return NULL;
    }
  }

  free(reader);

  *lexemes_size = lexbuf->element_count;
  return (lexeme *)dyn_buffer_unwrap(lexbuf);
}
