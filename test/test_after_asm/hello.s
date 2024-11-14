.data
.text
init_arr.7:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -24(s0)
  addi s1, s1, 8
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw a0, -32(s0)
  sw a0, -40(s0)
  lw a0, -8(s0)
  sw a0, -48(s0)
  lw a0, -24(s0)
  sw a0, -56(s0)
  # ArrayPut ArrayPut(_9, _10, _11, Unit)
  lw t0, -40(s0)
  lw t1, -48(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw t0, -56(s0)
  sw t0, 0(s1)
  # ArrayPut end ArrayPut(_9, _10, _11, Unit)
  mv a0, zero
  lw ra, 0(s0)
  jr ra

gen_arr.1:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  lw a0, -8(s0)
  sw a0, -32(s0)
  li a0, 0
  sw a0, -40(s0)
  # MakeArray MakeArray(_5, _6)
  mv s1, s3
  addi s3, s3, 8
  li t1, 8
  lw s2, -32(s0)
  mul t1, t1, s2
  addi t1, t1, 8
  sw t1, 0(s1)
make_array_loop_1:
  lw t0, -40(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, -1
  beq s2, zero, make_array_end_1
  j make_array_loop_1
make_array_end_1:
  mv a0, s1
  # MakeArray End MakeArray(_5, _6)
  sw s3, -48(s0)
  lw t1, 0(a0)
data_copy_reg_loop_2:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_2
  # MakeClosure init_arr.7
  mv s1, s3
  addi s3, s3, 16
  la t0, init_arr.7
  sw t0, -8(s3)
  li s2, 16
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -48(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -48(s0)
  lw t1, 0(t0)
data_copy_3:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_3
  sw s2, 0(s1)
  sw s1, -56(s0)
  # MakeClosure End init_arr.7
  li a0, 0
  sw a0, -64(s0)
  # CallClosure init_arr.7 [_13]
  lw t0, -64(s0)
  sw t0, -80(s0)
  lw t0, -56(s0)
  lw s1, 8(t0)
  sw t0, -88(s0)
  addi s0, s0, -72
  jalr ra, s1, 0
  addi s0, s0, 72
  # CallClosure End init_arr.7 [_13]
  sw a0, -72(s0)
  lw a0, -48(s0)
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x1
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s0, s3, -8
  # MakeClosure gen_arr.1
  mv s1, s3
  addi s3, s3, 16
  la t0, gen_arr.1
  sw t0, -8(s3)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End gen_arr.1
  li a0, 2
  sw a0, -8(s0)
  li a0, 2
  sw a0, -16(s0)
  # CallClosure gen_arr.1 [_15, _16]
  lw t0, -16(s0)
  sw t0, -32(s0)
  lw t0, -8(s0)
  sw t0, -40(s0)
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -48(s0)
  addi s0, s0, -24
  jalr ra, s1, 0
  addi s0, s0, 24
  # CallClosure End gen_arr.1 [_15, _16]
  sw s3, -24(s0)
  lw t1, 0(a0)
data_copy_reg_loop_4:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_4
  lw a0, -24(s0)
  sw a0, -32(s0)
  li a0, 0
  sw a0, -40(s0)
  # ArrayGet ArrayGet(_19, _20)
  lw t0, -32(s0)
  lw t1, -40(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw a0, 0(s1)
  # ArrayGet End ArrayGet(_19, _20)
  sw a0, -48(s0)
  # Ecall Label("minimbt_print_int") [_18]
  lw a0, -48(s0)
  call minimbt_print_int
  sw a0, -56(s0)
  mv a0, zero

