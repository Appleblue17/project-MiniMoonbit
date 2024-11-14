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
  mv s1, sp
  addi sp, sp, 16
  la t0, adder.3
  sw t0, -8(sp)
  li s2, 16
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(sp)
  addi sp, sp, 8
  sw s2, 0(s1)
  sw s1, -24(s0)
  # MakeClosure End adder.3
  lw a0, -24(s0)
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li s0, 0x0ffffff8
  li sp, 0x10000000
  # MakeClosure make_adder.1
  mv s1, sp
  addi sp, sp, 16
  la t0, make_adder.1
  sw t0, -8(sp)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End make_adder.1
  li a0, 7
  sw a0, -8(s0)
  li a0, 3
  sw a0, -16(s0)
  # CallClosure make_adder.1 [_10]
  lw t0, -16(s0)
  sw t0, -32(s0)
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -40(s0)
  addi s0, s0, -24
  jalr ra, s1, 0
  addi s0, s0, 24
  # CallClosure End make_adder.1 [_10]
  sw a0, -24(s0)
  # CallClosure _9 [_8]
  lw t0, -8(s0)
  sw t0, -40(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -48(s0)
  addi s0, s0, -32
  jalr ra, s1, 0
  addi s0, s0, 32
  # CallClosure End _9 [_8]
  sw a0, -32(s0)
  # Ecall Label("minimbt_print_int") [_7]
  lw a0, -32(s0)
  call minimbt_print_int

