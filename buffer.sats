staload "prelude/SATS/memory.sats"
staload "prelude/SATS/arrayptr.sats"

vtypedef buffer_vtype(l: addr, size: int, pos: int) = (bytes size @ l | ptr l, int size, int pos)
vtypedef buffer(size: int, pos: int) = [l:addr] buffer_vtype(l, size, pos)

praxi lemma_buffer_param {size,pos:int} (!buffer(size, pos)):
  [0 <= size; 0 <= pos; pos <= size] void
// praxi lemma_buffer_at_end_param {l:addr} {size,pos:int} (!buffer(l, size, pos)): [pos = size] void

// fun buffer_alloc {sz:int} (size: size_t(sz)):<!wrt> [l:addr] buffer(l, sz, 0)
// fun buffer_free(buffer(addr, int, int)):<!wrt> void

prfun buffer_done {size,pos:int} (buffer(size, pos)): void

fun buffer_from_bytes_ptr {l:addr} {sz:int} (!bytes sz @ l | ptr l, size: int sz): [pos:int] buffer_vtype(l, sz, pos)

fun buffer_get_current_ptr {l:addr} {sz,p:int} (buffer_vtype(l, sz, p)): ptr l

fun buffer_read
  {sz,p:int | p < sz}
  (!buffer(sz, p) >> buffer(sz, p+1)):
  char

fun buffer_read_array
  {sz,p,c:int | 0 < c; c + p <= sz}
  (!buffer(sz, p) >> buffer(sz, p+c), count: int c):
  [l:addr]
  arrayptr(char, l, c)

fun buffer_skip
  {sz,p,c:int | 0 < c; c + p <= sz}
  (!buffer(sz, p) >> buffer(sz, p+c), count: int c):
  void
