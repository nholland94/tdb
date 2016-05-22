staload "buffer_reader.sats"

// implement buffer_reader_get_view(reader) = reader.0
implement {a} buffer_reader_get_ptr(reader) = reader.1
implement {a} buffer_reader_get_size(reader) = reader.2
implement {a} buffer_reader_get_pos(reader) = reader.3

implement {a} buffer_reader_get_current_ptr {s,p} (reader) = let
    val base = buffer_reader_get_ptr(reader)
    val pos = buffer_reader_get_pos(reader)
    val ptr = base + pos
    prval reader_base_v = buffer_reader_get_view(reader)
    prval reader_indexed_v = buffer_reader_v_index(p)
    prval ptr_pf = addr@(reader_indexed_v)
  in (ptr_pf | ptr) end

implement {a} buffer_reader_read {s,p} (reader) = let
    val (ptr_pf | ptr) = buffer_reader_get_current_ptr(reader)
    // TODO: increment reader size
  in !ptr end
