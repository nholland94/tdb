staload "prelude/SATS/filebas.sats"

staload "buffer_reader.sats"

implement main0() = {
  val file = fileref_open_exn("test.t", file_mode_r)
  val str_p = fileref_get_file_string(file)
  val () = fileref_close(file)
  val str = strptr2string(str_p)
  val str_length = string_length(str)

  val reader = buffer_reader_wrap_ptr<char>(string2ptr(str), str_length)
  val c = buffer_reader_read(reader)
  val () = print_char(c)
  val _ = buffer_reader_unwrap_ptr(reader)
}
