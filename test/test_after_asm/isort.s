.data
.text
random.1:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw a0, -8(s0)
  sw a0, -24(s0)
  li a0, 75
  sw a0, -32(s0)
  lw t0, -24(s0)
  lw t1, -32(s0)
  mul a0, t0, t1
  sw a0, -40(s0)
  li a0, 74
  sw a0, -48(s0)
  lw t0, -40(s0)
  lw t1, -48(s0)
  add a0, t0, t1
  lw ra, 0(s0)
  jr ra

modulo.7:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw a0, -8(s0)
  sw a0, -40(s0)
  lw a0, -16(s0)
  sw a0, -48(s0)
  lw t0, -40(s0)
  lw t1, -48(s0)
  div a0, t0, t1
  sw a0, -56(s0)
  lw a0, -8(s0)
  sw a0, -64(s0)
  lw a0, -56(s0)
  sw a0, -72(s0)
  lw a0, -16(s0)
  sw a0, -80(s0)
  lw t0, -72(s0)
  lw t1, -80(s0)
  mul a0, t0, t1
  sw a0, -88(s0)
  lw t0, -64(s0)
  lw t1, -88(s0)
  sub a0, t0, t1
  lw ra, 0(s0)
  jr ra

aux.20:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -48(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -56(s0)
  addi s1, s1, 8
  lw a0, -8(s0)
  sw a0, -64(s0)
  lw a0, -56(s0)
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  beq t0, t1, ifeq_then_1
  li a0, 0
  j ifeq_end_1
ifeq_then_1:
  li a0, 1
ifeq_end_1:
  sw a0, -80(s0)
  li a0, 1
  sw a0, -88(s0)
  lw t0, -80(s0)
  lw t1, -88(s0)
  beq t0, t1, ifeq_then_2
  lw a0, -16(s0)
  sw a0, -96(s0)
  # CallClosure random.1 [_26]
  lw t0, -96(s0)
  sw t0, -112(s0)
  lw t0, -40(s0)
  lw s1, 8(t0)
  sw t0, -120(s0)
  addi s0, s0, -104
  jalr ra, s1, 0
  addi s0, s0, 104
  # CallClosure End random.1 [_26]
  sw a0, -104(s0)
  li a0, 65537
  sw a0, -112(s0)
  lw a0, -104(s0)
  sw a0, -120(s0)
  # CallClosure modulo.7 [_28, _29]
  lw t0, -120(s0)
  sw t0, -136(s0)
  lw t0, -112(s0)
  sw t0, -144(s0)
  lw t0, -48(s0)
  lw s1, 8(t0)
  sw t0, -152(s0)
  addi s0, s0, -128
  jalr ra, s1, 0
  addi s0, s0, 128
  # CallClosure End modulo.7 [_28, _29]
  sw a0, -128(s0)
  lw a0, -32(s0)
  sw a0, -136(s0)
  lw a0, -8(s0)
  sw a0, -144(s0)
  lw a0, -128(s0)
  sw a0, -152(s0)
  # ArrayPut ArrayPut(_30, _31, _32, Let((_34, Int), Var(res.27), Let((_33, Int), Let((_35, Int), Var(i.21), Let((_36, Int), Int(1), Add(_35, _36))), CallClosure(aux.20, [_33, _34]))))
  lw t0, -136(s0)
  lw t1, -144(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw t0, -152(s0)
  sw t0, 0(s1)
  # ArrayPut end ArrayPut(_30, _31, _32, Let((_34, Int), Var(res.27), Let((_33, Int), Let((_35, Int), Var(i.21), Let((_36, Int), Int(1), Add(_35, _36))), CallClosure(aux.20, [_33, _34]))))
  lw a0, -128(s0)
  sw a0, -160(s0)
  lw a0, -8(s0)
  sw a0, -168(s0)
  li a0, 1
  sw a0, -176(s0)
  lw t0, -168(s0)
  lw t1, -176(s0)
  add a0, t0, t1
  sw a0, -184(s0)
  # CallClosure aux.20 [_33, _34]
  lw t0, -184(s0)
  sw t0, -200(s0)
  lw t0, -160(s0)
  sw t0, -208(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -216(s0)
  addi s0, s0, -192
  jalr ra, s1, 0
  addi s0, s0, 192
  # CallClosure End aux.20 [_33, _34]
  j ifeq_end_2
ifeq_then_2:
  mv a0, zero
ifeq_end_2:
  lw ra, 0(s0)
  jr ra

fill_buffer.17:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  # MakeClosure aux.20
  mv s1, s3
  addi s3, s3, 16
  la t0, aux.20
  sw t0, -8(s3)
  li s2, 16
  lw t0, -8(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -8(s0)
  lw t1, 0(t0)
data_copy_3:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_3
  lw t0, -32(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -32(s0)
  lw t1, 0(t0)
data_copy_4:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_4
  lw t0, -40(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -40(s0)
  lw t1, 0(t0)
data_copy_5:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_5
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  sw s2, 0(s1)
  sw s1, -48(s0)
  # MakeClosure End aux.20
  li a0, 12345
  sw a0, -56(s0)
  li a0, 0
  sw a0, -64(s0)
  # CallClosure aux.20 [_39, _40]
  lw t0, -64(s0)
  sw t0, -80(s0)
  lw t0, -56(s0)
  sw t0, -88(s0)
  lw t0, -48(s0)
  lw s1, 8(t0)
  sw t0, -96(s0)
  addi s0, s0, -72
  jalr ra, s1, 0
  addi s0, s0, 72
  # CallClosure End aux.20 [_39, _40]
  lw ra, 0(s0)
  jr ra

insert.44:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw a0, -16(s0)
  sw a0, -48(s0)
  li a0, 0
  sw a0, -56(s0)
  lw t0, -48(s0)
  lw t1, -56(s0)
  beq t0, t1, ifeq_then_6
  li a0, 0
  j ifeq_end_6
ifeq_then_6:
  li a0, 1
ifeq_end_6:
  sw a0, -64(s0)
  li a0, 1
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  beq t0, t1, ifeq_then_7
  lw a0, -8(s0)
  sw a0, -80(s0)
  lw a0, -16(s0)
  sw a0, -88(s0)
  li a0, 1
  sw a0, -96(s0)
  lw t0, -88(s0)
  lw t1, -96(s0)
  sub a0, t0, t1
  sw a0, -104(s0)
  # ArrayGet ArrayGet(_72, _73)
  lw t0, -80(s0)
  lw t1, -104(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw a0, 0(s1)
  # ArrayGet End ArrayGet(_72, _73)
  sw a0, -112(s0)
  lw a0, -8(s0)
  sw a0, -120(s0)
  lw a0, -16(s0)
  sw a0, -128(s0)
  # ArrayGet ArrayGet(_76, _77)
  lw t0, -120(s0)
  lw t1, -128(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw a0, 0(s1)
  # ArrayGet End ArrayGet(_76, _77)
  sw a0, -136(s0)
  lw t0, -112(s0)
  lw t1, -136(s0)
  ble t0, t1, ifle_then_8
  li a0, 0
  j ifle_end_8
ifle_then_8:
  li a0, 1
ifle_end_8:
  sw a0, -144(s0)
  li a0, 1
  sw a0, -152(s0)
  lw t0, -144(s0)
  lw t1, -152(s0)
  beq t0, t1, ifeq_then_9
  lw a0, -8(s0)
  sw a0, -160(s0)
  lw a0, -16(s0)
  sw a0, -168(s0)
  # ArrayGet ArrayGet(_52, _53)
  lw t0, -160(s0)
  lw t1, -168(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw a0, 0(s1)
  # ArrayGet End ArrayGet(_52, _53)
  sw a0, -176(s0)
  lw a0, -8(s0)
  sw a0, -184(s0)
  lw a0, -16(s0)
  sw a0, -192(s0)
  lw a0, -8(s0)
  sw a0, -200(s0)
  lw a0, -16(s0)
  sw a0, -208(s0)
  li a0, 1
  sw a0, -216(s0)
  lw t0, -208(s0)
  lw t1, -216(s0)
  sub a0, t0, t1
  sw a0, -224(s0)
  # ArrayGet ArrayGet(_57, _58)
  lw t0, -200(s0)
  lw t1, -224(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw a0, 0(s1)
  # ArrayGet End ArrayGet(_57, _58)
  sw a0, -232(s0)
  # ArrayPut ArrayPut(_54, _55, _56, Let((_61, Array(Int)), Var(arr.45), Let((_62, Int), Let((_68, Int), Var(i.46), Let((_69, Int), Int(1), Sub(_68, _69))), Let((_63, Int), Var(tmp.51), ArrayPut(_61, _62, _63, Let((_65, Int), Let((_66, Int), Var(i.46), Let((_67, Int), Int(1), Sub(_66, _67))), Let((_64, Array(Int)), Var(arr.45), CallClosure(insert.44, [_64, _65]))))))))
  lw t0, -184(s0)
  lw t1, -192(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw t0, -232(s0)
  sw t0, 0(s1)
  # ArrayPut end ArrayPut(_54, _55, _56, Let((_61, Array(Int)), Var(arr.45), Let((_62, Int), Let((_68, Int), Var(i.46), Let((_69, Int), Int(1), Sub(_68, _69))), Let((_63, Int), Var(tmp.51), ArrayPut(_61, _62, _63, Let((_65, Int), Let((_66, Int), Var(i.46), Let((_67, Int), Int(1), Sub(_66, _67))), Let((_64, Array(Int)), Var(arr.45), CallClosure(insert.44, [_64, _65]))))))))
  lw a0, -8(s0)
  sw a0, -240(s0)
  lw a0, -16(s0)
  sw a0, -248(s0)
  li a0, 1
  sw a0, -256(s0)
  lw t0, -248(s0)
  lw t1, -256(s0)
  sub a0, t0, t1
  sw a0, -264(s0)
  lw a0, -176(s0)
  sw a0, -272(s0)
  # ArrayPut ArrayPut(_61, _62, _63, Let((_65, Int), Let((_66, Int), Var(i.46), Let((_67, Int), Int(1), Sub(_66, _67))), Let((_64, Array(Int)), Var(arr.45), CallClosure(insert.44, [_64, _65]))))
  lw t0, -240(s0)
  lw t1, -264(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw t0, -272(s0)
  sw t0, 0(s1)
  # ArrayPut end ArrayPut(_61, _62, _63, Let((_65, Int), Let((_66, Int), Var(i.46), Let((_67, Int), Int(1), Sub(_66, _67))), Let((_64, Array(Int)), Var(arr.45), CallClosure(insert.44, [_64, _65]))))
  lw a0, -16(s0)
  sw a0, -280(s0)
  li a0, 1
  sw a0, -288(s0)
  lw t0, -280(s0)
  lw t1, -288(s0)
  sub a0, t0, t1
  sw a0, -296(s0)
  lw a0, -8(s0)
  sw a0, -304(s0)
  # CallClosure insert.44 [_64, _65]
  lw t0, -304(s0)
  sw t0, -320(s0)
  lw t0, -304(s0)
  lw t1, 0(t0)
data_copy_10:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_10
  lw t0, -296(s0)
  sw t0, -328(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -336(s0)
  addi s0, s0, -312
  jalr ra, s1, 0
  addi s0, s0, 312
  # CallClosure End insert.44 [_64, _65]
  j ifeq_end_9
ifeq_then_9:
  mv a0, zero
ifeq_end_9:
  j ifeq_end_7
ifeq_then_7:
  mv a0, zero
ifeq_end_7:
  lw ra, 0(s0)
  jr ra

aux.80:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -24(s0)
  addi s1, s1, 8
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw a0, -8(s0)
  sw a0, -48(s0)
  lw a0, -24(s0)
  sw a0, -56(s0)
  lw t0, -48(s0)
  lw t1, -56(s0)
  beq t0, t1, ifeq_then_11
  li a0, 0
  j ifeq_end_11
ifeq_then_11:
  li a0, 1
ifeq_end_11:
  sw a0, -64(s0)
  li a0, 1
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  beq t0, t1, ifeq_then_12
  lw a0, -8(s0)
  sw a0, -80(s0)
  lw a0, -40(s0)
  sw a0, -88(s0)
  # CallClosure insert.44 [_85, _86]
  lw t0, -88(s0)
  sw t0, -104(s0)
  lw t0, -88(s0)
  lw t1, 0(t0)
data_copy_13:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_13
  lw t0, -80(s0)
  sw t0, -112(s0)
  lw t0, -32(s0)
  lw s1, 8(t0)
  sw t0, -120(s0)
  addi s0, s0, -96
  jalr ra, s1, 0
  addi s0, s0, 96
  # CallClosure End insert.44 [_85, _86]
  sw a0, -96(s0)
  lw a0, -8(s0)
  sw a0, -104(s0)
  li a0, 1
  sw a0, -112(s0)
  lw t0, -104(s0)
  lw t1, -112(s0)
  add a0, t0, t1
  sw a0, -120(s0)
  # CallClosure aux.80 [_87]
  lw t0, -120(s0)
  sw t0, -136(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -144(s0)
  addi s0, s0, -128
  jalr ra, s1, 0
  addi s0, s0, 128
  # CallClosure End aux.80 [_87]
  j ifeq_end_12
ifeq_then_12:
  mv a0, zero
ifeq_end_12:
  lw ra, 0(s0)
  jr ra

isort.41:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  # MakeClosure insert.44
  mv s1, s3
  addi s3, s3, 16
  la t0, insert.44
  sw t0, -8(s3)
  li s2, 16
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -8(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -8(s0)
  lw t1, 0(t0)
data_copy_14:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_14
  sw s2, 0(s1)
  sw s1, -40(s0)
  # MakeClosure End insert.44
  # MakeClosure aux.80
  mv s1, s3
  addi s3, s3, 16
  la t0, aux.80
  sw t0, -8(s3)
  li s2, 16
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -40(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -40(s0)
  lw t1, 0(t0)
data_copy_15:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_15
  lw t0, -8(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -8(s0)
  lw t1, 0(t0)
data_copy_16:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_16
  sw s2, 0(s1)
  sw s1, -48(s0)
  # MakeClosure End aux.80
  li a0, 1
  sw a0, -56(s0)
  # CallClosure aux.80 [_92]
  lw t0, -56(s0)
  sw t0, -72(s0)
  lw t0, -48(s0)
  lw s1, 8(t0)
  sw t0, -80(s0)
  addi s0, s0, -64
  jalr ra, s1, 0
  addi s0, s0, 64
  # CallClosure End aux.80 [_92]
  lw ra, 0(s0)
  jr ra

aux.96:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  sw s1, -24(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  lw a0, -8(s0)
  sw a0, -40(s0)
  lw a0, -32(s0)
  sw a0, -48(s0)
  lw t0, -40(s0)
  lw t1, -48(s0)
  beq t0, t1, ifeq_then_17
  li a0, 0
  j ifeq_end_17
ifeq_then_17:
  li a0, 1
ifeq_end_17:
  sw a0, -56(s0)
  li a0, 1
  sw a0, -64(s0)
  lw t0, -56(s0)
  lw t1, -64(s0)
  beq t0, t1, ifeq_then_18
  lw a0, -24(s0)
  sw a0, -72(s0)
  lw a0, -8(s0)
  sw a0, -80(s0)
  # ArrayGet ArrayGet(_102, _103)
  lw t0, -72(s0)
  lw t1, -80(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw a0, 0(s1)
  # ArrayGet End ArrayGet(_102, _103)
  sw a0, -88(s0)
  # Ecall Label("minimbt_print_int") [_101]
  lw a0, -88(s0)
  call minimbt_print_int
  sw a0, -96(s0)
  li a0, 32
  sw a0, -104(s0)
  # Ecall Label("minimbt_print_char") [_105]
  lw a0, -104(s0)
  call minimbt_print_char
  sw a0, -112(s0)
  lw a0, -8(s0)
  sw a0, -120(s0)
  li a0, 1
  sw a0, -128(s0)
  lw t0, -120(s0)
  lw t1, -128(s0)
  add a0, t0, t1
  sw a0, -136(s0)
  # CallClosure aux.96 [_106]
  lw t0, -136(s0)
  sw t0, -152(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -160(s0)
  addi s0, s0, -144
  jalr ra, s1, 0
  addi s0, s0, 144
  # CallClosure End aux.96 [_106]
  j ifeq_end_18
ifeq_then_18:
  mv a0, zero
ifeq_end_18:
  lw ra, 0(s0)
  jr ra

print_array.93:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  # MakeClosure aux.96
  mv s1, s3
  addi s3, s3, 16
  la t0, aux.96
  sw t0, -8(s3)
  li s2, 16
  lw t0, -8(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -8(s0)
  lw t1, 0(t0)
data_copy_19:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_19
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  sw s2, 0(s1)
  sw s1, -48(s0)
  # MakeClosure End aux.96
  li a0, 0
  sw a0, -56(s0)
  # CallClosure aux.96 [_111]
  lw t0, -56(s0)
  sw t0, -72(s0)
  lw t0, -48(s0)
  lw s1, 8(t0)
  sw t0, -80(s0)
  addi s0, s0, -64
  jalr ra, s1, 0
  addi s0, s0, 64
  # CallClosure End aux.96 [_111]
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x1000
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s0, s3, -8
  # MakeClosure random.1
  mv s1, s3
  addi s3, s3, 16
  la t0, random.1
  sw t0, -8(s3)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End random.1
  # MakeClosure modulo.7
  mv s1, s3
  addi s3, s3, 16
  la t0, modulo.7
  sw t0, -8(s3)
  li s2, 16
  lw t0, 0(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, 0(s0)
  lw t1, 0(t0)
data_copy_20:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_20
  sw s2, 0(s1)
  sw s1, -8(s0)
  # MakeClosure End modulo.7
  # MakeClosure fill_buffer.17
  mv s1, s3
  addi s3, s3, 16
  la t0, fill_buffer.17
  sw t0, -8(s3)
  li s2, 16
  lw t0, 0(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, 0(s0)
  lw t1, 0(t0)
data_copy_21:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_21
  lw t0, -8(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -8(s0)
  lw t1, 0(t0)
data_copy_22:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_22
  sw s2, 0(s1)
  sw s1, -16(s0)
  # MakeClosure End fill_buffer.17
  # MakeClosure isort.41
  mv s1, s3
  addi s3, s3, 16
  la t0, isort.41
  sw t0, -8(s3)
  li s2, 16
  lw t0, -16(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -16(s0)
  lw t1, 0(t0)
data_copy_23:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_23
  sw s2, 0(s1)
  sw s1, -24(s0)
  # MakeClosure End isort.41
  # MakeClosure print_array.93
  mv s1, s3
  addi s3, s3, 16
  la t0, print_array.93
  sw t0, -8(s3)
  li s2, 16
  lw t0, -24(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -24(s0)
  lw t1, 0(t0)
data_copy_24:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_24
  lw t0, -16(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -16(s0)
  lw t1, 0(t0)
data_copy_25:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_25
  sw s2, 0(s1)
  sw s1, -32(s0)
  # MakeClosure End print_array.93
  li a0, 100
  sw a0, -40(s0)
  lw a0, -40(s0)
  sw a0, -48(s0)
  li a0, 0
  sw a0, -56(s0)
  # MakeArray MakeArray(_114, _115)
  mv s1, s3
  addi s3, s3, 8
  li t1, 8
  lw s2, -48(s0)
  mul t1, t1, s2
  addi t1, t1, 8
  sw t1, 0(s1)
make_array_loop_26:
  lw t0, -56(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, -1
  beq s2, zero, make_array_end_26
  j make_array_loop_26
make_array_end_26:
  mv a0, s1
  # MakeArray End MakeArray(_114, _115)
  sw s3, -64(s0)
  lw t1, 0(a0)
data_copy_reg_loop_27:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_27
  lw a0, -40(s0)
  sw a0, -72(s0)
  lw a0, -64(s0)
  sw a0, -80(s0)
  # CallClosure fill_buffer.17 [_117, _118]
  lw t0, -80(s0)
  sw t0, -96(s0)
  lw t0, -80(s0)
  lw t1, 0(t0)
data_copy_28:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_28
  lw t0, -72(s0)
  sw t0, -104(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -112(s0)
  addi s0, s0, -88
  jalr ra, s1, 0
  addi s0, s0, 88
  # CallClosure End fill_buffer.17 [_117, _118]
  sw a0, -88(s0)
  lw a0, -40(s0)
  sw a0, -96(s0)
  lw a0, -64(s0)
  sw a0, -104(s0)
  # CallClosure isort.41 [_120, _121]
  lw t0, -104(s0)
  sw t0, -120(s0)
  lw t0, -104(s0)
  lw t1, 0(t0)
data_copy_29:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_29
  lw t0, -96(s0)
  sw t0, -128(s0)
  lw t0, -24(s0)
  lw s1, 8(t0)
  sw t0, -136(s0)
  addi s0, s0, -112
  jalr ra, s1, 0
  addi s0, s0, 112
  # CallClosure End isort.41 [_120, _121]
  sw a0, -112(s0)
  lw a0, -40(s0)
  sw a0, -120(s0)
  lw a0, -64(s0)
  sw a0, -128(s0)
  # CallClosure print_array.93 [_122, _123]
  lw t0, -128(s0)
  sw t0, -144(s0)
  lw t0, -128(s0)
  lw t1, 0(t0)
data_copy_30:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_30
  lw t0, -120(s0)
  sw t0, -152(s0)
  lw t0, -32(s0)
  lw s1, 8(t0)
  sw t0, -160(s0)
  addi s0, s0, -136
  jalr ra, s1, 0
  addi s0, s0, 136
  # CallClosure End print_array.93 [_122, _123]

