// 由于数组长度是可变的，Tuple 和 Array 数据需要手动管理内存；其它类型数据直接存在栈上。
// Tuple 在栈上存一个指针；Array 在栈上存一个指针和一个指向长度的指针。
// 调用栈头指针为 fp，向下增长。数据区是另一个栈（然而并不会退栈），头指针为 sp，向上增长
// 在定义变量时 fp 不会增长，而会让 global_offset 增长；在函数调用时一次性令 fp -= global_offset，然后 global_offset = 0 （似乎叫栈指针省略）
// 在加入数据时 sp 会增长。fp(+global_offset) 会在对应变量处记录数据地址

typealias LocalEnv = @immut/hashmap.T[Name, (Int, LowType)] // 存的是指针在栈帧内的位置（fp+offset）与类型 

struct InterpreterEnv {
  extern_fns : Map[String, (Array[LowType]) -> LowType]
  functions : Map[String, @closure.FuncDef]
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
    None => @util.die("variable not found: \{name}")
    Some(v) => v
  }
}

////////////////////////////////////////////////////
let global_offset: Ref[Int] = {val: 0}

fn memory_mv(x: Int, y: Int) -> Array[RvAsm] {
  [Ld(T0, {base: Zero, offset: y}),
   Sd(T0, {base: Zero, offset: x})]
}
fn memory_addi(x: Int, y: Int, z: Int) -> Array[RvAsm] {
  [Lw(T0, {base: Zero, offset: y}),
   Addi(T0, T0, z),
   Sw(T0, {base: Zero, offset: x})]
}

/////////////////////////////////////////////////////

let const_double: Array[Double] = []
pub fn emit(
  input : Program
) -> Array[AssemblyFunction] {
  const_double.clear()
  let env = InterpreterEnv::new()
  //@TODO: 将外部函数放入 env
  
  for f in input.fundefs {
    env.functions.set(f.name._, f)
  }
  
  // 初始化 sp 和 fp，sp = fp + 1
  let init = [
    Li(Fp, "0x0ffff"),
    Li(Sp, "0x10000"),
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
      match arg.1 {
        Unit | Bool | Int | Double | Tuple(_) => {
          ctx = ctx.add(arg.0, (global_offset.val, arg.1))
          global_offset.val += 1
        }
        Array(_) => {
          ctx = ctx.add(arg.0, (global_offset.val, arg.1))
          global_offset.val += 2
        }
        _ => @util.die("Asm error: arg not implemented.")
      }
    }
    
    function_asms.push(
      {name: f.name._, export: false, body: closure_to_riscv(env, ctx, f.body) })
  }
  
  global_offset.val = 0
  let body_asm = closure_to_riscv(env, LocalEnv::new(), input.body)
  function_asms.push(
    {name: "name", export: true, body: concat(init, body_asm) })
  
  let const_double_asm = []
  for i in 0..<const_double.length() {
    let x = const_double[i]
    const_double_asm.push(
      { name: "const_double_\{i}", export: false, body: [Text(".double \{x}")] }
    )
  }
  
  concat(const_double_asm, function_asms)
}

fn closure_to_riscv(
  env : InterpreterEnv,
  ctx : LocalEnv,
  expr : Expr
) -> Array[RvAsm] {
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
          Tuple(_) => [ Lw(A0, {base: Fp, offset: pos}) ]
          Array(_) => [
            Lw(A0, {base: Fp, offset: pos}),
            Lw(A1, {base: Fp, offset: pos+1}),
          ]
          _ => @util.die("Asm error: Var not implemented.")
        }
    }
    
    Not(x) => {
      let (pos, typ) = find(ctx, x); // Bool
      guard(typ == Bool) else { @util.die("Asm error: Not arg must be Bool.") }
      [
          Lw(T0, {base: Fp, offset: pos}), // 获得值
          Xori(T0, T0, 1),
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
    
    MakeArray(x, y) => {
      // let x_pos = find(ctx, x);
      // let y_pos = find(ctx, y);
      // [
      //     Lw(T0, {base: Fp, offset: addr1}),
      //     Lw(T1, {base: Fp, offset: addr2}),
      //     Sw(T0, {base: Sp, offset: 0}),
      //     Sw(T1, {base: Sp, offset: 4}),
      //     Mv(A0, Sp),
      //     Addi(Sp, Sp, 8)
      // ]
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
      concat(load_asm, op_asm)
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
      concat(load_asm, op_asm)
    }
    
    IfEq(Name1, Name2, Knf1, Knf2) => {
        let addr1 = find(ctx, Name1);
        let addr2 = find(ctx, Name2);
        [
            Lw(T0, {base: Fp, offset: addr1}),
            Lw(T1, {base: Fp, offset: addr2}),
            Beq(T0, T1, Knf1),
            J Knf2
        ]
    }
    
    IfLe(Name1, Name2, Knf1, Knf2) => {
        let addr1 = find(ctx, Name1);
        let addr2 = find(ctx, Name2);
        [
            Lw(T0, {base: Fp, offset: addr1}),
            Lw(T1, {base: Fp, offset: addr2}),
            Ble(T0, T1, Knf1),
            J Knf2
        ]
    }
    
    Let((var_name, var_type), expr, body) => {
      // 1. 生成表达式的汇编指令
      let expr_asm = closure_to_riscv(env, ctx, expr); 
      
      // 2. 获取栈上分配空间的偏移量
      let var_offset = global_offset.val; 
      
      // 3. 获取变量类型的字节大小
      let type_size = get_type_size(var_type); 
      
      // 4. 更新栈的偏移量
      global_offset.val += type_size; 
      
      // 5. 更新上下文，记录新变量的位置
      let new_ctx = ctx.add(var_name, var_offset);  
      
      // 6. 生成 body 的汇编代码
      let body_asm = closure_to_riscv(env, new_ctx, body); 
      
      // 7. 连接 expr 和 body 的汇编代码
      concat(expr_asm, body_asm)
    }
    
    Get(tuple_name, element_name) => {
      let tuple_offset = find(ctx, tuple_name) 
      let element_offset = find(ctx, element_name) 
      [
        Lw(T0, {base: Fp, offset: tuple_offset + element_offset})
      ]
    }
    
    
    Put(tuple_name, element_name, value_name, Knf) => {
      let knf_asm = closure_to_riscv(env, ctx, Knf); 
      let tuple_offset = find(ctx, tuple_name) 
      let element_offset = find(ctx, element_name) 
      let value_offset = find(ctx, value_name) 
      let value_asm = [
        Lw(T0, {base: Fp, offset: value_offset}) 
      ];
      concat(knf_asm, value_asm) // 先执行 Knf 计算，然后执行存储操作
      concat(knf_asm, [
        Sw(T0, {base: Fp, offset: tuple_offset + element_offset})  // 将值存储到元组中的指定位置
      ])
    }
    
    Tuple(Array[Name]) => {
      // 计算元组总大小（假设每个元素占4字节）
      let tuple_size = get_type_size(Name) * Array[Name].length();
      // 调整栈指针，为元组开辟空间
      Addi(Sp, Sp, -tuple_size);
      let offset = 0;
      for name in Array[Name] {
          let element_addr = find(ctx, name);
          Lw(T0, {base: Fp, offset: element_addr});
          Sw(T0, {base: Sp, offset: offset});
          offset = offset + get_type_size(Name);
      }
      Mv(A0, Sp);
      // 可根据需要添加其他操作，比如返回元组的地址等
    }
    
    LetRec(func_def, body) => {
      let func_offset = global_offset.val  // 获取当前栈偏移量
      global_offset.val += func_def_size(func_def)  // 计算并更新栈偏移
      let new_ctx = ctx.add(func_def.name, func_offset)  // 更新上下文
      let body_asm = closure_to_riscv(env, new_ctx, body) // 生成函数体汇编代码
      body_asm  // 返回函数体的汇编代码
    }
    
    Apply(func_name, args) => {
      let func_offset = find(ctx, func_name)  // 获取函数在栈中的偏移
      let mut arg_asm = []
      for (i, arg) in args {
        let arg_offset = find(ctx, arg)
        arg_asm.push(Lw(T0, {base: Fp, offset: arg_offset}))  // 加载参数到寄存器
      }
      arg_asm.push(Jal(func_name))  // 跳转并链接（调用函数）
    }
    LetTuple(elements, tuple_name, body) => {
      let mut asm =[]
      let mut total_size = 0
      for (var_name, var_type) in elements {
        total_size += get_type_size(var_type) 
      }
      global_offset.val += total_size;
      let new_ctx = ctx.add(tuple_name, global_offset.val)

      for (i, (var_name, var_type)) in elements {
        let var_offset = global_offset.val + i * get_type_size(var_type)  // 计算元素的栈偏移
        asm.push(Lw(T0, {base: Fp, offset: find(ctx, var_name)}))  // 加载元素
        asm.push(Sw(T0, {base: Fp, offset: var_offset}));  // 存储到栈上
      }
      let body_asm = closure_to_riscv(env, new_ctx, body)
      concat(asm, body_asm)  // 合并元组元素的汇编指令和函数体汇编指令
    }
    
  }
}