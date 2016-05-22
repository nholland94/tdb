#include <stdlib.h>
#include <stdio.h>

#include "utf8.h"
#include "lexer.h"

int main(int argc, char **argv) {
  FILE *f = fopen("../test.t", "rb");
  if(f == NULL) {
    printf("Failed to open file\n");
    return 1;
  }

  fseek(f, 0, SEEK_END);
  long length = ftell(f);
  fseek(f, 0, SEEK_SET);

  char *file_buffer = (char *)malloc((size_t)length);
  if(file_buffer == NULL) {
    printf("Failed to alloc buffer\n");
  }

  fread(file_buffer, 1, length, f);
  fclose(f);

  size_t utf8_length;
  rune *utf8_string = decode_utf8_string(file_buffer, length, &utf8_length);
  // TODO: free(file_buffer);
  if(utf8_string == NULL) {
    printf("Failed to decode utf8\n");
    return 1;
  }

  // printf("utf8_length: %d\n", utf8_length);

  // for(int i = 0; i < utf8_length; i++) {
  //   printf("%d: %04x\n", i, *(utf8_string + i));
  // }

  // size_t reencoded_length;
  // char *reencoded = encode_utf8_string(utf8_string, utf8_length, &reencoded_length);

  // for(int i = 0; i < reencoded_length; i++) {
  //   char c1 = *(file_buffer + i);
  //   char c2 = *(reencoded + i);

  //   if(c1 != c2) {
  //     printf("%d: %2x\n", i, c1 & 0xFF);
  //     printf("%d: %2x\n", i, c2 & 0xFF);
  //   }
  // }

  size_t lexemes_length;
  lexeme *lexemes = lex_runes(utf8_string, utf8_length, &lexemes_length);
  if(lexemes == NULL) {
    printf("Failed to lex utf8 string\n");
    return 1;
  }

  printf("lexemes_length: %d\n", lexemes_length);

  for(int i = 0; i < lexemes_length; i++) {
    lexeme lex = *(lexemes + i);
    inspect_lexeme(lex);

    // size_t encoded_string_length;
    // char *encoded_string = encode_utf8_string(lex.location, lex.size, &encoded_string_length);
    // printf("%u: %.*s\n", lex.lexeme_type, encoded_string_length, encoded_string);
  }

  fflush(stdout);

  free(lexemes);
  free(utf8_string);

  return 0;
}
