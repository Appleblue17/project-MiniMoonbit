ack.1:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  lw a0, -8(s0)
  sw a0, -32(s0)
  li a0, 0
  sw a0, -40(s0)
  lw t0, -32(s0)
  lw t1, -40(s0)
  ble t0, t1, 8
  j ifle_else_0
  li a0, 1
  j ifle_end_0
ifle_else_0:
  li a0, 0
ifle_end_0:
  sw a0, -48(s0)
  li a0, 1
  sw a0, -56(s0)
  lw t0, -48(s0)
  lw t1, -56(s0)
  beq t0, t1, 8
  j ifeq_else_1
  lw a0, -16(s0)
  sw a0, -64(s0)
  li a0, 1
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  add a0, t0, t1
  j ifeq_end_1
ifeq_else_1:
  lw a0, -16(s0)
  sw a0, -64(s0)
  li a0, 0
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  ble t0, t1, 8
  j ifle_else_2
  li a0, 1
  j ifle_end_2
ifle_else_2:
  li a0, 0
ifle_end_2:
  sw a0, -80(s0)
  li a0, 1
  sw a0, -88(s0)
  lw t0, -80(s0)
  lw t1, -88(s0)
  beq t0, t1, 8
  j ifeq_else_3
  li a0, 1
  sw a0, -96(s0)
  lw a0, -8(s0)
  sw a0, -104(s0)
  li a0, 1
  sw a0, -112(s0)
  lw t0, -104(s0)
  lw t1, -112(s0)
  sub a0, t0, t1
  sw a0, -120(s0)
  # CallClosure ack.1 [_10, _11]
  lw t0, -120(s0)
  sw t0, -136(s0)
  lw t0, -96(s0)
  sw t0, -144(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -152(s0)
  addi s0, s0, -128
  jalr ra, s1, 0
  addi s0, s0, 128
  # CallClosure End ack.1 [_10, _11]
  j ifeq_end_3
ifeq_else_3:
  lw a0, -16(s0)
  sw a0, -96(s0)
  li a0, 1
  sw a0, -104(s0)
  lw t0, -96(s0)
  lw t1, -104(s0)
  sub a0, t0, t1
  sw a0, -112(s0)
  lw a0, -8(s0)
  sw a0, -120(s0)
  # CallClosure ack.1 [_18, _19]
  lw t0, -120(s0)
  sw t0, -136(s0)
  lw t0, -112(s0)
  sw t0, -144(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -152(s0)
  addi s0, s0, -128
  jalr ra, s1, 0
  addi s0, s0, 128
  # CallClosure End ack.1 [_18, _19]
  sw a0, -128(s0)
  lw a0, -8(s0)
  sw a0, -136(s0)
  li a0, 1
  sw a0, -144(s0)
  lw t0, -136(s0)
  lw t1, -144(s0)
  sub a0, t0, t1
  sw a0, -152(s0)
  # CallClosure ack.1 [_14, _15]
  lw t0, -152(s0)
  sw t0, -168(s0)
  lw t0, -128(s0)
  sw t0, -176(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -184(s0)
  addi s0, s0, -160
  jalr ra, s1, 0
  addi s0, s0, 160
  # CallClosure End ack.1 [_14, _15]
ifeq_end_3:
ifeq_end_1:
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li s0, 0x0ffffff8
  li sp, 0x10000000
  # MakeClosure ack.1
  mv s1, sp
  addi sp, sp, 16
  la t0, ack.1
  sw t0, -8(sp)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End ack.1
  li a0, 8
  sw a0, -8(s0)
  li a0, 3
  sw a0, -16(s0)
  # CallClosure ack.1 [_27, _28]
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
  # CallClosure End ack.1 [_27, _28]
  sw a0, -24(s0)
  # Ecall Label("minimbt_print_int") [_26]
  lw a0, -24(s0)
  call minimbt_print_int

