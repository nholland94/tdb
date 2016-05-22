dataview buffer_reader_v(a: vt@ype+, addr, int, int) =
  | {l:addr} {n:nat}
    buffer_reader_v_nil(a, l, n, n)
  | {l:addr} {size,pos:nat | pos < size}
    buffer_reader_v_cons(a, l + sizeof(a), size, pos + 1) of (a @ l, buffer_reader_v(a, l, size, pos))

vtypedef buffer_reader_vtype(a: vt@ype+, l:addr, size: int, pos: int) = (buffer_reader_v(a, l, size, pos) | ptr l, size_t size, size_t pos)
stadef buffer_reader = buffer_reader_vtype
vtypedef buffer_reader(a: vt@ype+, size: int, pos: int) = [l:addr] buffer_reader_vtype(a, l, size, pos)

castfn {a:vt@ype} buffer_reader_wrap_ptr {l:addr} {s:nat} (ptr l, size_t s): buffer_reader(a, l, s, 0)
castfn {a:vt@ype} buffer_reader_unwrap_ptr {l:addr} {s,p:nat} (buffer_reader(a, l, s, p)): ptr l

// fun {a:vt@ype} buffer_reader_get_view {l:addr} {s,p:int} (!buffer_reader(a, l, s, p)): buffer_reader_v(a, l, s, p)
fun {a:vt@ype} buffer_reader_get_ptr {l:addr} {s,p:nat} (!buffer_reader(a, l, s, p)): ptr l
fun {a:vt@ype} buffer_reader_get_size {s,p:nat} (!buffer_reader(a, s, p)): int
fun {a:vt@ype} buffer_reader_get_pos {s,p:nat} (!buffer_reader(a, s, p)): int

fun {a:vt@ype} buffer_reader_get_current_ptr {s,p:nat} (!buffer_reader(a, s, p)): [l:addr] (a @ l | ptr l)
fun {a:vt@ype} buffer_reader_read {s,p:nat | p < s} (!buffer_reader(a, s, p) >> buffer_reader(a, s, p+1)): a
