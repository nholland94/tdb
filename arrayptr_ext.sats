staload "prelude/SATS/arrayptr.sats"

fun {a:t@ype} arrayptr_head {n:int | 0 < n} (arr: !arrayptr(INV(a), n)): a

fun {a:t@ype} arrayptr_advance
      {n:int | 0 < n}
      (arr: !arrayptr(a, n) >> arrayptr(a, n-1)): void

fun {a:t@ype} arrayptr_pop
      {n:int | 0 < n}
      (arr: !arrayptr(a, n) >> arrayptr(a, n-1)): a
