implement arrayptr_head(arr) = arrayptr_get_at(arr, 0)

implement arrayptr_pop(arr) = head where {
  val head = arrayptr_head(arr)
  val () = arrayptr_advance(arr)
}
