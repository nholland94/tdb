staload "prelude/SATS/list_vt.sats"

staload "prelude/SATS/arrayptr.sats"
staload "token.sats"

fun decode_utf8 {n:int} (raw_data: arrayptr(char, n), size: size_t n): [l:addr] (arrayptr(char, l, n)
fun lex_from_string(source: string): [n:int] list_vt (token, n)
