#include <stdio.h>
#include <sys/mman.h>

staload "prelude/SATS/basic.sats"
staload "prelude/SATS/option_vt.sats"

abst@ype fileref_t0ype = int
stadef fileref: t@ype = fileref_t0ype

absprop FILEOPEN

extern fun fopen(filename: string, filemode: string): (fileref | FILEOPEN)
extern fun fclose(file: fileref | FILEOPEN): int;

extern fun fseek(file: fileref, offset: long, whence: int): int;
extern fun ftell(file: fileref): long;

extern fun mmap
  {pa:addr} {n:nat}
  (dst: bytes n @ ptr pa, len: size_t n, prot: int, flags: int, file: fileref, offset: off_t):
  [r:ptr | r = 0 || r = pa]
  ptr r

typedef table = @{fd = file_descriptor}

fun read_table(filename: string): table =
  let
    val (file | file_pf) = open(filename, "r")
    val table_header = read_table_header(file)
    val table_start_pos = ftell(file)
    val~+0 = fseek(file, 0, SEEK_END)
    val table_end_pos = ftell(file)
    val~+0 = fseek(file, table_start_pos, SEEK_BEGIN)
    val table_size = table_end_pos - table_start_pos
    val (p | p_pf) = malloc_gc(table_size)
    val~+0 = fread(p, table_size, 1, file)
    val~+0 = fclose(file | file_pf)
  in
