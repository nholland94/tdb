staload UN = "prelude/SATS/unsafe.sats"
staload "libats/SATS/dynarray.sats"

staload "utf8.sats"

// TODO: fix infix operators

fun string_advance {n,c:int | c > 0} (str: string n, count: int c): string(n-c) =
  $UN.cast{string(n-c)}(ptr_add<char>(string2ptr(str), i2sz(count)))

fun uint16_to_uint(a: uint16): uint = $UN.cast{uint}(a)

fun calculate_packed_utf8_rune
      {n:int | 1 <= n; n <= 3}
      (base: uint16, extra_bytes: string n): uint16 =
  let
    fun reduce_value
          {n,c:nat | n > 0}
          (str: string n, count: size_t c): uint16 =
      if count = i2sz(0) then $UN.cast{uint16}(0) else let
          val head = string_head(str)
          val tail = string_tail(str)
          val value = (0x3Fu land char2ui(head))
          val new_count = count - 1
          val shifted_value = g0uint_lsl(value, 6 * sz2i(new_count))
          val next_value = uint16_to_uint(if count = 0 then $UN.cast{uint16}(0) else reduce_value(tail, new_count))
        in shifted_value lor next_value end

    val extra_bytes_count = string_length(extra_bytes)
    val shifted_base = g0uint_lsl(base, 6 * sz2i(extra_bytes_count))
  in shifted_base land reduce_value(extra_bytes, extra_bytes_count) end

implement read_utf8_rune_from_string(str) = let
    val root = string_head(str)
    val root_rune: uint16 = char2ui(root)
    val extra_bytes = case+ 0xF8u land root_rune of
      | 0xC0u => 1u
      | 0xE0u => 2u
      | 0xF0u => 3u
      | _     => 0u
  in
    if extra_bytes = 0u then
      (string_tail(str), root_rune)
    else let
        val substr = string_make_substring(str, i2sz(0), u2sz(extra_bytes))
        val character = calculate_packed_utf8_rune(root_rune, strnptr2string(substr))
        val tail = string_advance(str, u2i(extra_bytes))
      in (tail, character) end
  end

implement decode_utf8_from_string(str) = arr where {
  val arr = dynarray_make_nil(i2sz(64))

  fun loop {n:int} (str: string n, arr: !dynarray uint16): void =
    if string_is_empty(str) then () else let
        val (str, r) = read_utf8_rune_from_string(str)
      in
        dynarray_insert_atend_exn(arr, r);
        loop(str, arr)
      end

  val () = loop(str, arr)
}
