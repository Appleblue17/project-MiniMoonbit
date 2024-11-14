// 由于数组长度是可变的，Tuple 和 Array 数据需要手动管理内存；其它类型数据直接存在栈上。
// Tuple 格式： size, [data1], [data2], ...
// Array 格式： size, [data1], [data2], ...
// Closure 格式： size, ptr, fv1, fv2, ...
// 调用栈头指针为 S4，向下增长。数据区是另一个栈（然而并不会退栈），头指针为 sp，向上增长
// 在定义变量时 S4 不会增长，而会让 global_offset 增长（实际上是减小）；在函数调用时一次性令 S4 += global_offset，然后 global_offset = 0 （似乎叫栈指针省略）
// 在加入数据时 sp 会增长。S4(+global_offset) 会在对应变量处记录数据地址

typealias LocalEnv = @immut/hashmap.T[Name, (Int, LowType)] // 存的是指针在栈帧内的位置（S4+offset）与类型 

struct InterpreterEnv {
  extern_fns: Map[String, (Array[LowType]) -> LowType]
  functions: Map[String, @closure.FuncDef]
}
pub fn InterpreterEnv::new() -> InterpreterEnv {
  { extern_fns: Map::new(), functions: Map::new() }
}
pub fn InterpreterEnv::add_extern_fn(
  self : InterpreterEnv,
  name : String,
  f : (Array[LowType]) -> LowType
) -> Unit {
  self.extern_fns.set(name, f)
}

fn find(env : LocalEnv, name : Name) -> (Int, LowType) {
  let ret = env.find(name)
  match ret {
    None => {
      println(env)
      @util.die("variable not found: \{name}")
    }
    Some(v) => v
  }
}

////////////////////////////////////////////////////
let global_offset: Ref[Int] = {val: 0}
let label_counter: Ref[Int] = {val: 0}

// internal 为 true 时，将数据放入数据区中；否则会将 Unit / Bool / Int / Double 放入栈中
fn data_copy(pos: Int, ty: LowType, ~internal: Bool) -> AsmList {
  match ty {
    Unit | Bool | Int => {
      if internal {
        [
          Lw(T0, {base: S4, offset: pos}), 
          Sw(T0, {base: S3, offset: 0}),
          Addi(S3, S3, 8)
        ]
      }
      else {
        global_offset.val -= 8
        [
          Lw(T0, {base: S4, offset: pos}), 
          Sw(T0, {base: S4, offset: global_offset.val+8})
        ]
      }
    }
    Double => {
      if internal {
        [
          Fld(Ft0, {base: S4, offset: pos}), 
          Fsd(Ft0, {base: S3, offset: 0}),
          Addi(S3, S3, 8)
        ]
      }
      else {
        global_offset.val -= 8
        [
          Fld(Ft0, {base: S4, offset: pos}), 
          Fsd(Ft0, {base: S4, offset: global_offset.val+8})
        ]
      }
    }
    Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
      label_counter.val += 1
      [
        Lw(T0, {base: S4, offset: pos}), // 加载地址
        Lw(T1, {base: T0, offset: 0}), // 加载数据长度
        
        Label("data_copy_\{label_counter.val}"),
        Lw(T2, {base: T0, offset: 0}),
        Sw(T2, {base: S3, offset: 0}),
        Addi(T0, T0, 8),
        Addi(S3, S3, 8),
        Addi(T1, T1, -8),
        Bne(T1, Zero, "data_copy_\{label_counter.val}"),
      ]
    }
    _ => @util.die("Asm error: data_copy not implemented.")
  }
}

// 会自动将 reg 移动到末尾
fn data_copy_reg(reg: Reg, ty: LowType, ~internal: Bool) -> AsmList {
  match ty {
    Unit | Bool | Int => {
      if internal {
        [
          Lw(T0, {base: reg, offset: 0}), 
          Sw(T0, {base: S3, offset: 0}),
          Addi(S3, S3, 8),
          Addi(reg, reg, 8),
        ]
      }
      else {
        global_offset.val -= 8
        [
          Lw(T0, {base: reg, offset: 0}), 
          Sw(T0, {base: S4, offset: global_offset.val+8}),
          Addi(reg, reg, 8),
        ]
      }
    }
    Double => {
      if internal {
        [
          Fld(Ft0, {base: reg, offset: 0}), 
          Fsd(Ft0, {base: S3, offset: 0}),
          Addi(S3, S3, 8),
          Addi(reg, reg, 8),
        ]
      }
      else {
        global_offset.val -= 8
        [
          Fld(Ft0, {base: reg, offset: 0}), 
          Fsd(Ft0, {base: S4, offset: global_offset.val+8}),
          Addi(reg, reg, 8),
        ]
      }
    }
    Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
      label_counter.val += 1
      [
        Lw(T1, {base: reg, offset: 0}), // 加载数据长度
        
        Label("data_copy_reg_loop_\{label_counter.val}"),
        Lw(T2, {base: reg, offset: 0}),
        Sw(T2, {base: S3, offset: 0}),
        Addi(reg, reg, 8),
        Addi(S3, S3, 8),
        Addi(T1, T1, -8),
        Bne(T1, Zero, "data_copy_reg_loop_\{label_counter.val}"),
      ]
    }
    _ => @util.die("Asm error: data_copy_reg not implemented.")
  }
}

fn data_modify(pos: Int, ty: LowType, reg: Reg) -> AsmList {
  match ty {
    Unit | Bool | Int => {
      [
        Lw(T0, {base: S4, offset: pos}),
        Sw(T0, {base: reg, offset: 0}),
      ]
    }
    Double => {
      [
        Fld(Ft0, {base: S4, offset: pos}),
        Fsd(Ft0, {base: reg, offset: 0}),
      ]
    }
    Tuple(_) | Array(_) | Closure(_)=> {
      label_counter.val += 1
      [
        Lw(T0, {base: S4, offset: pos}), // 加载地址
        Lw(T1, {base: T0, offset: 0}), // 加载数据长度
        
        Label("data_modify_loop_\{label_counter.val}"),
        Lw(T2, {base: T0, offset: 0}),
        Sw(T2, {base: reg, offset: 0}),
        Addi(T0, T0, 8),
        Addi(reg, reg, 8),
        Addi(T1, T1, -8),
        Bne(T1, Zero, "data_modify_loop_\{label_counter.val}"),
        
      ]
    }
    _ => @util.die("Asm error: data_modify not implemented.")
  }
}

/////////////////////////////////////////////////////

let const_double: Array[Double] = []
pub fn emit(
  input : Program
) -> Array[AssemblyFunction] {
  const_double.clear()
  label_counter.val = 0
  
  let env = InterpreterEnv::new()
  //@TODO: 将外部函数放入 env
  
  for f in input.fundefs {
    env.functions.set(f.name._, f)
  }
  
  // 初始化 sp 和 S4，sp = S4 + 8
  // let init: AsmList = [
  //   Li(S4, "0x0ffffff8"),
  //   Li(S3, "0x10000000"),
  // ]
  
  let init: AsmList = [
    Li(T0, "0x100000"), // 申请 2MB 内存
    Add(A0, T0, T0),
    Call("minimbt_malloc"),
    Add(S3, A0, T0), // 申请的内存地址（中间）
    Addi(S4, S3, -8)
  ]
  
  // let init: AsmList = [
  //   Li(A0, "0x1000"), // 申请 2MB 内存
  //   Call("minimbt_malloc"),
  //   Mv(S4, A0),
    
  //   Li(A0, "0x1008"), // 申请 2MB 内存
  //   Call("minimbt_malloc"),
  //   Li(S4, "0x1000"),
  //   Add(S4, A0, S4),
  // ]
  
  let function_asms = []
  // let function_asms = [
  //     {name: "_start", export: false, body: [Call("minimbt_main")] } ]
  
  for f in input.fundefs {
    // 这里是所有闭包的定义
    // 需要为所有参数和自由变量预留接口(内存地址)
    // 在程序中创建闭包时，将自由变量的值写入内存
    // 在调用闭包时，提取自由变量的值，然后和参数一起写入内存并调用
    // 调用格式： [ra], arg0, arg1, ..., agrk, closure_ptr, [fv1, fv2, ..., fvn]
    // 首先将 closure_ptr 内的自由变量进行处理展开
    // 执行完成后 a0 是 返回值 的地址
    global_offset.val = 0
    let asm: AsmList = []
    let mut ctx: LocalEnv = LocalEnv::new()
    
    asm.appendx([ Sw(Ra, {base: S4, offset: global_offset.val}) ]) // 保存 ra
    global_offset.val -= 8
    
    for arg in f.args {
      ctx = ctx.add(arg.0, (global_offset.val, arg.1))
      global_offset.val -= 8
    }
    
    asm.appendx([
      Lw(S1, {base: S4, offset: global_offset.val}),
      Addi(S1, S1, 16) // 闭包块上的指针，逐个提取每个自由变量的地址。初始化为 2 bytes 是因为前两个是 size 和 ptr
    ])
    
    ctx = ctx.add(Name::from_string?(f.name._).unwrap(), (global_offset.val, f.ty))
    global_offset.val -= 8 // 为闭包块的指针预留空间
    for arg in f.formal_free_vars {
      match arg.1 {
        Unit | Bool | Int | Double => {
          asm.appendx([
            Lw(T0, {base: S1, offset: 0}),
            Sw(T0, {base: S4, offset: global_offset.val}),
            Addi(S1, S1, 8),
          ])
        }
        Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
          asm.appendx([
            Sw(S1, {base: S4, offset: global_offset.val}),
            Lw(T0, {base: S1, offset: 0}), // 加载长度
            Add(S1, S1, T0)
          ])
        }
        _ => @util.die("Asm error: init not implemented.")
      }
      
      ctx = ctx.add(arg.0, (global_offset.val, arg.1))
      global_offset.val -= 8
    }
    
    function_asms.push(
      {name: f.name._, export: false, is_text: true, body: asm + closure_to_riscv(env, ctx, f.body) + [Lw(Ra, {base: S4, offset: 0}), Jr(Ra)] })
  }
  
  global_offset.val = 0
  let body_asm = closure_to_riscv(env, LocalEnv::new(), input.body)
  function_asms.push(
    {name: "minimbt_main", export: true, is_text: true, body: init+body_asm })
  
  let const_double_asm = []
  for i in 0..<const_double.length() {
    let x = const_double[i]
    const_double_asm.push(
      { name: "const_double_\{i}", export: false, is_text: false, body: [Text(".double \{x}")] }
    )
  }
  
  const_double_asm + function_asms
}

fn closure_to_riscv(
  env : InterpreterEnv,
  ctx : LocalEnv,
  expr : Expr
) -> AsmList {
  match expr {
    Unit => [Mv(A0, Zero)]
    Bool(true) => { [ Li(A0, "1") ] }
    Bool(false) => { [ Li(A0, "0") ] }
    Int(i) => { [ Li(A0, i.to_string()) ] }
    Double(d) => {
      let num = const_double.length()
      const_double.push(d)
      [
        La(T0, "const_double_\{num}"), // 获得常量的地址
        Fld(Fa0, {base: T0, offset: 0}), // 取值
      ]
    }
    Var(x) => {
        let (pos, typ) = find(ctx, x);
        match typ {
          Unit | Bool | Int => [ Lw(A0, {base: S4, offset: pos}) ]
          Double => [ Fld(Fa0, {base: S4, offset: pos}) ]
          Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => [ Lw(A0, {base: S4, offset: pos}) ]
          _ => @util.die("Asm error: Var not implemented.")
        }
    }
    
    Not(x) => {
      let (pos, typ) = find(ctx, x); // Bool
      guard(typ == Bool) else { @util.die("Asm error: Not arg must be Bool.") }
      [
          Lw(A0, {base: S4, offset: pos}), // 获得值
          Xori(A0, A0, 1),
      ]
    }
    Neg(x) => {
      let (pos, typ) = find(ctx, x); // Int
      guard(typ == Int) else { @util.die("Asm error: Neg arg must be Int.") }
      [
          Lw(A0, {base: S4, offset: pos}), // 获得值
          Neg(A0, A0),
      ]
    }
    FNeg(x) => {
      let (pos, typ) = find(ctx, x); // Double
      guard(typ == Double) else { @util.die("Asm error: FNeg arg must be Double.") }
      [
          Fld(Fa0, {base: S4, offset: pos}), // 获得值
          FnegD(Fa0, Fa0),
      ]
    }
    
    MakeTuple(xs) => {
      let asm: AsmList = [
        Comment("MakeTuple \{expr}"),
        Mv(S1, S3), // 存起始地址
        Li(S2, "8"), // 用于计算长度
        Addi(S3, S3, 8) // 预留存放长度的地址
      ]
      for x in xs {
        let (x_pos, x_typ) = find(ctx, x)
        match x_typ {
          Unit | Bool | Int | Double => {
            asm.appendx([Addi(S2, S2, 8)])
          }
          Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
            asm.appendx([
              Lw(T0, {base: S4, offset: x_pos}),
              Lw(T1, {base: T0, offset: 0}),
              Add(S2, S2, T1)
            ])
          }
          _ => @util.die("Asm error: MakeTuple not implemented.")
        }
        asm.appendx(data_copy(x_pos, x_typ, internal = true))
      }
      
      asm + [Sw(S2, {base: S1, offset: 0}), Mv(A0, S1), Comment("MakeTuple End \{expr}"),]
    }
    
    MakeArray(x, y) => {
      let (x_pos, x_typ) = find(ctx, x) // length
      let (y_pos, y_typ) = find(ctx, y) // element
      guard(x_typ == Int) else { @util.die("Asm error: MakeArray length must be Int.") }
      let asm: AsmList = [
        Comment("MakeArray \{expr}"),
        Mv(S1, S3), // 存起始地址
        Addi(S3, S3, 8), // 预留存放长度的地址
      ]
      
      match y_typ {
        Unit | Bool | Int | Double => {
          asm.appendx( [Li(T1, "8")] )
        }
        Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
          asm.appendx([
            Lw(T0, {base: S4, offset: y_pos}),
            Lw(T1, {base: T0, offset: 0}),
          ])
        }
        _ => @util.die("Asm error: MakeArray not implemented.")
      }
      
      label_counter.val += 1
      let label_counter_backup = label_counter.val
      asm.appendx([
        Lw(S2, {base: S4, offset: x_pos}), // 加载元素个数
        Mul(T1, T1, S2), // 计算总长度
        Addi(T1, T1, 8), // 加上长度字段的长度
        Sw(T1, {base: S1, offset: 0}),
        
        Label("make_array_loop_\{label_counter_backup}"),
      ])
      
      asm.appendx(data_copy(y_pos, y_typ, internal = true))
      asm.appendx([
        Addi(S2, S2, -1),
        Beq(S2, Zero, "make_array_end_\{label_counter_backup}"), // 如果长度为 0，跳出循环
        J("make_array_loop_\{label_counter_backup}"),
        Label("make_array_end_\{label_counter_backup}"),
      ])
      
      asm + [Mv(A0, S1), Comment("MakeArray End \{expr}"),]
    }
    
    Add(x, y) | Sub(x, y) | Mul(x, y) | Div(x, y) => {
      let (x_pos, x_typ) = find(ctx, x)
      let (y_pos, y_typ) = find(ctx, y)
      guard(x_typ == Int && y_typ == Int) else { @util.die("Asm error: Add args must be Int.") }
      
      let load_asm = [
        Lw(T0, {base: S4, offset: x_pos}),
        Lw(T1, {base: S4, offset: y_pos}),
      ]
      let op_asm = match expr {
        Add(_, _) => [ Add(A0, T0, T1) ]
        Sub(_, _) => [ Sub(A0, T0, T1) ]
        Mul(_, _) => [ Mul(A0, T0, T1) ]
        Div(_, _) => [ Div(A0, T0, T1) ]
      }
      load_asm + op_asm
    }
    
    FAdd(x, y) | FSub(x, y) | FMul(x, y) | FDiv(x, y) => {
      let (x_pos, x_typ) = find(ctx, x)
      let (y_pos, y_typ) = find(ctx, y)
      guard(x_typ == Double && y_typ == Double) else { @util.die("Asm error: FAdd args must be Double.") }
      
      let load_asm = [
        Fld(Ft0, {base: S4, offset: x_pos}),
        Fld(Ft1, {base: S4, offset: y_pos}),
      ]
      let op_asm = match expr {
        FAdd(_, _) => [ FaddD(Fa0, Ft0, Ft1) ]
        FSub(_, _) => [ FsubD(Fa0, Ft0, Ft1) ]
        FMul(_, _) => [ FmulD(Fa0, Ft0, Ft1) ]
        FDiv(_, _) => [ FdivD(Fa0, Ft0, Ft1) ]
      }
      load_asm + op_asm
    }
    
    IfEq(x, y, then, els) => {
        let (x_pos, x_typ) = find(ctx, x);
        let (y_pos, y_typ) = find(ctx, y);
        
        label_counter.val += 1
        let label_counter_backup = label_counter.val
        
        let asm: AsmList = [
            Lw(T0, {base: S4, offset: x_pos}),
            Lw(T1, {base: S4, offset: y_pos}),
            Beq(T0, T1, "ifeq_then_\{label_counter_backup}"),
        ]
        let global_offset_backup = global_offset.val
        asm.appendx(closure_to_riscv(env, ctx, els))
        asm.appendx( [J("ifeq_end_\{label_counter_backup}")] )
        
        global_offset.val = global_offset_backup
        asm.appendx( [Label("ifeq_then_\{label_counter_backup}")] )
        asm.appendx(closure_to_riscv(env, ctx, then))
        
        asm.appendx( [Label("ifeq_end_\{label_counter_backup}")] )
        asm
    }
    
    IfLe(x, y, then, els) => {
        let (x_pos, x_typ) = find(ctx, x);
        let (y_pos, y_typ) = find(ctx, y);
        
        label_counter.val += 1
        let label_counter_backup = label_counter.val
        
        guard(x_typ == Int && y_typ == Int) else { @util.die("Asm error: Ifle args must be Int.") }
        let asm: AsmList = [
            Lw(T0, {base: S4, offset: x_pos}),
            Lw(T1, {base: S4, offset: y_pos}),
            Ble(T0, T1, "ifle_then_\{label_counter_backup}"),
        ]
        let global_offset_backup = global_offset.val
        asm.appendx(closure_to_riscv(env, ctx, els))
        asm.appendx( [J("ifle_end_\{label_counter_backup}")] )
        
        global_offset.val = global_offset_backup
        asm.appendx( [Label("ifle_then_\{label_counter_backup}")] )
        asm.appendx(closure_to_riscv(env, ctx, then))
        
        asm.appendx( [Label("ifle_end_\{label_counter_backup}")] )
        
        asm
    }
    
    Let((x, ty), expr, rest) => {
      let asm = closure_to_riscv(env, ctx, expr)
      
      if x.name != None {
        match ty {
          Unit | Bool | Int => {
            asm.appendx( [ Sw(A0, {base: S4, offset: global_offset.val}) ])
          }
          Double => {
            asm.appendx( [ Fsd(Fa0, {base: S4, offset: global_offset.val}) ])
          }
          Tuple(_) | Array(_) | Closure(_) | ClosureFn(_)=> {
            asm.appendx( [ Sw(S3, {base: S4, offset: global_offset.val} ) ])
            asm.appendx(data_copy_reg(A0, ty, internal = true))
          }
          _ => @util.die("Asm error: Let not implemented 1.")
        }
      }
      else {
        match ty {
          Unit | Bool | Int | Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
            asm.appendx( [ Sw(A0, {base: S4, offset: global_offset.val}) ])
          }
          Double => {
            asm.appendx( [ Fsd(Fa0, {base: S4, offset: global_offset.val}) ])
          }
          _ => @util.die("Asm error: Let not implemented 2.")
        }
      }
      
      let new_ctx = ctx.add(x, (global_offset.val, ty))
      global_offset.val -= 8
      
      asm + closure_to_riscv(env, new_ctx, rest)
    }
    LetTuple(xts, expr, rest) => {
      let asm = AsmList([Comment("LetTuple \{expr}")]) + closure_to_riscv(env, ctx, expr)
      let mut new_ctx = ctx
      
      asm.appendx([
        Mv(S1, A0), // 加载元组地址
        Addi(S1, S1, 8),
      ])
      for xt in xts {
        let (x, ty) = xt
        new_ctx = new_ctx.add(x, (global_offset.val, ty))
        asm.appendx( data_copy_reg(S1, ty, internal = false) )
      }
      
      asm + closure_to_riscv(env, new_ctx, rest)
    }
    
    ArrayGet(x, y) => {
      let (x_pos, x_typ) = find(ctx, x)
      let (y_pos, y_typ) = find(ctx, y)
      guard(y_typ == Int) else { @util.die("Asm error: Get arg must be Int.") }
      
      let asm: AsmList = [
        Comment("ArrayGet \{expr}"),
        
        Lw(T0, {base: S4, offset: x_pos}), // 加载地址
        Lw(T1, {base: S4, offset: y_pos}), // 加载索引
      ]
      
      let x_typ_unwrap = match x_typ {
        Array(typ) => typ
        _ => @util.die("Asm error: ArrayGet not implemented.")
      }
      
      match x_typ_unwrap {
        Unit | Bool | Int | Double => {
          asm.appendx( [Li(T2, "8")] )
        }
        Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
          asm.appendx([
            Lw(T3, {base: S4, offset: x_pos}),
            Lw(T2, {base: T3, offset: 8}),
          ])
        }
        _ => @util.die("Asm error: ArrayGet not implemented.")
      }
      
      asm.appendx([
        Addi(T0, T0, 8),
        Mul(T3, T1, T2), // 计算偏移
        Add(S1, T0, T3), // 计算偏移后的地址
      ])
      
      match x_typ_unwrap {
        Unit | Bool | Int => asm.appendx( [ Lw(A0, {base: S1, offset: 0}) ] )
        Double => asm.appendx( [ Fld(Fa0, {base: S1, offset: 0}) ] )
        Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => { asm.appendx( [ Mv(A0, S1) ] ) }
        _ => @util.die("Asm error: ArrayGet not implemented.")
      }
      
      asm + [Comment("ArrayGet End \{expr}"),]
    }
    
    ArrayPut(x, y, z, rest) => {
      let (x_pos, x_typ) = find(ctx, x)
      let (y_pos, y_typ) = find(ctx, y)
      let (z_pos, z_typ) = find(ctx, z)
      guard(y_typ == Int) else { @util.die("Asm error: Put arg must be Int.") }
      
      let asm: AsmList = [
        Comment("ArrayPut \{expr}"),
        
        Lw(T0, {base: S4, offset: x_pos}), // 加载地址
        Lw(T1, {base: S4, offset: y_pos}), // 加载索引
      ]
      
      let x_typ_unwrap = match x_typ {
        Array(typ) => typ
        _ => @util.die("Asm error: ArrayPut not implemented.")
      }
      
      match x_typ_unwrap {
        Unit | Bool | Int | Double => {
          asm.appendx( [Li(T2, "8")] )
        }
        Tuple(_) | Array(_) | Closure(_)=> {
          asm.appendx([
            Lw(T3, {base: S4, offset: x_pos}),
            Lw(T2, {base: T3, offset: 8}),
          ])
        }
        _ => @util.die("Asm error: MakeArray not implemented.")
      }
      
      asm.appendx([
        Addi(T0, T0, 8),
        Mul(T3, T1, T2), // 计算偏移
        Add(S1, T0, T3), // 计算偏移后的地址
      ])
      asm.appendx(data_modify(z_pos, z_typ, S1))
      
      asm.appendx( [Comment("ArrayPut end \{expr}")] )
      asm + closure_to_riscv(env, ctx, rest)
    }
    
    MakeClosure((name, _), c, rest) => {
      let fun = env.functions.get(name.to_string()).unwrap()
      let asm: AsmList = [
        Comment("MakeClosure \{name}"),
        Mv(S1, S3), // 存起始地址
        Addi(S3, S3, 16), // 预留存放长度和指针的地址
        
        La(T0, name.to_string()),
        Sw(T0, {base: S3, offset: -8}), // 存函数指针
        Li(S2, "16"),
      ]
      for fv in fun.formal_free_vars {
        let (pos, typ) = find(ctx, fv.0)
        
        match typ {
          Unit | Bool | Int | Double => {
            asm.appendx([Addi(S2, S2, 8)])
          }
          Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
            asm.appendx([
              Lw(T0, {base: S4, offset: pos}),
              Lw(T1, {base: T0, offset: 0}),
              Add(S2, S2, T1)
            ])
          }
          _ => @util.die("Asm error: MakeClosure not implemented.")
        }
        
        asm.appendx(data_copy(pos, typ, internal = true))
      }
      asm.appendx([
        Sw(S2, {base: S1, offset: 0}), // 将计算出的长度放入内存
        Sw(S1, {base: S4, offset: global_offset.val})
      ])
      let new_ctx = ctx.add(name, (global_offset.val, Closure(fun.formal_free_vars)))
      global_offset.val -= 8
      
      asm.appendx([Comment("MakeClosure End \{name}")])
      asm + closure_to_riscv(env, new_ctx, rest)
    }
    
    CallClosure(name, args) => {
      let asm: AsmList = [
        Comment("CallClosure \{name} \{args}"),
      ]
      let global_offset_backup = global_offset.val
      
      global_offset.val -= 8 // 预留 ra 的位置
      
      for arg in args {
        let (pos, typ) = find(ctx, arg)
        match typ {
          Unit | Bool | Int | Double => ()
          Tuple(_) | Array(_) | Closure(_) | ClosureFn(_) => {
            asm.appendx([
              Lw(T0, {base: S4, offset: pos}),
              Sw(T0, {base: S4, offset: global_offset.val}),
            ])
            global_offset.val -= 8
          }
          _ => @util.die("Asm error: CallClosure not implemented.")
        }
        asm.appendx(data_copy(pos, typ, internal = false))
      }
      
      // 不需要知道自由变量，因为在创建闭包时已经写入了内存
      // 直接把整个闭包复制到栈上
      
      let (pos, _) = find(ctx, name)
      
      asm.appendx([
        Lw(T0, {base: S4, offset: pos}), // 加载闭包地址
        Lw(S1, {base: T0, offset: 8}), // 闭包记录的函数指针
        Sw(T0, {base: S4, offset: global_offset.val}), // 复制闭包到栈上
          
        Addi(S4, S4, global_offset_backup), // 栈指针省略
        Jalr(Ra, {base: S1, offset: 0}),
        Addi(S4, S4, -global_offset_backup),
      ])
      global_offset.val = global_offset_backup
      
      asm.appendx([Comment("CallClosure End \{name} \{args}")])
      asm
    }
    CallDirect(name, args) => {
      let asm: AsmList = [Comment("Ecall \{name} \{args}")]
      if args.length() > 0 {
        let arg = args[0]
        let (pos, typ) = find(ctx, arg)
        match typ {
          Int => asm.appendx([Lw(A0, {base: S4, offset: pos})])
          Double => asm.appendx([Fld(Fa0, {base: S4, offset: pos})])
          _ => @util.die("Asm error: CallDirect not implemented.")
        }
      }
      asm + [Call(name._.to_string())]
      // match name._ {
      //   "minimbt_print_int" => asm + [Li(A7, "1"), Ecall]
      //   "minimbt_print_endline" => asm + [Li(A7, "11"), Li(A0, "10"), Ecall]
      //   _ => @util.die("Asm error: CallDirect not implemented.")
      // }
    }
    
  }
}