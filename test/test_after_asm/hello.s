.data
const_double_0:
  .double 12.3

const_double_1:
  .double 4.5

const_double_2:
  .double 6.7

const_double_3:
  .double 8.9

const_double_4:
  .double 1.2345678900000001

.text
.global minimbt_main
minimbt_main:
  li t0, 0x100000
  add a0, t0, t0
  call minimbt_malloc
  add s3, a0, t0
  addi s0, s3, -8
  la t0, const_double_0
  fld fa0, 0(t0)
  fsd fa0, 0(s0)
  fld fa0, 0(s0)
  fneg.d fa0, fa0
  fsd fa0, -8(s0)
  # Ecall Label("minimbt_abs_float") [_12]
  fld fa0, -8(s0)
  call minimbt_abs_float
  fsd fa0, -16(s0)
  # Ecall Label("minimbt_sqrt") [_11]
  fld fa0, -16(s0)
  call minimbt_sqrt
  fsd fa0, -24(s0)
  # Ecall Label("minimbt_cos") [_10]
  fld fa0, -24(s0)
  call minimbt_cos
  fsd fa0, -32(s0)
  # Ecall Label("minimbt_sin") [_9]
  fld fa0, -32(s0)
  call minimbt_sin
  fsd fa0, -40(s0)
  la t0, const_double_1
  fld fa0, 0(t0)
  fsd fa0, -48(s0)
  fld ft0, -40(s0)
  fld ft1, -48(s0)
  fadd.d fa0, ft0, ft1
  fsd fa0, -56(s0)
  la t0, const_double_2
  fld fa0, 0(t0)
  fsd fa0, -64(s0)
  la t0, const_double_3
  fld fa0, 0(t0)
  fsd fa0, -72(s0)
  fld ft0, -64(s0)
  fld ft1, -72(s0)
  fmul.d fa0, ft0, ft1
  fsd fa0, -80(s0)
  la t0, const_double_4
  fld fa0, 0(t0)
  fsd fa0, -88(s0)
  fld ft0, -80(s0)
  fld ft1, -88(s0)
  fdiv.d fa0, ft0, ft1
  fsd fa0, -96(s0)
  fld ft0, -56(s0)
  fld ft1, -96(s0)
  fsub.d fa0, ft0, ft1
  fsd fa0, -104(s0)
  li a0, 1000000
  sw a0, -112(s0)
  # Ecall Label("minimbt_float_of_int") [_18]
  lw a0, -112(s0)
  call minimbt_float_of_int
  fsd fa0, -120(s0)
  fld ft0, -104(s0)
  fld ft1, -120(s0)
  fmul.d fa0, ft0, ft1
  fsd fa0, -128(s0)
  # Ecall Label("minimbt_int_of_float") [_2]
  fld fa0, -128(s0)
  call minimbt_int_of_float
  sw a0, -136(s0)
  # Ecall Label("minimbt_print_int") [_1]
  lw a0, -136(s0)
  call minimbt_print_int

