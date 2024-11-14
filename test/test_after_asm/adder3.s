pow.3:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -24(s0)
  addi s1, s1, 8
  lw a0, -8(s0)
  sw a0, -32(s0)
  li a0, 0
  sw a0, -40(s0)
  lw t0, -32(s0)
  lw t1, -40(s0)
  beq t0, t1, 8
  j ifeq_else_0
  li a0, 1
  j ifeq_end_0
ifeq_else_0:
  li a0, 0
ifeq_end_0:
  sw a0, -48(s0)
  li a0, 1
  sw a0, -56(s0)
  lw t0, -48(s0)
  lw t1, -56(s0)
  beq t0, t1, 8
  j ifeq_else_1
  li a0, 1
  j ifeq_end_1
ifeq_else_1:
  lw a0, -8(s0)
  sw a0, -64(s0)
  li a0, 1
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  sub a0, t0, t1
  sw a0, -80(s0)
  # CallClosure pow.3 [_9]
  lw t0, -80(s0)
  sw t0, -96(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -104(s0)
  addi s0, s0, -88
  jalr ra, s1, 0
  addi s0, s0, 88
  # CallClosure End pow.3 [_9]
  sw a0, -88(s0)
  lw a0, -24(s0)
  sw a0, -96(s0)
  lw t0, -88(s0)
  lw t1, -96(s0)
  mul a0, t0, t1
ifeq_end_1:
  lw ra, 0(s0)
  jr ra

make_pow.1:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  # MakeClosure pow.3
  mv s1, sp
  addi sp, sp, 16
  la t0, pow.3
  sw t0, -8(sp)
  li s2, 16
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(sp)
  addi sp, sp, 8
  sw s2, 0(s1)
  sw s1, -24(s0)
  # MakeClosure End pow.3
  lw a0, -24(s0)
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li s0, 0x0ffffff8
  li sp, 0x10000000
  # MakeClosure make_pow.1
  mv s1, sp
  addi sp, sp, 16
  la t0, make_pow.1
  sw t0, -8(sp)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End make_pow.1
  li a0, 4
  sw a0, -8(s0)
  li a0, 3
  sw a0, -16(s0)
  # CallClosure make_pow.1 [_17]
  lw t0, -16(s0)
  sw t0, -32(s0)
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -40(s0)
  addi s0, s0, -24
  jalr ra, s1, 0
  addi s0, s0, 24
  # CallClosure End make_pow.1 [_17]
  sw a0, -24(s0)
  # CallClosure _16 [_15]
  lw t0, -8(s0)
  sw t0, -40(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -48(s0)
  addi s0, s0, -32
  jalr ra, s1, 0
  addi s0, s0, 32
  # CallClosure End _16 [_15]
  sw a0, -32(s0)
  # Ecall Label("minimbt_print_int") [_14]
  lw a0, -32(s0)
  call minimbt_print_int

