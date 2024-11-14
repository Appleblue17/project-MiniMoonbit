.data
.text
f.1:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  li a0, 0
  sw a0, -24(s0)
  lw a0, -8(s0)
  sw a0, -32(s0)
  lw t0, -24(s0)
  lw t1, -32(s0)
  ble t0, t1, ifle_then_1
  li a0, 0
  j ifle_end_1
ifle_then_1:
  li a0, 1
ifle_end_1:
  sw a0, -40(s0)
  lw a0, -40(s0)
  xori a0, a0, 1
  sw a0, -48(s0)
  li a0, 1
  sw a0, -56(s0)
  lw t0, -48(s0)
  lw t1, -56(s0)
  beq t0, t1, ifeq_then_2
  lw a0, -8(s0)
  sw a0, -64(s0)
  # Ecall Label("minimbt_print_int") [_6]
  lw a0, -64(s0)
  call minimbt_print_int
  sw a0, -72(s0)
  li a0, 1
  sw a0, -80(s0)
  lw a0, -16(s0)
  sw a0, -88(s0)
  # MakeArray MakeArray(_8, _9)
  mv s1, s3
  addi s3, s3, 8
  lw t0, -88(s0)
  lw t1, 0(t0)
  lw s2, -80(s0)
  mul t1, t1, s2
  addi t1, t1, 8
  sw t1, 0(s1)
make_array_loop_3:
  lw t0, -88(s0)
  lw t1, 0(t0)
data_copy_4:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_4
  addi s2, s2, -1
  beq s2, zero, make_array_end_3
  j make_array_loop_3
make_array_end_3:
  mv a0, s1
  # MakeArray End MakeArray(_8, _9)
  sw s3, -96(s0)
  lw t1, 0(a0)
data_copy_reg_loop_5:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_5
  lw a0, -96(s0)
  sw a0, -104(s0)
  li a0, 0
  sw a0, -112(s0)
  # ArrayGet ArrayGet(_11, _12)
  lw t0, -104(s0)
  lw t1, -112(s0)
  lw t3, -104(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_11, _12)
  sw s3, -120(s0)
  lw t1, 0(a0)
data_copy_reg_loop_6:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_6
  lw a0, -8(s0)
  sw a0, -128(s0)
  li a0, 1
  sw a0, -136(s0)
  lw t0, -128(s0)
  lw t1, -136(s0)
  sub a0, t0, t1
  sw a0, -144(s0)
  # CallClosure a0.10 [_13]
  lw t0, -144(s0)
  sw t0, -160(s0)
  lw t0, -120(s0)
  lw s1, 8(t0)
  sw t0, -168(s0)
  addi s0, s0, -152
  jalr ra, s1, 0
  addi s0, s0, 152
  # CallClosure End a0.10 [_13]
  j ifeq_end_2
ifeq_then_2:
  mv a0, zero
ifeq_end_2:
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x1
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
  li a0, 9
  sw a0, -8(s0)
  # CallClosure f.1 [_19]
  lw t0, -8(s0)
  sw t0, -24(s0)
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -32(s0)
  addi s0, s0, -16
  jalr ra, s1, 0
  addi s0, s0, 16
  # CallClosure End f.1 [_19]

