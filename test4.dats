staload "prelude/SATS/filebas.sats"
staload "prelude/SATS/string.sats"
staload "libats/SATS/dynarray.sats"

staload "libatslex/SATS/unicode.sats"

implement main0() = {
  val file = fileref_open_exn("test.t", file_mode_r) 
  val str_p = fileref_get_file_string(file)
  val () = fileref_close(file)
  val str = strptr2string(str_p)

  val alloc_size = 64
  val utf8_arr = dynarray_make_nil(i2sz(alloc_size))
  implement {} dynarray$recapacitize(): int = alloc_size

  // val (index_pf, index_gcpf | index) = malloc_gc(sizeof<int>)
  // val () = !index := 0
  var index: int = 0
  val err: int = 0

  implement {} utf8_decode$fget(): int = c where {
    // val index_value = ptr_get(index_pf | index)
    val c = string_get_at(str, !index)
    val () = !index := !index + 1
  }

  fun loop(): void =
    if string_is_atend(!index) then () else let
        val c = utf8_decode_err(err)
        val () = dynarray_insert_atend_exn(utf8_arr, c)
      in loop() end

  val () = loop()
  val utf8_count = dynarray_get_size(utf8_arr)
  val utf8_arrptr = dynarray_getfree_arrayptr(utf8_arr, utf8_count)

  implement {int} {int} array_foreach$fwork(el, _) = {
    val () = print_string(g0int2string(el))
  }

  val _ = arrayptr_foreach(utf8_arrptr, utf8_count)
  val () = arrayptr_free(utf8_arrptr)
  val () = mfree_gc(index_pf, index_gcpf | index)
}
