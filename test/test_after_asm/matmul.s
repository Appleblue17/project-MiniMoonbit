.data
const_double_0:
  .double 0

const_double_1:
  .double 0

const_double_2:
  .double 1

const_double_3:
  .double 2

const_double_4:
  .double 3

const_double_5:
  .double 4

const_double_6:
  .double 5

const_double_7:
  .double 6

const_double_8:
  .double 7

const_double_9:
  .double 8

const_double_10:
  .double 9

const_double_11:
  .double 10

const_double_12:
  .double 11

const_double_13:
  .double 12

.text
loop3.16:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  sw s1, -24(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -48(s0)
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -56(s0)
  addi s1, s1, 8
  sw s1, -64(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -72(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  li a0, 0
  sw a0, -80(s0)
  lw a0, -8(s0)
  sw a0, -88(s0)
  lw t0, -80(s0)
  lw t1, -88(s0)
  ble t0, t1, ifle_then_1
  li a0, 0
  j ifle_end_1
ifle_then_1:
  li a0, 1
ifle_end_1:
  sw a0, -96(s0)
  li a0, 1
  sw a0, -104(s0)
  lw t0, -96(s0)
  lw t1, -104(s0)
  beq t0, t1, ifeq_then_2
  mv a0, zero
  j ifeq_end_2
ifeq_then_2:
  lw a0, -24(s0)
  sw a0, -112(s0)
  lw a0, -56(s0)
  sw a0, -120(s0)
  # ArrayGet ArrayGet(_23, _24)
  lw t0, -112(s0)
  lw t1, -120(s0)
  lw t3, -112(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_23, _24)
  sw a0, -128(s0)
  lw a0, -32(s0)
  sw a0, -136(s0)
  lw a0, -24(s0)
  sw a0, -144(s0)
  lw a0, -56(s0)
  sw a0, -152(s0)
  # ArrayGet ArrayGet(_29, _30)
  lw t0, -144(s0)
  lw t1, -152(s0)
  lw t3, -144(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_29, _30)
  sw a0, -160(s0)
  lw a0, -32(s0)
  sw a0, -168(s0)
  # ArrayGet ArrayGet(_27, _28)
  lw t0, -160(s0)
  lw t1, -168(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld fa0, 0(s1)
  # ArrayGet End ArrayGet(_27, _28)
  fsd fa0, -176(s0)
  lw a0, -72(s0)
  sw a0, -184(s0)
  lw a0, -56(s0)
  sw a0, -192(s0)
  # ArrayGet ArrayGet(_35, _36)
  lw t0, -184(s0)
  lw t1, -192(s0)
  lw t3, -184(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_35, _36)
  sw a0, -200(s0)
  lw a0, -8(s0)
  sw a0, -208(s0)
  # ArrayGet ArrayGet(_33, _34)
  lw t0, -200(s0)
  lw t1, -208(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld fa0, 0(s1)
  # ArrayGet End ArrayGet(_33, _34)
  fsd fa0, -216(s0)
  lw a0, -40(s0)
  sw a0, -224(s0)
  lw a0, -8(s0)
  sw a0, -232(s0)
  # ArrayGet ArrayGet(_39, _40)
  lw t0, -224(s0)
  lw t1, -232(s0)
  lw t3, -224(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_39, _40)
  sw a0, -240(s0)
  lw a0, -32(s0)
  sw a0, -248(s0)
  # ArrayGet ArrayGet(_37, _38)
  lw t0, -240(s0)
  lw t1, -248(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld fa0, 0(s1)
  # ArrayGet End ArrayGet(_37, _38)
  fsd fa0, -256(s0)
  fld ft0, -216(s0)
  fld ft1, -256(s0)
  fmul.d fa0, ft0, ft1
  fsd fa0, -264(s0)
  fld ft0, -176(s0)
  fld ft1, -264(s0)
  fadd.d fa0, ft0, ft1
  fsd fa0, -272(s0)
  # ArrayPut ArrayPut(_20, _21, _22, Let((_41, Int), Let((_42, Int), Var(k.17), Let((_43, Int), Int(1), Sub(_42, _43))), CallClosure(loop3.16, [_41])))
  lw t0, -128(s0)
  lw t1, -136(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -272(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_20, _21, _22, Let((_41, Int), Let((_42, Int), Var(k.17), Let((_43, Int), Int(1), Sub(_42, _43))), CallClosure(loop3.16, [_41])))
  lw a0, -8(s0)
  sw a0, -280(s0)
  li a0, 1
  sw a0, -288(s0)
  lw t0, -280(s0)
  lw t1, -288(s0)
  sub a0, t0, t1
  sw a0, -296(s0)
  # CallClosure loop3.16 [_41]
  lw t0, -296(s0)
  sw t0, -312(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -320(s0)
  addi s0, s0, -304
  jalr ra, s1, 0
  addi s0, s0, 304
  # CallClosure End loop3.16 [_41]
ifeq_end_2:
  lw ra, 0(s0)
  jr ra

loop2.12:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  sw s1, -24(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -48(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -56(s0)
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -64(s0)
  addi s1, s1, 8
  sw s1, -72(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  li a0, 0
  sw a0, -80(s0)
  lw a0, -8(s0)
  sw a0, -88(s0)
  lw t0, -80(s0)
  lw t1, -88(s0)
  ble t0, t1, ifle_then_3
  li a0, 0
  j ifle_end_3
ifle_then_3:
  li a0, 1
ifle_end_3:
  sw a0, -96(s0)
  li a0, 1
  sw a0, -104(s0)
  lw t0, -96(s0)
  lw t1, -104(s0)
  beq t0, t1, ifeq_then_4
  mv a0, zero
  j ifeq_end_4
ifeq_then_4:
  # MakeClosure loop3.16
  mv s1, s3
  addi s3, s3, 16
  la t0, loop3.16
  sw t0, -8(s3)
  li s2, 16
  lw t0, -24(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -24(s0)
  lw t1, 0(t0)
data_copy_5:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_5
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -48(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -48(s0)
  lw t1, 0(t0)
data_copy_6:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_6
  addi s2, s2, 8
  lw t0, -56(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, 8
  lw t0, -64(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -16(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -16(s0)
  lw t1, 0(t0)
data_copy_7:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_7
  lw t0, -72(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -72(s0)
  lw t1, 0(t0)
data_copy_8:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_8
  sw s2, 0(s1)
  sw s1, -112(s0)
  # MakeClosure End loop3.16
  lw a0, -56(s0)
  sw a0, -120(s0)
  li a0, 1
  sw a0, -128(s0)
  lw t0, -120(s0)
  lw t1, -128(s0)
  sub a0, t0, t1
  sw a0, -136(s0)
  # CallClosure loop3.16 [_47]
  lw t0, -136(s0)
  sw t0, -152(s0)
  lw t0, -112(s0)
  lw s1, 8(t0)
  sw t0, -160(s0)
  addi s0, s0, -144
  jalr ra, s1, 0
  addi s0, s0, 144
  # CallClosure End loop3.16 [_47]
  sw a0, -144(s0)
  lw a0, -8(s0)
  sw a0, -152(s0)
  li a0, 1
  sw a0, -160(s0)
  lw t0, -152(s0)
  lw t1, -160(s0)
  sub a0, t0, t1
  sw a0, -168(s0)
  # CallClosure loop2.12 [_50]
  lw t0, -168(s0)
  sw t0, -184(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -192(s0)
  addi s0, s0, -176
  jalr ra, s1, 0
  addi s0, s0, 176
  # CallClosure End loop2.12 [_50]
ifeq_end_4:
  lw ra, 0(s0)
  jr ra

loop1.8:
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
  sw s1, -48(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw t0, 0(s1)
  sw t0, -56(s0)
  addi s1, s1, 8
  sw s1, -64(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  li a0, 0
  sw a0, -72(s0)
  lw a0, -8(s0)
  sw a0, -80(s0)
  lw t0, -72(s0)
  lw t1, -80(s0)
  ble t0, t1, ifle_then_9
  li a0, 0
  j ifle_end_9
ifle_then_9:
  li a0, 1
ifle_end_9:
  sw a0, -88(s0)
  li a0, 1
  sw a0, -96(s0)
  lw t0, -88(s0)
  lw t1, -96(s0)
  beq t0, t1, ifeq_then_10
  mv a0, zero
  j ifeq_end_10
ifeq_then_10:
  # MakeClosure loop2.12
  mv s1, s3
  addi s3, s3, 16
  la t0, loop2.12
  sw t0, -8(s3)
  li s2, 16
  lw t0, -24(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -24(s0)
  lw t1, 0(t0)
data_copy_11:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_11
  addi s2, s2, 8
  lw t0, -32(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -16(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -16(s0)
  lw t1, 0(t0)
data_copy_12:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_12
  lw t0, -48(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -48(s0)
  lw t1, 0(t0)
data_copy_13:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_13
  addi s2, s2, 8
  lw t0, -56(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -64(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -64(s0)
  lw t1, 0(t0)
data_copy_14:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_14
  sw s2, 0(s1)
  sw s1, -104(s0)
  # MakeClosure End loop2.12
  lw a0, -32(s0)
  sw a0, -112(s0)
  li a0, 1
  sw a0, -120(s0)
  lw t0, -112(s0)
  lw t1, -120(s0)
  sub a0, t0, t1
  sw a0, -128(s0)
  # CallClosure loop2.12 [_56]
  lw t0, -128(s0)
  sw t0, -144(s0)
  lw t0, -104(s0)
  lw s1, 8(t0)
  sw t0, -152(s0)
  addi s0, s0, -136
  jalr ra, s1, 0
  addi s0, s0, 136
  # CallClosure End loop2.12 [_56]
  sw a0, -136(s0)
  lw a0, -8(s0)
  sw a0, -144(s0)
  li a0, 1
  sw a0, -152(s0)
  lw t0, -144(s0)
  lw t1, -152(s0)
  sub a0, t0, t1
  sw a0, -160(s0)
  # CallClosure loop1.8 [_59]
  lw t0, -160(s0)
  sw t0, -176(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -184(s0)
  addi s0, s0, -168
  jalr ra, s1, 0
  addi s0, s0, 168
  # CallClosure End loop1.8 [_59]
ifeq_end_10:
  lw ra, 0(s0)
  jr ra

matmul.1:
  sw ra, 0(s0)
  lw s1, -56(s0)
  addi s1, s1, 16
  # MakeClosure loop1.8
  mv s1, s3
  addi s3, s3, 16
  la t0, loop1.8
  sw t0, -8(s3)
  li s2, 16
  lw t0, -48(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -48(s0)
  lw t1, 0(t0)
data_copy_15:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_15
  addi s2, s2, 8
  lw t0, -24(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -40(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -40(s0)
  lw t1, 0(t0)
data_copy_16:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_16
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -32(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -32(s0)
  lw t1, 0(t0)
data_copy_17:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_17
  sw s2, 0(s1)
  sw s1, -64(s0)
  # MakeClosure End loop1.8
  lw a0, -8(s0)
  sw a0, -72(s0)
  li a0, 1
  sw a0, -80(s0)
  lw t0, -72(s0)
  lw t1, -80(s0)
  sub a0, t0, t1
  sw a0, -88(s0)
  # CallClosure loop1.8 [_64]
  lw t0, -88(s0)
  sw t0, -104(s0)
  lw t0, -64(s0)
  lw s1, 8(t0)
  sw t0, -112(s0)
  addi s0, s0, -96
  jalr ra, s1, 0
  addi s0, s0, 96
  # CallClosure End loop1.8 [_64]
  lw ra, 0(s0)
  jr ra

init_arr.76:
  sw ra, 0(s0)
  lw s1, -16(s0)
  addi s1, s1, 16
  lw t0, 0(s1)
  sw t0, -24(s0)
  addi s1, s1, 8
  lw t0, 0(s1)
  sw t0, -32(s0)
  addi s1, s1, 8
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  li a0, 0
  sw a0, -48(s0)
  lw a0, -8(s0)
  sw a0, -56(s0)
  lw t0, -48(s0)
  lw t1, -56(s0)
  ble t0, t1, ifle_then_18
  li a0, 0
  j ifle_end_18
ifle_then_18:
  li a0, 1
ifle_end_18:
  sw a0, -64(s0)
  li a0, 1
  sw a0, -72(s0)
  lw t0, -64(s0)
  lw t1, -72(s0)
  beq t0, t1, ifeq_then_19
  mv a0, zero
  j ifeq_end_19
ifeq_then_19:
  lw a0, -40(s0)
  sw a0, -80(s0)
  lw a0, -8(s0)
  sw a0, -88(s0)
  lw a0, -24(s0)
  sw a0, -96(s0)
  la t0, const_double_0
  fld fa0, 0(t0)
  fsd fa0, -104(s0)
  # MakeArray MakeArray(_83, _84)
  mv s1, s3
  addi s3, s3, 8
  li t1, 8
  lw s2, -96(s0)
  mul t1, t1, s2
  addi t1, t1, 8
  sw t1, 0(s1)
make_array_loop_20:
  fld ft0, -104(s0)
  fsd ft0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, -1
  beq s2, zero, make_array_end_20
  j make_array_loop_20
make_array_end_20:
  mv a0, s1
  # MakeArray End MakeArray(_83, _84)
  sw a0, -112(s0)
  # ArrayPut ArrayPut(_80, _81, _82, Let((_85, Int), Let((_86, Int), Var(i.77), Let((_87, Int), Int(1), Sub(_86, _87))), CallClosure(init_arr.76, [_85])))
  lw t0, -80(s0)
  lw t1, -88(s0)
  lw t3, -80(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  lw t0, -112(s0)
  lw t1, 0(t0)
data_modify_loop_21:
  lw t2, 0(t0)
  sw t2, 0(s1)
  addi t0, t0, 8
  addi s1, s1, 8
  addi t1, t1, -8
  bne t1, zero, data_modify_loop_21
  # ArrayPut end ArrayPut(_80, _81, _82, Let((_85, Int), Let((_86, Int), Var(i.77), Let((_87, Int), Int(1), Sub(_86, _87))), CallClosure(init_arr.76, [_85])))
  lw a0, -8(s0)
  sw a0, -120(s0)
  li a0, 1
  sw a0, -128(s0)
  lw t0, -120(s0)
  lw t1, -128(s0)
  sub a0, t0, t1
  sw a0, -136(s0)
  # CallClosure init_arr.76 [_85]
  lw t0, -136(s0)
  sw t0, -152(s0)
  lw t0, -16(s0)
  lw s1, 8(t0)
  sw t0, -160(s0)
  addi s0, s0, -144
  jalr ra, s1, 0
  addi s0, s0, 144
  # CallClosure End init_arr.76 [_85]
ifeq_end_19:
  lw ra, 0(s0)
  jr ra

gen_arr.70:
  sw ra, 0(s0)
  lw s1, -24(s0)
  addi s1, s1, 16
  sw s1, -32(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  sw s1, -40(s0)
  lw t0, 0(s1)
  add s1, s1, t0
  lw a0, -8(s0)
  sw a0, -48(s0)
  lw a0, -40(s0)
  sw a0, -56(s0)
  # MakeArray MakeArray(_74, _75)
  mv s1, s3
  addi s3, s3, 8
  lw t0, -56(s0)
  lw t1, 0(t0)
  lw s2, -48(s0)
  mul t1, t1, s2
  addi t1, t1, 8
  sw t1, 0(s1)
make_array_loop_22:
  lw t0, -56(s0)
  lw t1, 0(t0)
data_copy_23:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_23
  addi s2, s2, -1
  beq s2, zero, make_array_end_22
  j make_array_loop_22
make_array_end_22:
  mv a0, s1
  # MakeArray End MakeArray(_74, _75)
  sw s3, -64(s0)
  lw t1, 0(a0)
data_copy_reg_loop_24:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_24
  # MakeClosure init_arr.76
  mv s1, s3
  addi s3, s3, 16
  la t0, init_arr.76
  sw t0, -8(s3)
  li s2, 16
  addi s2, s2, 8
  lw t0, -16(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, 8
  lw t0, -8(s0)
  sw t0, 0(s3)
  addi s3, s3, 8
  lw t0, -64(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -64(s0)
  lw t1, 0(t0)
data_copy_25:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_25
  sw s2, 0(s1)
  sw s1, -72(s0)
  # MakeClosure End init_arr.76
  lw a0, -8(s0)
  sw a0, -80(s0)
  li a0, 1
  sw a0, -88(s0)
  lw t0, -80(s0)
  lw t1, -88(s0)
  sub a0, t0, t1
  sw a0, -96(s0)
  # CallClosure init_arr.76 [_91]
  lw t0, -96(s0)
  sw t0, -112(s0)
  lw t0, -72(s0)
  lw s1, 8(t0)
  sw t0, -120(s0)
  addi s0, s0, -104
  jalr ra, s1, 0
  addi s0, s0, 104
  # CallClosure End init_arr.76 [_91]
  sw a0, -104(s0)
  lw a0, -64(s0)
  lw ra, 0(s0)
  jr ra

.global minimbt_main
minimbt_main:
  li t0, 0x100000
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s0, s3, -8
  # MakeClosure matmul.1
  mv s1, s3
  addi s3, s3, 16
  la t0, matmul.1
  sw t0, -8(s3)
  li s2, 16
  sw s2, 0(s1)
  sw s1, 0(s0)
  # MakeClosure End matmul.1
  li a0, 0
  sw a0, -8(s0)
  la t0, const_double_1
  fld fa0, 0(t0)
  fsd fa0, -16(s0)
  # MakeArray MakeArray(_68, _69)
  mv s1, s3
  addi s3, s3, 8
  li t1, 8
  lw s2, -8(s0)
  mul t1, t1, s2
  addi t1, t1, 8
  sw t1, 0(s1)
make_array_loop_26:
  fld ft0, -16(s0)
  fsd ft0, 0(s3)
  addi s3, s3, 8
  addi s2, s2, -1
  beq s2, zero, make_array_end_26
  j make_array_loop_26
make_array_end_26:
  mv a0, s1
  # MakeArray End MakeArray(_68, _69)
  sw s3, -24(s0)
  lw t1, 0(a0)
data_copy_reg_loop_27:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_27
  # MakeClosure gen_arr.70
  mv s1, s3
  addi s3, s3, 16
  la t0, gen_arr.70
  sw t0, -8(s3)
  li s2, 16
  lw t0, 0(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, 0(s0)
  lw t1, 0(t0)
data_copy_28:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_28
  lw t0, -24(s0)
  lw t1, 0(t0)
  add s2, s2, t1
  lw t0, -24(s0)
  lw t1, 0(t0)
data_copy_29:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_29
  sw s2, 0(s1)
  sw s1, -32(s0)
  # MakeClosure End gen_arr.70
  li a0, 3
  sw a0, -40(s0)
  li a0, 2
  sw a0, -48(s0)
  # CallClosure gen_arr.70 [_95, _96]
  lw t0, -48(s0)
  sw t0, -64(s0)
  lw t0, -40(s0)
  sw t0, -72(s0)
  lw t0, -32(s0)
  lw s1, 8(t0)
  sw t0, -80(s0)
  addi s0, s0, -56
  jalr ra, s1, 0
  addi s0, s0, 56
  # CallClosure End gen_arr.70 [_95, _96]
  sw s3, -56(s0)
  lw t1, 0(a0)
data_copy_reg_loop_30:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_30
  li a0, 2
  sw a0, -64(s0)
  li a0, 3
  sw a0, -72(s0)
  # CallClosure gen_arr.70 [_98, _99]
  lw t0, -72(s0)
  sw t0, -88(s0)
  lw t0, -64(s0)
  sw t0, -96(s0)
  lw t0, -32(s0)
  lw s1, 8(t0)
  sw t0, -104(s0)
  addi s0, s0, -80
  jalr ra, s1, 0
  addi s0, s0, 80
  # CallClosure End gen_arr.70 [_98, _99]
  sw s3, -80(s0)
  lw t1, 0(a0)
data_copy_reg_loop_31:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_31
  li a0, 2
  sw a0, -88(s0)
  li a0, 2
  sw a0, -96(s0)
  # CallClosure gen_arr.70 [_101, _102]
  lw t0, -96(s0)
  sw t0, -112(s0)
  lw t0, -88(s0)
  sw t0, -120(s0)
  lw t0, -32(s0)
  lw s1, 8(t0)
  sw t0, -128(s0)
  addi s0, s0, -104
  jalr ra, s1, 0
  addi s0, s0, 104
  # CallClosure End gen_arr.70 [_101, _102]
  sw s3, -104(s0)
  lw t1, 0(a0)
data_copy_reg_loop_32:
  lw t2, 0(a0)
  sw t2, 0(s3)
  addi a0, a0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_reg_loop_32
  lw a0, -56(s0)
  sw a0, -112(s0)
  li a0, 0
  sw a0, -120(s0)
  # ArrayGet ArrayGet(_106, _107)
  lw t0, -112(s0)
  lw t1, -120(s0)
  lw t3, -112(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_106, _107)
  sw a0, -128(s0)
  li a0, 0
  sw a0, -136(s0)
  la t0, const_double_2
  fld fa0, 0(t0)
  fsd fa0, -144(s0)
  # ArrayPut ArrayPut(_103, _104, _105, Let((_108, Array(Double)), Let((_111, Array(Array(Double))), Var(a.94), Let((_112, Int), Int(0), ArrayGet(_111, _112))), Let((_109, Int), Int(1), Let((_110, Double), Double(2), ArrayPut(_108, _109, _110, Let((_113, Array(Double)), Let((_116, Array(Array(Double))), Var(a.94), Let((_117, Int), Int(0), ArrayGet(_116, _117))), Let((_114, Int), Int(2), Let((_115, Double), Double(3), ArrayPut(_113, _114, _115, Let((_118, Array(Double)), Let((_121, Array(Array(Double))), Var(a.94), Let((_122, Int), Int(1), ArrayGet(_121, _122))), Let((_119, Int), Int(0), Let((_120, Double), Double(4), ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))))))))))))))
  lw t0, -128(s0)
  lw t1, -136(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -144(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_103, _104, _105, Let((_108, Array(Double)), Let((_111, Array(Array(Double))), Var(a.94), Let((_112, Int), Int(0), ArrayGet(_111, _112))), Let((_109, Int), Int(1), Let((_110, Double), Double(2), ArrayPut(_108, _109, _110, Let((_113, Array(Double)), Let((_116, Array(Array(Double))), Var(a.94), Let((_117, Int), Int(0), ArrayGet(_116, _117))), Let((_114, Int), Int(2), Let((_115, Double), Double(3), ArrayPut(_113, _114, _115, Let((_118, Array(Double)), Let((_121, Array(Array(Double))), Var(a.94), Let((_122, Int), Int(1), ArrayGet(_121, _122))), Let((_119, Int), Int(0), Let((_120, Double), Double(4), ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))))))))))))))
  lw a0, -56(s0)
  sw a0, -152(s0)
  li a0, 0
  sw a0, -160(s0)
  # ArrayGet ArrayGet(_111, _112)
  lw t0, -152(s0)
  lw t1, -160(s0)
  lw t3, -152(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_111, _112)
  sw a0, -168(s0)
  li a0, 1
  sw a0, -176(s0)
  la t0, const_double_3
  fld fa0, 0(t0)
  fsd fa0, -184(s0)
  # ArrayPut ArrayPut(_108, _109, _110, Let((_113, Array(Double)), Let((_116, Array(Array(Double))), Var(a.94), Let((_117, Int), Int(0), ArrayGet(_116, _117))), Let((_114, Int), Int(2), Let((_115, Double), Double(3), ArrayPut(_113, _114, _115, Let((_118, Array(Double)), Let((_121, Array(Array(Double))), Var(a.94), Let((_122, Int), Int(1), ArrayGet(_121, _122))), Let((_119, Int), Int(0), Let((_120, Double), Double(4), ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))))))))))
  lw t0, -168(s0)
  lw t1, -176(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -184(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_108, _109, _110, Let((_113, Array(Double)), Let((_116, Array(Array(Double))), Var(a.94), Let((_117, Int), Int(0), ArrayGet(_116, _117))), Let((_114, Int), Int(2), Let((_115, Double), Double(3), ArrayPut(_113, _114, _115, Let((_118, Array(Double)), Let((_121, Array(Array(Double))), Var(a.94), Let((_122, Int), Int(1), ArrayGet(_121, _122))), Let((_119, Int), Int(0), Let((_120, Double), Double(4), ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))))))))))
  lw a0, -56(s0)
  sw a0, -192(s0)
  li a0, 0
  sw a0, -200(s0)
  # ArrayGet ArrayGet(_116, _117)
  lw t0, -192(s0)
  lw t1, -200(s0)
  lw t3, -192(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_116, _117)
  sw a0, -208(s0)
  li a0, 2
  sw a0, -216(s0)
  la t0, const_double_4
  fld fa0, 0(t0)
  fsd fa0, -224(s0)
  # ArrayPut ArrayPut(_113, _114, _115, Let((_118, Array(Double)), Let((_121, Array(Array(Double))), Var(a.94), Let((_122, Int), Int(1), ArrayGet(_121, _122))), Let((_119, Int), Int(0), Let((_120, Double), Double(4), ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))))))
  lw t0, -208(s0)
  lw t1, -216(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -224(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_113, _114, _115, Let((_118, Array(Double)), Let((_121, Array(Array(Double))), Var(a.94), Let((_122, Int), Int(1), ArrayGet(_121, _122))), Let((_119, Int), Int(0), Let((_120, Double), Double(4), ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))))))
  lw a0, -56(s0)
  sw a0, -232(s0)
  li a0, 1
  sw a0, -240(s0)
  # ArrayGet ArrayGet(_121, _122)
  lw t0, -232(s0)
  lw t1, -240(s0)
  lw t3, -232(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_121, _122)
  sw a0, -248(s0)
  li a0, 0
  sw a0, -256(s0)
  la t0, const_double_5
  fld fa0, 0(t0)
  fsd fa0, -264(s0)
  # ArrayPut ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))
  lw t0, -248(s0)
  lw t1, -256(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -264(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_118, _119, _120, Let((_123, Array(Double)), Let((_126, Array(Array(Double))), Var(a.94), Let((_127, Int), Int(1), ArrayGet(_126, _127))), Let((_124, Int), Int(1), Let((_125, Double), Double(5), ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))))))
  lw a0, -56(s0)
  sw a0, -272(s0)
  li a0, 1
  sw a0, -280(s0)
  # ArrayGet ArrayGet(_126, _127)
  lw t0, -272(s0)
  lw t1, -280(s0)
  lw t3, -272(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_126, _127)
  sw a0, -288(s0)
  li a0, 1
  sw a0, -296(s0)
  la t0, const_double_6
  fld fa0, 0(t0)
  fsd fa0, -304(s0)
  # ArrayPut ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))
  lw t0, -288(s0)
  lw t1, -296(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -304(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_123, _124, _125, Let((_128, Array(Double)), Let((_131, Array(Array(Double))), Var(a.94), Let((_132, Int), Int(1), ArrayGet(_131, _132))), Let((_129, Int), Int(2), Let((_130, Double), Double(6), ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))))))
  lw a0, -56(s0)
  sw a0, -312(s0)
  li a0, 1
  sw a0, -320(s0)
  # ArrayGet ArrayGet(_131, _132)
  lw t0, -312(s0)
  lw t1, -320(s0)
  lw t3, -312(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_131, _132)
  sw a0, -328(s0)
  li a0, 2
  sw a0, -336(s0)
  la t0, const_double_7
  fld fa0, 0(t0)
  fsd fa0, -344(s0)
  # ArrayPut ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))
  lw t0, -328(s0)
  lw t1, -336(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -344(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_128, _129, _130, Let((_133, Array(Double)), Let((_136, Array(Array(Double))), Var(b.97), Let((_137, Int), Int(0), ArrayGet(_136, _137))), Let((_134, Int), Int(0), Let((_135, Double), Double(7), ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))))))
  lw a0, -80(s0)
  sw a0, -352(s0)
  li a0, 0
  sw a0, -360(s0)
  # ArrayGet ArrayGet(_136, _137)
  lw t0, -352(s0)
  lw t1, -360(s0)
  lw t3, -352(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_136, _137)
  sw a0, -368(s0)
  li a0, 0
  sw a0, -376(s0)
  la t0, const_double_8
  fld fa0, 0(t0)
  fsd fa0, -384(s0)
  # ArrayPut ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))
  lw t0, -368(s0)
  lw t1, -376(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -384(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_133, _134, _135, Let((_138, Array(Double)), Let((_141, Array(Array(Double))), Var(b.97), Let((_142, Int), Int(0), ArrayGet(_141, _142))), Let((_139, Int), Int(1), Let((_140, Double), Double(8), ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))))))
  lw a0, -80(s0)
  sw a0, -392(s0)
  li a0, 0
  sw a0, -400(s0)
  # ArrayGet ArrayGet(_141, _142)
  lw t0, -392(s0)
  lw t1, -400(s0)
  lw t3, -392(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_141, _142)
  sw a0, -408(s0)
  li a0, 1
  sw a0, -416(s0)
  la t0, const_double_9
  fld fa0, 0(t0)
  fsd fa0, -424(s0)
  # ArrayPut ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))
  lw t0, -408(s0)
  lw t1, -416(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -424(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_138, _139, _140, Let((_143, Array(Double)), Let((_146, Array(Array(Double))), Var(b.97), Let((_147, Int), Int(1), ArrayGet(_146, _147))), Let((_144, Int), Int(0), Let((_145, Double), Double(9), ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))))))
  lw a0, -80(s0)
  sw a0, -432(s0)
  li a0, 1
  sw a0, -440(s0)
  # ArrayGet ArrayGet(_146, _147)
  lw t0, -432(s0)
  lw t1, -440(s0)
  lw t3, -432(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_146, _147)
  sw a0, -448(s0)
  li a0, 0
  sw a0, -456(s0)
  la t0, const_double_10
  fld fa0, 0(t0)
  fsd fa0, -464(s0)
  # ArrayPut ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))
  lw t0, -448(s0)
  lw t1, -456(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -464(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_143, _144, _145, Let((_148, Array(Double)), Let((_151, Array(Array(Double))), Var(b.97), Let((_152, Int), Int(1), ArrayGet(_151, _152))), Let((_149, Int), Int(1), Let((_150, Double), Double(10), ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))))))
  lw a0, -80(s0)
  sw a0, -472(s0)
  li a0, 1
  sw a0, -480(s0)
  # ArrayGet ArrayGet(_151, _152)
  lw t0, -472(s0)
  lw t1, -480(s0)
  lw t3, -472(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_151, _152)
  sw a0, -488(s0)
  li a0, 1
  sw a0, -496(s0)
  la t0, const_double_11
  fld fa0, 0(t0)
  fsd fa0, -504(s0)
  # ArrayPut ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))
  lw t0, -488(s0)
  lw t1, -496(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -504(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_148, _149, _150, Let((_153, Array(Double)), Let((_156, Array(Array(Double))), Var(b.97), Let((_157, Int), Int(2), ArrayGet(_156, _157))), Let((_154, Int), Int(0), Let((_155, Double), Double(11), ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))))))
  lw a0, -80(s0)
  sw a0, -512(s0)
  li a0, 2
  sw a0, -520(s0)
  # ArrayGet ArrayGet(_156, _157)
  lw t0, -512(s0)
  lw t1, -520(s0)
  lw t3, -512(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_156, _157)
  sw a0, -528(s0)
  li a0, 0
  sw a0, -536(s0)
  la t0, const_double_12
  fld fa0, 0(t0)
  fsd fa0, -544(s0)
  # ArrayPut ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))
  lw t0, -528(s0)
  lw t1, -536(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -544(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_153, _154, _155, Let((_158, Array(Double)), Let((_161, Array(Array(Double))), Var(b.97), Let((_162, Int), Int(2), ArrayGet(_161, _162))), Let((_159, Int), Int(1), Let((_160, Double), Double(12), ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))))))
  lw a0, -80(s0)
  sw a0, -552(s0)
  li a0, 2
  sw a0, -560(s0)
  # ArrayGet ArrayGet(_161, _162)
  lw t0, -552(s0)
  lw t1, -560(s0)
  lw t3, -552(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_161, _162)
  sw a0, -568(s0)
  li a0, 1
  sw a0, -576(s0)
  la t0, const_double_13
  fld fa0, 0(t0)
  fsd fa0, -584(s0)
  # ArrayPut ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))
  lw t0, -568(s0)
  lw t1, -576(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld ft0, -584(s0)
  fsd ft0, 0(s1)
  # ArrayPut end ArrayPut(_158, _159, _160, Let((_.163, Unit), Let((_169, Array(Array(Double))), Var(c.100), Let((_168, Array(Array(Double))), Var(b.97), Let((_167, Array(Array(Double))), Var(a.94), Let((_166, Int), Int(2), Let((_165, Int), Int(3), Let((_164, Int), Int(2), CallClosure(matmul.1, [_164, _165, _166, _167, _168, _169]))))))), Let((_.170, Unit), Let((_171, Int), Let((_172, Double), Let((_173, Array(Double)), Let((_175, Array(Array(Double))), Var(c.100), Let((_176, Int), Int(0), ArrayGet(_175, _176))), Let((_174, Int), Int(0), ArrayGet(_173, _174))), CallDirect(Label("minimbt_truncate"), [_172])), CallDirect(Label("minimbt_print_int"), [_171])), Let((_.177, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.178, Unit), Let((_179, Int), Let((_180, Double), Let((_181, Array(Double)), Let((_183, Array(Array(Double))), Var(c.100), Let((_184, Int), Int(0), ArrayGet(_183, _184))), Let((_182, Int), Int(1), ArrayGet(_181, _182))), CallDirect(Label("minimbt_truncate"), [_180])), CallDirect(Label("minimbt_print_int"), [_179])), Let((_.185, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.186, Unit), Let((_187, Int), Let((_188, Double), Let((_189, Array(Double)), Let((_191, Array(Array(Double))), Var(c.100), Let((_192, Int), Int(1), ArrayGet(_191, _192))), Let((_190, Int), Int(0), ArrayGet(_189, _190))), CallDirect(Label("minimbt_truncate"), [_188])), CallDirect(Label("minimbt_print_int"), [_187])), Let((_.193, Unit), CallDirect(Label("minimbt_print_endline"), []), Let((_.194, Unit), Let((_195, Int), Let((_196, Double), Let((_197, Array(Double)), Let((_199, Array(Array(Double))), Var(c.100), Let((_200, Int), Int(1), ArrayGet(_199, _200))), Let((_198, Int), Int(1), ArrayGet(_197, _198))), CallDirect(Label("minimbt_truncate"), [_196])), CallDirect(Label("minimbt_print_int"), [_195])), Unit)))))))))
  lw a0, -104(s0)
  sw a0, -592(s0)
  lw a0, -80(s0)
  sw a0, -600(s0)
  lw a0, -56(s0)
  sw a0, -608(s0)
  li a0, 2
  sw a0, -616(s0)
  li a0, 3
  sw a0, -624(s0)
  li a0, 2
  sw a0, -632(s0)
  # CallClosure matmul.1 [_164, _165, _166, _167, _168, _169]
  lw t0, -632(s0)
  sw t0, -648(s0)
  lw t0, -624(s0)
  sw t0, -656(s0)
  lw t0, -616(s0)
  sw t0, -664(s0)
  lw t0, -608(s0)
  sw t0, -672(s0)
  lw t0, -608(s0)
  lw t1, 0(t0)
data_copy_33:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_33
  lw t0, -600(s0)
  sw t0, -680(s0)
  lw t0, -600(s0)
  lw t1, 0(t0)
data_copy_34:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_34
  lw t0, -592(s0)
  sw t0, -688(s0)
  lw t0, -592(s0)
  lw t1, 0(t0)
data_copy_35:
  lw t2, 0(t0)
  sw t2, 0(s3)
  addi t0, t0, 8
  addi s3, s3, 8
  addi t1, t1, -8
  bne t1, zero, data_copy_35
  lw t0, 0(s0)
  lw s1, 8(t0)
  sw t0, -696(s0)
  addi s0, s0, -640
  jalr ra, s1, 0
  addi s0, s0, 640
  # CallClosure End matmul.1 [_164, _165, _166, _167, _168, _169]
  sw a0, -640(s0)
  lw a0, -104(s0)
  sw a0, -648(s0)
  li a0, 0
  sw a0, -656(s0)
  # ArrayGet ArrayGet(_175, _176)
  lw t0, -648(s0)
  lw t1, -656(s0)
  lw t3, -648(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_175, _176)
  sw a0, -664(s0)
  li a0, 0
  sw a0, -672(s0)
  # ArrayGet ArrayGet(_173, _174)
  lw t0, -664(s0)
  lw t1, -672(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld fa0, 0(s1)
  # ArrayGet End ArrayGet(_173, _174)
  fsd fa0, -680(s0)
  # Ecall Label("minimbt_truncate") [_172]
  fld fa0, -680(s0)
  call minimbt_truncate
  sw a0, -688(s0)
  # Ecall Label("minimbt_print_int") [_171]
  lw a0, -688(s0)
  call minimbt_print_int
  sw a0, -696(s0)
  # Ecall Label("minimbt_print_endline") []
  call minimbt_print_endline
  sw a0, -704(s0)
  lw a0, -104(s0)
  sw a0, -712(s0)
  li a0, 0
  sw a0, -720(s0)
  # ArrayGet ArrayGet(_183, _184)
  lw t0, -712(s0)
  lw t1, -720(s0)
  lw t3, -712(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_183, _184)
  sw a0, -728(s0)
  li a0, 1
  sw a0, -736(s0)
  # ArrayGet ArrayGet(_181, _182)
  lw t0, -728(s0)
  lw t1, -736(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld fa0, 0(s1)
  # ArrayGet End ArrayGet(_181, _182)
  fsd fa0, -744(s0)
  # Ecall Label("minimbt_truncate") [_180]
  fld fa0, -744(s0)
  call minimbt_truncate
  sw a0, -752(s0)
  # Ecall Label("minimbt_print_int") [_179]
  lw a0, -752(s0)
  call minimbt_print_int
  sw a0, -760(s0)
  # Ecall Label("minimbt_print_endline") []
  call minimbt_print_endline
  sw a0, -768(s0)
  lw a0, -104(s0)
  sw a0, -776(s0)
  li a0, 1
  sw a0, -784(s0)
  # ArrayGet ArrayGet(_191, _192)
  lw t0, -776(s0)
  lw t1, -784(s0)
  lw t3, -776(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_191, _192)
  sw a0, -792(s0)
  li a0, 0
  sw a0, -800(s0)
  # ArrayGet ArrayGet(_189, _190)
  lw t0, -792(s0)
  lw t1, -800(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld fa0, 0(s1)
  # ArrayGet End ArrayGet(_189, _190)
  fsd fa0, -808(s0)
  # Ecall Label("minimbt_truncate") [_188]
  fld fa0, -808(s0)
  call minimbt_truncate
  sw a0, -816(s0)
  # Ecall Label("minimbt_print_int") [_187]
  lw a0, -816(s0)
  call minimbt_print_int
  sw a0, -824(s0)
  # Ecall Label("minimbt_print_endline") []
  call minimbt_print_endline
  sw a0, -832(s0)
  lw a0, -104(s0)
  sw a0, -840(s0)
  li a0, 1
  sw a0, -848(s0)
  # ArrayGet ArrayGet(_199, _200)
  lw t0, -840(s0)
  lw t1, -848(s0)
  lw t3, -840(s0)
  lw t2, 8(t3)
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  mv a0, s1
  # ArrayGet End ArrayGet(_199, _200)
  sw a0, -856(s0)
  li a0, 1
  sw a0, -864(s0)
  # ArrayGet ArrayGet(_197, _198)
  lw t0, -856(s0)
  lw t1, -864(s0)
  li t2, 8
  addi t0, t0, 8
  mul t3, t1, t2
  add s1, t0, t3
  fld fa0, 0(s1)
  # ArrayGet End ArrayGet(_197, _198)
  fsd fa0, -872(s0)
  # Ecall Label("minimbt_truncate") [_196]
  fld fa0, -872(s0)
  call minimbt_truncate
  sw a0, -880(s0)
  # Ecall Label("minimbt_print_int") [_195]
  lw a0, -880(s0)
  call minimbt_print_int
  sw a0, -888(s0)
  mv a0, zero

