f.1:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw a0, -8(s0)
  sw a0, -24(s0)
  lw a0, -8(s0)
  sw a0, -32(s0)
  lw t0, -24(s0)
  lw t1, -32(s0)
  mul a0, t0, t1
  lw ra, 0(s0)
  jr ra

g.5:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  sw s1, -24(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  # LetTuple Var(tup.6)
  lw a0, -8(s0)
  mv s1, a0
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -40(s0)
  addi s1, s1, 8
  lw a0, -32(s0)
  sw a0, -48(s0)
  # CallClosure f.1 [_11]
  lw t0, -48(s0)
  sw t0, -64(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -72(s0)
  addi s0, s0, -56
  jalr ra, s1, 0
  addi s0, s0, 56
  # CallClosure End f.1 [_11]
  sw a0, -56(s0)
  lw a0, -40(s0)
  sw a0, -64(s0)
  # CallClosure f.1 [_12]
  lw t0, -64(s0)
  sw t0, -80(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -88(s0)
  addi s0, s0, -72
  jalr ra, s1, 0
  addi s0, s0, 72
  # CallClosure End f.1 [_12]
  sw a0, -72(s0)
  lw t0, -56(s0)
  lw t1, -72(s0)
  add a0, t0, t1
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x100000
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s0, s3, -8
  # MakeClosure f.1
  mv s1, s3
  addi s3, s3, 16
  la t0, f.1
  sw t0, -8(s3)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End f.1
  # MakeClosure g.5
  mv s1, s3
  addi s3, s3, 16
  la t0, g.5
  sw t0, -8(s3)
  li s2, 16
  lw t0, 0(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, 0(s0)
  lw t1, 0(t0)
data_copy_1:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_1
  sw s2, 0(s1)
  sw s1, -8(s0)
  # MakeClosure End g.5
  li a0, 4
  sw a0, -16(s0)
  li a0, 3
  sw a0, -24(s0)
  # MakeTuple MakeTuple([_14, _15])
  mv s1, s3
  li s2, 8
  addi s3, s3, 8
  addi s2, s2, 8
  lw t0, -24(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  sw s2, 0(s1)
  mv a0, s1
  # MakeTuple End MakeTuple([_14, _15])
  sw s3, -32(s0)
  lw t1, 0(a0)
data_copy_reg_loop_2:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_2
  lw a0, -32(s0)
  sw a0, -40(s0)
  # CallClosure g.5 [_17]
  lw t0, -40(s0)
  sw t0, -56(s0)
  lw t0, -40(s0)
  lw t1, 0(t0)
data_copy_3:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_3
  lw t0, -8(s0)
  lw s1, 8(t0)
  sw t0, -64(s0)
  addi s0, s0, -48
  jalr ra, s1, 0
  addi s0, s0, 48
  # CallClosure End g.5 [_17]
  sw a0, -48(s0)
  # Ecall Label("minimbt_print_int") [_16]
  lw a0, -48(s0)
  call minimbt_print_int

