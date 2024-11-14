odd.5:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  sw s1, -24(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -40(s0)
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -48(s0)
  addi s1, s1, 8
  li a0, 0
  sw a0, -56(s0)
  lw a0, -8(s0)
  sw a0, -64(s0)
  lw t0, -56(s0)
  lw t1, -64(s0)
  ble t0, t1, 8
  j ifle_else_0
  li a0, 1
  j ifle_end_0
ifle_else_0:
  li a0, 0
ifle_end_0:
  sw a0, -72(s0)
  li a0, 1
  sw a0, -80(s0)
  lw t0, -72(s0)
  lw t1, -80(s0)
  beq t0, t1, 8
  j ifeq_else_1
  lw a0, -8(s0)
  sw a0, -88(s0)
  li a0, 0
  sw a0, -96(s0)
  lw t0, -88(s0)
  lw t1, -96(s0)
  beq t0, t1, 8
  j ifeq_else_2
  li a0, 1
  j ifeq_end_2
ifeq_else_2:
  li a0, 0
ifeq_end_2:
  sw a0, -104(s0)
  li a0, 1
  sw a0, -112(s0)
  lw t0, -104(s0)
  lw t1, -112(s0)
  beq t0, t1, 8
  j ifeq_else_3
  lw a0, -48(s0)
  j ifeq_end_3
ifeq_else_3:
  lw a0, -8(s0)
  sw a0, -120(s0)
  li a0, 1
  sw a0, -128(s0)
  lw t0, -120(s0)
  lw t1, -128(s0)
  sub a0, t0, t1
  sw a0, -136(s0)
  # CallClosure even.3 [_11]
  lw t0, -136(s0)
  sw t0, -152(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -160(s0)
  addi s0, s0, -144
  jalr ra, s1, 0
  addi s0, s0, 144
  # CallClosure End even.3 [_11]
ifeq_end_3:
  j ifeq_end_1
ifeq_else_1:
  lw a0, -8(s0)
  sw a0, -88(s0)
  li a0, 1
  sw a0, -96(s0)
  lw t0, -88(s0)
  lw t1, -96(s0)
  add a0, t0, t1
  sw a0, -104(s0)
  # CallClosure even.3 [_16]
  lw t0, -104(s0)
  sw t0, -120(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -128(s0)
  addi s0, s0, -112
  jalr ra, s1, 0
  addi s0, s0, 112
  # CallClosure End even.3 [_16]
ifeq_end_1:
  lw ra, 0(s0)
  jr ra

even.3:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -24(s0)
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  # MakeClosure odd.5
  mv s1, sp
  addi sp, sp, 16
  la t0, odd.5
  sw t0, -8(sp)
  li s2, 16
  lw t0, -16(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -16(s0)
  lw t1, 0(t0)
  lw t2, 0(t0)
  sw t2, 0(sp)
  addi t0, t0, 8
  addi sp, sp, 8
  addi t1, t1, -8
  bne t1, zero, -20
  addi s2, s2, 8
  lw t0, -24(s0)
  sw t0, 0(sp)
  addi sp, sp, 8
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(sp)
  addi sp, sp, 8
  addi s2, s2, 8
  lw t0, -32(s0)
  sw t0, 0(sp)
  addi sp, sp, 8
  sw s2, 0(s1)
  sw s1, -40(s0)
  # MakeClosure End odd.5
  li a0, 0
  sw a0, -48(s0)
  lw a0, -8(s0)
  sw a0, -56(s0)
  lw t0, -48(s0)
  lw t1, -56(s0)
  ble t0, t1, 8
  j ifle_else_4
  li a0, 1
  j ifle_end_4
ifle_else_4:
  li a0, 0
ifle_end_4:
  sw a0, -64(s0)
  li a0, 1
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  beq t0, t1, 8
  j ifeq_else_5
  lw a0, -8(s0)
  sw a0, -80(s0)
  li a0, 0
  sw a0, -88(s0)
  lw t0, -80(s0)
  lw t1, -88(s0)
  beq t0, t1, 8
  j ifeq_else_6
  li a0, 1
  j ifeq_end_6
ifeq_else_6:
  li a0, 0
ifeq_end_6:
  sw a0, -96(s0)
  li a0, 1
  sw a0, -104(s0)
  lw t0, -96(s0)
  lw t1, -104(s0)
  beq t0, t1, 8
  j ifeq_else_7
  lw a0, -24(s0)
  j ifeq_end_7
ifeq_else_7:
  lw a0, -8(s0)
  sw a0, -112(s0)
  li a0, 1
  sw a0, -120(s0)
  lw t0, -112(s0)
  lw t1, -120(s0)
  sub a0, t0, t1
  sw a0, -128(s0)
  # CallClosure odd.5 [_25]
  lw t0, -128(s0)
  sw t0, -144(s0)
  lw t0, -40(s0)
  lw s1, 8(t0)
  sw t0, -152(s0)
  addi s0, s0, -136
  jalr ra, s1, 0
  addi s0, s0, 136
  # CallClosure End odd.5 [_25]
ifeq_end_7:
  j ifeq_end_5
ifeq_else_5:
  lw a0, -8(s0)
  sw a0, -80(s0)
  li a0, 1
  sw a0, -88(s0)
  lw t0, -80(s0)
  lw t1, -88(s0)
  add a0, t0, t1
  sw a0, -96(s0)
  # CallClosure odd.5 [_30]
  lw t0, -96(s0)
  sw t0, -112(s0)
  lw t0, -40(s0)
  lw s1, 8(t0)
  sw t0, -120(s0)
  addi s0, s0, -104
  jalr ra, s1, 0
  addi s0, s0, 104
  # CallClosure End odd.5 [_30]
ifeq_end_5:
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li s0, 0x0ffffff8
  li sp, 0x10000000
  li a0, 123
  sw a0, 0(s0)
  li a0, 456
  sw a0, -8(s0)
  # MakeClosure even.3
  mv s1, sp
  addi sp, sp, 16
  la t0, even.3
  sw t0, -8(sp)
  li s2, 16
  addi s2, s2, 8
  lw t0, 0(s0)
  sw t0, 0(sp)
  addi sp, sp, 8
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(sp)
  addi sp, sp, 8
  sw s2, 0(s1)
  sw s1, -16(s0)
  # MakeClosure End even.3
  li a0, 789
  sw a0, -24(s0)
  # CallClosure even.3 [_36]
  lw t0, -24(s0)
  sw t0, -40(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -48(s0)
  addi s0, s0, -32
  jalr ra, s1, 0
  addi s0, s0, 32
  # CallClosure End even.3 [_36]
  sw a0, -32(s0)
  # Ecall Label("minimbt_print_int") [_35]
  lw a0, -32(s0)
  call minimbt_print_int

