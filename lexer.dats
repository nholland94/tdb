staload "arrayptr_ext.sats"

implement decode_utf8(raw_data, size) = utf8_data where {
  val (utf8_data_pf, utf8_data_pfgc | utf8_data_p) = array_ptr_alloc<char>(size)
  val utf8_data = arrayptr_encode(utf8_data_pf, utf8_data_pfgc | utf8_data_p)

  fun read_packed_utf8_character
        {n,c:int | 1 <= c; c <= 3}
          (buf: !arrayptr(char, n) >> arrayptr(char, n-c), base: char,
          extra_bytes: int c): rune =
    let
      fun reduce_value
            {n,c:nat}
            (buf: !arrayptr(char, n) >> arrayptr(char, n-c),
              count: int c): rune =
        if count = 0 then 0 else let
            val head = arrayptr_pop(buf)
            val value = (0b00111111 land head): uint16_t
            val new_count = count - 1
          in (value << (6 * new_count) lor reduce_value(buf, new_count)

      val shifted_base = base << (6 * extra_bytes)
    in shifted_base land reduce_value(buf, count)

  fun read_utf8_character
        {n,c:int | 1 <= c; c <= 4}
        (buf: !arrayptr(char, n) >> arrayptr(char, n-c)): rune =
    let
      val root = pop_char(buf)
      val extra_bytes = case+ 0b11111000 land root of
        | 0b11000000 => 1
        | 0b11100000 => 2
        | 0b11110000 => 3
        | _          => 0
    in
      if extra_bytes = 0 then
        (root : rune)
      else
        read_packed_utf8_character(buf, root, extra_bytes)

  fun loop {n:int} (buf: !arrayptr(char, n) >> arrayptr(char, 0)): 
}

// viewt@ype buffer(l: addr, size: int) = array_v(char, l, size)

// typedef buffer(size: int, pos: int) =
//   [l:addr, i:nat | i <= n]
//   {base = array_v(char, l, n), pos = int(n)}

// dataview buffer_v(array_v(char, addr, int), array_v(char, addr, int))) =
//   | buffer_v_available
//       {size,available,pos:int | pos = size - available}
//       {lb,l:addr | lb + (sizeof<char> * pos)}
//       (array_v(char, lb, size), array_v(char, l, available)) of
//         (char @ l, pos)
// 
// 
//   | buffer_v_eof(size, size)
//   | buffer_v_available {pos:nat | pos < size} (size, pos) of buffer_v(size, pos)

// fun read_char
//       {l:addr} {sz:int | sz > 0}
//       (buf: buffer(l, sz) | bufp: ptr(l)):
//       [l2:addr | l2 = l + sizeof(char)]
//       [sz2:int | sz2 = sz - 1]
//       (buffer(l2, sz2) | ptr(l2), char) =
//   array_v_get_at_gint(buffer.base, buffer.pos)
// 
// // NOTE: does not copy to new array
// fun read_char_array
//       {l:addr} {bufsize,sz:int | sz < bufsize}
//       (buf: buffer(l, bufsize) | bufp: ptr(l), size: int(sz)):
//       [l2:addr | l2 = l + (sz * sizeof(char))] [bufsize2:int | bufsize2 = bufsize - sz]
//       (buffer(l2, bufsize2), array_v(char, l, sz) | ptr(l2), ptr(l)) =
//   let
//     prval arr_pf = array_v_cons(char, l, sz)
//     val bufp2 = ptr_add<char>(bufp, i2sz(size))
//     prval buf2 = array_v_cons(char, l + (sz * sizeof(char)), bufsize - sz)
//   in (buf2, arr_pf | bufp2, bufp)
// 
// datatype utf8_character =
//   | Char of (char)
//   | Rune of (uint16_t)
// 
// fun read_utf8_rune
//       {l:addr} {bufsize,sz:int | sz > 0}
//       (buf: buffer(l, bufsize) | bufp: ptr(l), size: int(sz)):
//       [l2:addr | l2 = l + (sz * sizeof(char))]
//       [bufsize2:int | bufsize2 = bufsize - sz]
//       (buffer(l2, bufsize2) | ptr(l2), utf8_character) =
//   let
//     val (chars_pf | chars) = read_char_array(buf, size)
//     fun reduce_value {l:addr, tail:stmsq, n:nat} (arr_pf: array_v(char, l, n) | head: ptr(l)): uint16_t = let         
//         prval (head_pf, tail_pf) = array_v_uncons(arr_pf)
//         val value = (0b00111111 land !head): uint16_t
//         val tail = ptr_succ<char>(head)
//       in (value << (6 * n)) lor reduce_value(tail_pf | tail)
//     val value = reduce_value(chars_pf | chars)
//   in Rune(value)
// 
// fun read_utf8_character(buf: buffer): utf8_character = let
//     val root = read_char(buf)
//     // Could be calculated with bitwise math, but this probably takes less operations
//     val pack_size = case+ 0b11111000 land root of
//       | 0b11000000 => 1
//       | 0b11100000 => 2
//       | 0b11110000 => 3
//       | _          => 0
//   in
//     if pack_size > 0 then read_utf8_rune(buf, pack_size - 1) else Char(root)
// 
// fun get_token {n:nat} {i:int | i < n} (source: string(n), index: int(i)): [i2:int | i2 > i] (token, int(i2)) = let
//   val tok = case+ source[index] of
//     | '{' => (LEFT_BRACKET, i + 1)
//     | '}' => (RIGHT_BRACKET, i + 1)
//     | _ => 
// 
// implement lex_from_string(source) = let
//     fun loop {n1:int} (index: int(i), ls: list_vt(token, n1)): [n2:int | n2 = n1 || n2 = n1 + 1] list_vt(token, n2) =
//       if len = i then list_vt_cons(token, ls) else ls
//   in
//     loop(0, list_vt_nil())
