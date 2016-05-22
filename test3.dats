staload "prelude/SATS/filebas.sats"
// staload "prelude/SATS/integer.sats"
staload "libats/SATS/dynarray.sats"
staload "libc/SATS/string.sats"

staload "utf8.sats"

#include "share/atspre_staload.hats"

// TODO: fix infix operators

implement main0() = {
  val file = fileref_open_exn("test.t", file_mode_r)
  val str_p = fileref_get_file_string(file)
  val () = fileref_close(file)
  val str = strptr2string(str_p)
  val runes = decode_utf8_from_string(str)
  val runes_size = dynarray_get_size(runes)
  val runes_arrptr = dynarray_getfree_arrayptr(runes, runes_size)
  var env: int = 0
  implement {uint16} {env} array_foreach$fwork(el, env) = {
    val () = print_string(g0int2string(g0uint2int_uint16_int(el)))
  }
  val _ = arrayptr_foreach_env(runes_arrptr, runes_size, env)
  val () = arrayptr_free(runes_arrptr)
  // val () = dynarray_free(runes)
  // val () = print_string(strptr2string(str_p))
  // val p = strptr2ptr(str_p)
}
