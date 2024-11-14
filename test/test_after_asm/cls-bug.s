.data
.text
f.1:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw a0, -8(s0)
  sw a0, -24(s0)
  li a0, 123
  sw a0, -32(s0)
  lw t0, -24(s0)
  lw t1, -32(s0)
  add a0, t0, t1
  lw ra, 0(s0)
  jr ra

g.5:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  sw s1, -24(s0)
  lw t0, 0(s1)
  add s1, s1, t0
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
  li a0, 789
  sw a0, -16(s0)
  li a0, 456
  sw a0, -24(s0)
  # CallClosure g.5 [_10]
  lw t0, -24(s0)
  sw t0, -40(s0)
  lw t0, -8(s0)
  lw s1, 8(t0)
  sw t0, -48(s0)
  addi s0, s0, -32
  jalr ra, s1, 0
  addi s0, s0, 32
  # CallClosure End g.5 [_10]
  sw a0, -32(s0)
  # CallClosure _9 [_8]
  lw t0, -16(s0)
  sw t0, -48(s0)
  lw t0, -32(s0)
  lw s1, 8(t0)
  sw t0, -56(s0)
  addi s0, s0, -40
  jalr ra, s1, 0
  addi s0, s0, 40
  # CallClosure End _9 [_8]
  sw a0, -40(s0)
  # Ecall Label("minimbt_print_int") [_7]
  lw a0, -40(s0)
  call minimbt_print_int

