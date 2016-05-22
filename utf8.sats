staload "libats/SATS/dynarray.sats"
staload "libc/SATS/string.sats"

fun read_utf8_rune_from_string
      {n:int} (str: string(n)):
      [c:int | 1 <= c; c <= 4]
      (string(n+c), uint16)

fun decode_utf8_from_string {n:int} (str: string n): dynarray(uint16)
