staload "prelude/SATS/string.sats"
staload "buffer.sats"

extern fun make_test_str(): [l:addr] (bytes 12 @ l, mfree_gc_v l | ptr l) = "sta#"
extern fun {l:addr} free_test_str(bytes 12 @ l, mfree_gc_v l | ptr l): void = "mac#ATS_MFREE"

%{^
static char *make_test_str() {
  char *str = malloc(13);
  char *seed = "abcdefghijkl";
  for(int i = 0; i < 13; i++) str[i] = seed[i];
  return str;
}
%}

implement main0() = {
  val (str_pf, str_gcpf | str_p) = make_test_str()
  val buf = buffer_from_bytes_ptr(str_pf | str_p, 12)
  val () = print_char(buffer_read(buf))
  val () = print_char(buffer_read(buf))
  val () = print_char(buffer_read(buf))
  prval () = buffer_done(buf)
  val () = free_test_str(str_pf, str_gcpf | str_p)
}
