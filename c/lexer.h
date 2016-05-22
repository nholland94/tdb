#ifndef _LEXER_H_
#define _LEXER_H_

#include <stddef.h>

#include "unicode.h"
#include "lexeme.h"

lexeme *lex_runes(rune *runes, size_t runes_size, size_t *lexemes_size);

#endif
