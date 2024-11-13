// 由于数组长度是可变的，Tuple 和 Array 数据需要手动管理内存；其它类型数据直接存在栈上。
// Tuple 格式： size, [data1], [data2], ...
// Array 格式： size, [data1], [data2], ...
// Closure 格式： size, fv1, fv2, ...
// 调用栈头指针为 fp，向下增长。数据区是另一个栈（然而并不会退栈），头指针为 sp，向上增长
// 在定义变量时 fp 不会增长，而会让 global_offset 增长（实际上是减小）；在函数调用时一次性令 fp += global_offset，然后 global_offset = 0 （似乎叫栈指针省略）
// 在加入数据时 sp 会增长。fp(+global_offset) 会在对应变量处记录数据地址

typealias LocalEnv = @immut/hashmap.T[Name, (Int, LowType)] // 存的是指针在栈帧内的位置（fp+offset）与类型 

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
          Lw(T0, {base: Fp, offset: pos}), 
          Sw(T0, {base: Sp, offset: 0}),
          Addi(Sp, Sp, 8)
        ]
      }
      else {
        global_offset.val -= 8
        [
          Lw(T0, {base: Fp, offset: pos}), 
          Sw(T0, {base: Fp, offset: global_offset.val+8})
        ]
      }
    }
    Double => {
      if internal {
        [
          Fld(Ft0, {base: Fp, offset: pos}), 
          Fsd(Ft0, {base: Sp, offset: 0}),
          Addi(Sp, Sp, 8)
        ]
      }
      else {
        global_offset.val -= 8
        [
          Fld(Ft0, {base: Fp, offset: pos}), 
          Fsd(Ft0, {base: Fp, offset: global_offset.val+8})
        ]
      }
    }
    Tuple(_) | Array(_) | Closure(_)=> {
      [
        Lw(T0, {base: Fp, offset: pos}), // 加载地址
        Lw(T1, {base: T0, offset: 0}), // 加载数据长度
        
        Addi(T0, T0, 8),
        Addi(Sp, Sp, 8),
        Lw(T2, {base: T0, offset: 0}),
        Sw(T2, {base: Sp, offset: 0}),
        Addi(T1, T1, -8),
        Bne(T1, Zero, -20),
        
        Addi(Sp, Sp, 8)
      ]
    }
    _ => @util.die("Asm error: data_copy not implemented.")
  }
}

fn data_copy_reg(reg: Reg, ty: LowType, ~internal: Bool) -> AsmList {
  match ty {
    Unit | Bool | Int => {
      if internal {
        [
          Lw(T0, {base: reg, offset: 0}), 
          Sw(T0, {base: Sp, offset: 0}),
          Addi(Sp, Sp, 8),
          Addi(reg, reg, 8),
        ]
      }
      else {
        global_offset.val -= 8
        [
          Lw(T0, {base: reg, offset: 0}), 
          Sw(T0, {base: Fp, offset: global_offset.val+8}),
          Addi(reg, reg, 8),
        ]
      }
    }
    Double => {
      if internal {
        [
          Fld(Ft0, {base: reg, offset: 0}), 
          Fsd(Ft0, {base: Sp, offset: 0}),
          Addi(Sp, Sp, 8),
          Addi(reg, reg, 8),
        ]
      }
      else {
        global_offset.val -= 8
        [
          Fld(Ft0, {base: reg, offset: 0}), 
          Fsd(Ft0, {base: Fp, offset: global_offset.val+8}),
          Addi(reg, reg, 8),
        ]
      }
    }
    Tuple(_) | Array(_) | Closure(_)=> {
      [
        Lw(T0, {base: reg, offset: 0}), // 加载地址
        Lw(T1, {base: T0, offset: 0}), // 加载数据长度
        
        Addi(T0, T0, 8),
        Addi(Sp, Sp, 8),
        Addi(reg, reg, 8),
        Lw(T2, {base: T0, offset: 0}),
        Sw(T2, {base: Sp, offset: 0}),
        Addi(T1, T1, -8),
        Bne(T1, Zero, -20),
        
        Addi(Sp, Sp, 8),
        Addi(reg, reg, 8),
      ]
    }
    _ => @util.die("Asm error: data_copy not implemented.")
  }
}

fn data_modify(pos: Int, ty: LowType, reg: Reg) -> AsmList {
  match ty {
    Unit | Bool | Int => {
      [
        Lw(T0, {base: Fp, offset: pos}),
        Sw(T0, {base: reg, offset: 0}),
      ]
    }
    Double => {
      [
        Fld(Ft0, {base: Fp, offset: pos}),
        Fsd(Ft0, {base: reg, offset: 0}),
      ]
    }
    Tuple(_) | Array(_) | Closure(_)=> {
      [
        Lw(T0, {base: Fp, offset: pos}), // 加载地址
        Lw(T1, {base: T0, offset: 0}), // 加载数据长度
        
        Addi(T0, T0, 8),
        Addi(reg, reg, 8),
        Lw(T2, {base: T0, offset: 0}),
        Sw(T2, {base: reg, offset: 0}),
        Addi(T1, T1, -8),
        Bne(T1, Zero, -20),
        
      ]
    }
    _ => @util.die("Asm error: data_copy not implemented.")
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
  
  // 初始化 sp 和 fp，sp = fp + 1
  let init: AsmList = [
    Li(Fp, "0x0ffffff8"),
    Li(Sp, "0x10000000"),
  ]
  
  let function_asms = []
  for f in input.fundefs {
    // 这里是所有闭包的定义
    // 需要为所有参数和自由变量预留接口(内存地址)
    // 在程序中创建闭包时，将自由变量的值写入内存
    // 在调用闭包时，提取自由变量的值，然后和参数一起写入内存并调用
    // 栈顶往上的（参数+自由变量）个数 位置存（参数+自由变量）的地址
    // 执行完成后 a0 是 返回值 的地址
    global_offset.val = 0
    let mut ctx: LocalEnv = LocalEnv::new()
    for arg in concat(f.args, f.formal_free_vars) {
      ctx = ctx.add(arg.0, (global_offset.val, arg.1))
      global_offset.val += 1
    }
    
    function_asms.push(
      {name: f.name._, export: false, body: closure_to_riscv(f.name._, env, ctx, f.body) + [Jr(Ra)] })
  }
  
  global_offset.val = 0
  let body_asm = closure_to_riscv("_minimbt_main_", env, LocalEnv::new(), input.body)
  function_asms.push(
    {name: "minimbt_main", export: true, body: init+body_asm })
  
  let const_double_asm = []
  for i in 0..<const_double.length() {
    let x = const_double[i]
    const_double_asm.push(
      { name: "const_double_\{i}", export: false, body: [Text(".double \{x}")] }
    )
  }
  
  const_double_asm + function_asms
}

fn closure_to_riscv(
  func_name : String,
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
          Unit | Bool | Int => [ Lw(A0, {base: Fp, offset: pos}) ]
          Double => [ Fld(Fa0, {base: Fp, offset: pos}) ]
          Tuple(_) | Array(_) | Closure(_) => [ Lw(A0, {base: Fp, offset: pos}) ]
          _ => @util.die("Asm error: Var not implemented.")
        }
    }
    
    Not(x) => {
      let (pos, typ) = find(ctx, x); // Bool
      guard(typ == Bool) else { @util.die("Asm error: Not arg must be Bool.") }
      [
          Lw(A0, {base: Fp, offset: pos}), // 获得值
          Xori(A0, A0, 1),
      ]
    }
    Neg(x) => {
      let (pos, typ) = find(ctx, x); // Int
      guard(typ == Int) else { @util.die("Asm error: Neg arg must be Int.") }
      [
          Lw(A0, {base: Fp, offset: pos}), // 获得值
          Neg(A0, A0),
      ]
    }
    FNeg(x) => {
      let (pos, typ) = find(ctx, x); // Double
      guard(typ == Double) else { @util.die("Asm error: FNeg arg must be Double.") }
      [
          Fld(Fa0, {base: Fp, offset: pos}), // 获得值
          FnegD(Fa0, Fa0),
      ]
    }
    
    MakeTuple(xs) => {
      let asm: AsmList = [
        Comment("MakeTuple \{expr}"),
        Mv(S1, Sp), // 存起始地址
        Li(S2, "8"), // 用于计算长度
        Addi(Sp, Sp, 8) // 预留存放长度的地址
      ]
      for x in xs {
        let (x_pos, x_typ) = find(ctx, x)
        match x_typ {
          Unit | Bool | Int | Double => {
            asm.appendx([Addi(S2, S2, 8)])
          }
          Tuple(_) | Array(_) | Closure(_) => {
            asm.appendx([
              Lw(T0, {base: Fp, offset: x_pos}),
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
        Mv(S1, Sp), // 存起始地址
        Addi(Sp, Sp, 8), // 预留存放长度的地址
      ]
      
      println("? \{y} \{y_typ}")
      match y_typ {
        Unit | Bool | Int | Double => {
          asm.appendx( [Li(T1, "8")] )
        }
        Tuple(_) | Array(_) | Closure(_)=> {
          asm.appendx([
            Lw(T0, {base: Fp, offset: y_pos}),
            Lw(T1, {base: T0, offset: 0}),
          ])
        }
        _ => @util.die("Asm error: MakeArray not implemented.")
      }
      
      asm.appendx([
        Lw(S2, {base: Fp, offset: x_pos}), // 加载元素个数
        Mul(T1, T1, S2), // 计算总长度
        Addi(T1, T1, 8), // 加上长度字段的长度
        Sw(T1, {base: S1, offset: 0}),
        
        Label("make_array_loop_\{label_counter.val}"),
      ])
      
      asm.appendx(data_copy(y_pos, y_typ, internal = true))
      asm.appendx([
        Addi(S2, S2, -1),
        Beq(S2, Zero, 8), // 如果长度为 0，跳出循环
        J("make_array_loop_\{label_counter.val}"),
      ])
      label_counter.val += 1
      
      asm + [Mv(A0, S1), Comment("MakeArray End \{expr}"),]
    }
    
    Add(x, y) | Sub(x, y) | Mul(x, y) | Div(x, y) => {
      let (x_pos, x_typ) = find(ctx, x)
      let (y_pos, y_typ) = find(ctx, y)
      guard(x_typ == Int && y_typ == Int) else { @util.die("Asm error: Add args must be Int.") }
      
      let load_asm = [
        Lw(T0, {base: Fp, offset: x_pos}),
        Lw(T1, {base: Fp, offset: y_pos}),
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
        Fld(Ft0, {base: Fp, offset: x_pos}),
        Fld(Ft1, {base: Fp, offset: y_pos}),
      ]
      let op_asm = match expr {
        FAdd(_, _) => [ FaddD(Fa0, Ft0, Ft1) ]
        FSub(_, _) => [ FaddD(Fa0, Ft0, Ft1) ]
        FMul(_, _) => [ FaddD(Fa0, Ft0, Ft1) ]
        FDiv(_, _) => [ FaddD(Fa0, Ft0, Ft1) ]
      }
      load_asm + op_asm
    }
    
    IfEq(x, y, then, els) => {
        let (x_pos, x_typ) = find(ctx, x);
        let (y_pos, y_typ) = find(ctx, y);
        
        let asm: AsmList = [
            Lw(T0, {base: Fp, offset: x_pos}),
            Lw(T1, {base: Fp, offset: y_pos}),
            Beq(T0, T1, 8),
            J("ifeq_else_\{label_counter.val}"),
        ]
        asm.appendx(closure_to_riscv(func_name, env, ctx, then))
        asm.appendx( [J("ifeq_end_\{label_counter.val}")] )
        
        asm.appendx( [Label("ifeq_else_\{label_counter.val}")] )
        asm.appendx(closure_to_riscv(func_name, env, ctx, els))
        
        asm.appendx( [Label("ifeq_end_\{label_counter.val}")] )
        
        label_counter.val += 1
        asm
    }
    
    IfLe(x, y, then, els) => {
        let (x_pos, x_typ) = find(ctx, x);
        let (y_pos, y_typ) = find(ctx, y);
        guard(x_typ == Int && y_typ == Int) else { @util.die("Asm error: Ifeq args must be Int.") }
        let asm: AsmList = [
            Lw(T0, {base: Fp, offset: x_pos}),
            Lw(T1, {base: Fp, offset: y_pos}),
            Ble(T0, T1, 8),
            J("ifeq_else_\{label_counter.val}"),
        ]
        asm.appendx(closure_to_riscv(func_name, env, ctx, then))
        asm.appendx( [J("ifeq_end_\{label_counter.val}")] )
        
        asm.appendx( [Label("ifeq_else_\{label_counter.val}")] )
        asm.appendx(closure_to_riscv(func_name, env, ctx, els))
        
        asm.appendx( [Label("ifeq_end_\{label_counter.val}")] )
        
        label_counter.val += 1
        asm
    }
    
    Let((x, ty), expr, rest) => {
      let asm = closure_to_riscv(func_name, env, ctx, expr)
      asm.appendx( [Sw(A0, {base: Fp, offset: global_offset.val})] )
      let new_ctx = ctx.add(x, (global_offset.val, ty))
      global_offset.val -= 8
      
      asm + closure_to_riscv(func_name, env, new_ctx, rest)
    }
    LetTuple(xts, expr, rest) => {
      let asm = AsmList([Comment("LetTuple \{expr}")]) + closure_to_riscv(func_name, env, ctx, expr)
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
      
      asm + closure_to_riscv(func_name, env, new_ctx, rest)
    }
    
    ArrayGet(x, y) => {
      let (x_pos, x_typ) = find(ctx, x)
      let (y_pos, y_typ) = find(ctx, y)
      guard(y_typ == Int) else { @util.die("Asm error: Get arg must be Int.") }
      
      let asm: AsmList = [
        Comment("ArrayGet \{expr}"),
        
        Lw(T0, {base: Fp, offset: x_pos}), // 加载地址
        Lw(T1, {base: Fp, offset: y_pos}), // 加载索引
      ]
      
      match y_typ {
        Unit | Bool | Int | Double => {
          asm.appendx( [Li(T2, "8")] )
        }
        Tuple(_) | Array(_) | Closure(_)=> {
          asm.appendx([
            Lw(T3, {base: Fp, offset: y_pos}),
            Lw(T2, {base: T3, offset: 0}),
          ])
        }
        _ => @util.die("Asm error: MakeArray not implemented.")
      }
      
      asm.appendx([
        Addi(T0, T0, 8),
        Mul(T3, T1, T2), // 计算偏移
        Add(T0, T0, T3), // 计算偏移后的地址
      ])
      
      match x_typ {
        Array(typ) => {
          match typ {
              Unit | Bool | Int => asm.appendx( [ Lw(A0, {base: T0, offset: 0}) ] )
              Double => asm.appendx( [ Fld(Fa0, {base: T0, offset: 0}) ] )
              Tuple(_) | Array(_) | Closure(_) => {
                asm.appendx( [ Mv(A0, Sp) ] )
                asm.appendx( data_copy_reg(T0, typ, internal = true) )
              }
              _ => @util.die("Asm error: ArrayGet not implemented.")
          }
        }
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
        Lw(T0, {base: Fp, offset: x_pos}), // 加载地址
        Lw(T1, {base: Fp, offset: y_pos}), // 加载索引
        
        Addi(T0, T0, 8),
        Lw(T2, {base: T0, offset: 0}), // 子元素长度
        Mul(T3, T1, T2), // 计算偏移
        
        Add(T0, T0, T3), // 计算偏移后的地址
      ]
      asm.appendx(data_modify(z_pos, z_typ, T0))
      
      asm + closure_to_riscv(func_name, env, ctx, rest)
    }
    
    
    MakeClosure((name, _), c, rest) => {
      let func = env.functions.get(name.to_string()).unwrap()
      let asm: AsmList = [
        Mv(S1, Sp), // 存起始地址
        Addi(Sp, Sp, 8), // 预留存放长度的地址
        
        Li(S2, "8"),
      ]
      for fv in func.formal_free_vars {
        let (pos, typ) = find(ctx, fv.0)
        
        match typ {
          Unit | Bool | Int | Double => {
            asm.appendx([Addi(S2, S2, 8)])
          }
          Tuple(_) | Array(_) | Closure(_) => {
            asm.appendx([
              Lw(T0, {base: Fp, offset: pos}),
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
        Sw(S1, {base: Fp, offset: global_offset.val})
      ])
      let new_ctx = ctx.add(name, (global_offset.val, Closure(func.formal_free_vars)))
      global_offset.val -= 8
      
      asm + closure_to_riscv(func_name, env, new_ctx, rest)
    }
    
    CallClosure(name, args) => {
      let asm: AsmList = [
        Mv(S1, Fp), // 存起始地址
        Addi(Fp, Fp, global_offset.val), // 栈指针省略
      ]
      for arg in args {
        let (pos, typ) = find(ctx, arg)
        asm.appendx(data_copy(pos, typ, internal = false))
      }
      
      let fvs = 
        if func_name == name.to_string() {
          // 如果是递归调用，直接自己的自由变量传入
          asm.appendx( [ Lw(S2, {base: S1, offset: 0}) ] )
          env.functions.get(name.to_string()).unwrap().formal_free_vars
        }
        else{
          // 否则，找到闭包并传入自由变量
          let (pos, typ) = find(ctx, name)
          asm.appendx( [ Lw(S2, {base: S1, offset: pos}) ] ) // 加载闭包地址
          
          match typ {
            Closure(fvs) => fvs
            _ => @util.die("Asm error: CallClosure not implemented.")
          }
        }
      
      asm.appendx( [ Addi(S2, S2, 8) ] ) // 第一位是长度
      for xt in fvs {
        let (_, ty) = xt
        asm.appendx( data_copy_reg(S2, ty, internal = false) )
      }
      
      asm.appendx([
        Call(name.to_string()),
        
        Addi(Fp, Fp, -global_offset.val), // 栈指针省略
      ])
      
      asm
    }
    CallDirect(name, args) => {
      let asm: AsmList = [Comment("Ecall \{name} \{args}")]
      if args.length() > 0 {
        let arg = args[0]
        let (pos, typ) = find(ctx, arg)
        match typ {
          Int => asm.appendx([Lw(A0, {base: Fp, offset: pos})])
          Double => asm.appendx([Fld(Fa0, {base: Fp, offset: pos})])
          _ => @util.die("Asm error: CallDirect not implemented.")
        }
      }
      // asm + [Call(name.to_string())]
      match name._ {
        "minimbt_print_int" => asm + [Li(A7, "1"), Ecall]
        "minimbt_print_endline" => asm + [Li(A7, "11"), Li(A0, "10"), Ecall]
        _ => @util.die("Asm error: CallDirect not implemented.")
      }
    }
    
  }
}