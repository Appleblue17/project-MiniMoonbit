.data
.text
fib.1:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw a0, -8(s0)
  sw a0, -24(s0)
  li a0, 1
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
  li a0, 1
  sw a0, -48(s0)
  lw t0, -40(s0)
  lw t1, -48(s0)
  beq t0, t1, ifeq_then_2
  lw a0, -8(s0)
  sw a0, -56(s0)
  li a0, 1
  sw a0, -64(s0)
  lw t0, -56(s0)
  lw t1, -64(s0)
  sub a0, t0, t1
  sw a0, -72(s0)
  # CallClosure fib.1 [_7]
  lw t0, -72(s0)
  sw t0, -88(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -96(s0)
  addi s0, s0, -80
  jalr ra, s1, 0
  addi s0, s0, 80
  # CallClosure End fib.1 [_7]
  sw a0, -80(s0)
  lw a0, -8(s0)
  sw a0, -88(s0)
  li a0, 2
  sw a0, -96(s0)
  lw t0, -88(s0)
  lw t1, -96(s0)
  sub a0, t0, t1
  sw a0, -104(s0)
  # CallClosure fib.1 [_10]
  lw t0, -104(s0)
  sw t0, -120(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -128(s0)
  addi s0, s0, -112
  jalr ra, s1, 0
  addi s0, s0, 112
  # CallClosure End fib.1 [_10]
  sw a0, -112(s0)
  lw t0, -80(s0)
  lw t1, -112(s0)
  add a0, t0, t1
  j ifeq_end_2
ifeq_then_2:
  lw a0, -8(s0)
ifeq_end_2:
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x1000
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s0, s3, -8
  # MakeClosure fib.1
  mv s1, s3
  addi s3, s3, 16
  la t0, fib.1
  sw t0, -8(s3)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End fib.1
  li a0, 30
  sw a0, -8(s0)
  # CallClosure fib.1 [_16]
  lw t0, -8(s0)
  sw t0, -24(s0)
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -32(s0)
  addi s0, s0, -16
  jalr ra, s1, 0
  addi s0, s0, 16
  # CallClosure End fib.1 [_16]
  sw a0, -16(s0)
  # Ecall Label("minimbt_print_int") [_15]
  lw a0, -16(s0)
  call minimbt_print_int

