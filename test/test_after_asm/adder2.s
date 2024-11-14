.data
.text
adder.3:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -24(s0)
  addi s1, s1, 8
  lw a0, -24(s0)
  sw a0, -32(s0)
  lw a0, -8(s0)
  sw a0, -40(s0)
  lw t0, -32(s0)
  lw t1, -40(s0)
  add a0, t0, t1
  lw ra, 0(s0)
  jr ra

make_adder.1:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  # MakeClosure adder.3
  mv s1, s3
  addi s3, s3, 16
  la t0, adder.3
  sw t0, -8(s3)
  li s2, 16
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  sw s2, 0(s1)
  sw s1, -24(s0)
  # MakeClosure End adder.3
  lw a0, -24(s0)
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x100000
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s0, s3, -8
  # MakeClosure make_adder.1
  mv s1, s3
  addi s3, s3, 16
  la t0, make_adder.1
  sw t0, -8(s3)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End make_adder.1
  li a0, 2
  sw a0, -8(s0)
  # CallClosure make_adder.1 [_8]
  lw t0, -8(s0)
  sw t0, -24(s0)
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -32(s0)
  addi s0, s0, -16
  jalr ra, s1, 0
  addi s0, s0, 16
  # CallClosure End make_adder.1 [_8]
  sw s3, -16(s0)
  lw t1, 0(a0)
data_copy_reg_loop_1:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_1
  li a0, 3
  sw a0, -24(s0)
  # CallClosure make_adder.1 [_10]
  lw t0, -24(s0)
  sw t0, -40(s0)
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -48(s0)
  addi s0, s0, -32
  jalr ra, s1, 0
  addi s0, s0, 32
  # CallClosure End make_adder.1 [_10]
  sw s3, -32(s0)
  lw t1, 0(a0)
data_copy_reg_loop_2:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_2
  li a0, 10
  sw a0, -40(s0)
  # CallClosure add2.7 [_14]
  lw t0, -40(s0)
  sw t0, -56(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -64(s0)
  addi s0, s0, -48
  jalr ra, s1, 0
  addi s0, s0, 48
  # CallClosure End add2.7 [_14]
  sw a0, -48(s0)
  li a0, 20
  sw a0, -56(s0)
  # CallClosure add3.9 [_15]
  lw t0, -56(s0)
  sw t0, -72(s0)
  lw t0, -32(s0)
  lw s1, 8(t0)
  sw t0, -80(s0)
  addi s0, s0, -64
  jalr ra, s1, 0
  addi s0, s0, 64
  # CallClosure End add3.9 [_15]
  sw a0, -64(s0)
  lw t0, -48(s0)
  lw t1, -64(s0)
  add a0, t0, t1
  sw a0, -72(s0)
  # Ecall Label("minimbt_print_int") [_11]
  lw a0, -72(s0)
  call minimbt_print_int

