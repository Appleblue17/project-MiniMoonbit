.data
.text
adder.3:
  sw ra, 0(s4)
  lw s1, -16(s4)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -24(s4)
  addi s1, s1, 8
  lw a0, -24(s4)
  sw a0, -32(s4)
  lw a0, -8(s4)
  sw a0, -40(s4)
  lw t0, -32(s4)
  lw t1, -40(s4)
  add a0, t0, t1
  lw ra, 0(s4)
  jr ra

make_adder.1:
  sw ra, 0(s4)
  lw s1, -16(s4)
  addi s1, s1, 16
  # MakeClosure adder.3
  mv s1, s3
  addi s3, s3, 16
  la t0, adder.3
  sw t0, -8(s3)
  li s2, 16
  addi s2, s2, 8
  lw t0, -8(s4)
  sw t0, 0(s3)
  addi s3, s3, 8
  sw s2, 0(s1)
  sw s1, -24(s4)
  # MakeClosure End adder.3
  lw a0, -24(s4)
  lw ra, 0(s4)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x1000
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s4, s3, -8
  # MakeClosure make_adder.1
  mv s1, s3
  addi s3, s3, 16
  la t0, make_adder.1
  sw t0, -8(s3)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s4)
  # MakeClosure End make_adder.1
  li a0, 7
  sw a0, -8(s4)
  li a0, 3
  sw a0, -16(s4)
  # CallClosure make_adder.1 [_10]
  lw t0, -16(s4)
  sw t0, -32(s4)
  lw t0, 0(s4)
  lw s1, 8(t0)
  sw t0, -40(s4)
  addi s4, s4, -24
  jalr ra, s1, 0
  addi s4, s4, 24
  # CallClosure End make_adder.1 [_10]
  sw a0, -24(s4)
  # CallClosure _9 [_8]
  lw t0, -8(s4)
  sw t0, -40(s4)
  lw t0, -24(s4)
  lw s1, 8(t0)
  sw t0, -48(s4)
  addi s4, s4, -32
  jalr ra, s1, 0
  addi s4, s4, 32
  # CallClosure End _9 [_8]
  sw a0, -32(s4)
  # Ecall Label("minimbt_print_int") [_7]
  lw a0, -32(s4)
  call minimbt_print_int

