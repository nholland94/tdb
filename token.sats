datatype token =
  | LEFT_BRACKET
  | RIGHT_BRACKET
  // | LEFT_PAREN
  // | RIGHT_PAREN
  // | LEFT_BRACE
  // | RIGHT_BRACE
  // | LEFT_SINGLE_QUOTE
  // | RIGHT_SINGLE_QUOTE
  // | LEFT_DOUBLE_QUOTE
  // | RIGHT_DOUBLE_QUOTE
  // | BUILTIN_FUNCTION(char) of (char)
  | ATOM(string) of (string)
  | FIXED_NUMBER(string) of (string)
  | FLOATING_NUMBER(string) of (string)
