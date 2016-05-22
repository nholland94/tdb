sum ← {+/⍵}
⎕ ← sum ⍳5

⍝⍝⍝ AST
⍝ assign(atom(sum), function(op_reduce(fn_add, scalar(arg(r)))))
⍝ assign(sym(quad), function(call(atom(sum), fn_iota(scalar(0, 5))))

⍝⍝⍝ ABSTRACT OPERATION TREE
⍝ output(reduce(opcode_add, const_vector(1, 2, 3, 4, 5)))

⍝⍝⍝ BYTECODE ASSEMBLY
⍝ %vec: {1;4}[1, 2, 3 ,4]
⍝ %reduce_val: 5
⍝ -- %reduce_val: {0}[5]
⍝ vec_loop_start %vec
⍝ .l: add %reduce_val, %loop_val
⍝ vec_loop .l
⍝ output_num %reduce_val
