#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "lexeme.h"

const char *string_of_lexeme_type(char lexeme_type) {
  switch(lexeme_type) {
  case LEXEME_ATOM:           return "Atom";
  case LEXEME_NUMBER:         return "Number";
  case LEXEME_STRING:         return "String";
  case LEXEME_CHAR:           return "Char";
  case LEXEME_LEFT_BRACKET:   return "LeftBracket";
  case LEXEME_RIGHT_BRACKET:  return "RightBracket";
  case LEXEME_LEFT_ARROW:     return "LeftArrow";
  case LEXEME_COMMENT:        return "Comment";
  default:                    return "Unknown";
  }
}

char *inspect_lexeme(lexeme lex) {
  const char *type_string = string_of_lexeme_type(lex.lexeme_type);

  size_t inspect_string_length = strlen(type_string) + lex.size + 4;
  printf("%u\n", inspect_string_length);
  fflush(stdout);
  char *inspect_string = (char *)malloc(inspect_string_length * sizeof(char));
  if(inspect_string == NULL) {
    return NULL;
  }

  if(0 > sprintf(inspect_string, "%s(`%.*s`)", type_string, inspect_string_length, inspect_string)) {
    free(inspect_string);
    return NULL;
  }

  return inspect_string;
}
