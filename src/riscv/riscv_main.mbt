// 由于数据长度是可变的，所以需要在 数据区 中存储。
// 调用栈头指针为 fp，向下增长。变量区是另一个栈（然而并不会退栈），头指针为 sp，向上增长
// 在定义变量时 fp 不会增长，而会让 global_offset 增长；在函数调用时一次性令 fp += global_offset，然后 global_offset = 0 （似乎叫栈指针省略）
// 在加入数据时 sp 会增长。fp 会在对应变量处记录数据地址

struct InterpreterEnv {
  extern_fns : Map[String, (Array[Value]) -> Value]
  functions : Map[String, @closure.FuncDef]
}

typealias InterpreterLocalVars = @immut/hashmap.T[Name, Int]

pub fn InterpreterEnv::new() -> InterpreterEnv {
  { extern_fns: Map::new(), functions: Map::new() }
}
pub fn InterpreterEnv::add_extern_fn(
  self : InterpreterEnv,
  name : String,
  f : (Array[Value]) -> Value
) -> Unit {
  self.extern_fns.set(name, f)
}

fn find(env : InterpreterLocalVars, name : Name) -> Int {
  let ret = env.find(name)
  match ret {
    None => @util.die("variable not found: \{name}")
    Some(v) => v
  }
}

////////////////////////////////////////////////////
let global_offset: Ref[Int] = {val: 0}

enum Value {
  Unit(Int)
  Int(Int)
  Double(Int)
  Tuple(Array[Value])
  Array(Int, Array[Value]) // 前面是长度
  // Closure(@closure.FuncDef, Array[Value])
} derive(Show)
// 由于数据长度是可变的，所以需要在 数据区 中存储。
// 调用栈头指针为 fp，向下增长。变量区是另一个栈（然而并不会退栈），头指针为 sp，向上增长
// 这里存的是 数据区 数据的地址

fn mv_memory(x: Int, y: Int) -> Array[RvAsm] {
  [Lw(T0, {base: Zero, offset: y}),
   Sw(T0, {base: Zero, offset: x})]
}
fn add_memoryi(x: Int, y: Int, z: Int) -> Array[RvAsm] {
  [Lw(T0, {base: Zero, offset: y}),
   Addi(T0, T0, z),
   Sw(T0, {base: Zero, offset: x})]
}

fn get_addr(val: Value) -> Int {
  match val {
    Unit(addr) | Int(addr) | Double(addr)=> addr
    Tuple(vs) | Array(vs) => get_addr(vs[0])
    _ => @util.die("Asm Error: get_addr not supported")
  }
}

/////////////////////////////////////////////////////

// 定义 Type 枚举，表示不同的类型
enum Type {
  Int,          // 整数类型
  Bool,         // 布尔类型
  Double,       // 双精度浮点类型
  Tuple([Type]), // 元组类型，包含多个元素
  Array(Type, Int), // 数组类型，包含元素类型和元素数量
  // 其他类型...
}

// 获取给定类型的字节大小
func get_type_size(typ: Type) -> Int {
  match typ {
    case Type.Int => 4      // 整数类型占 4 字节
    case Type.Bool => 4     // 布尔类型占 4 字节
    case Type.Double => 8   // 双精度浮点类型占 8 字节
    case Type.Tuple(elements) => {
      // 对于元组类型，递归计算每个元素的大小并求和
      var total_size = 0
      for element in elements {
        total_size += get_type_size(element)
      }
      total_size
    }
    case Type.Array(element_type, size) => {
      // 数组类型，计算数组的总字节大小
      get_type_size(element_type) * size
    }
    case _ => {
      // 对于其他不支持的类型，抛出错误
      panic("Unsupported type for size calculation")
    }
  }
}

fn concat(asm1: Array[Asm], asm2: Array[Asm]) -> Array[Asm] {
  let mut result = asm1
  result.append(asm2)
  result
}



pub fn emit(
  input : Program
) -> Array[AssemblyFunction] {
  offset.val = 0
  let env = InterpreterEnv::new()
  //@TODO: 将外部函数放入 env
  
  for f in input.fundefs {
    env.functions.set(f.name._, f)
  }
  
  // @TODO 初始化 sp 和 fp
  // sp = fp + 1
  let init = []
  
  let function_asms = []
  for f in input.fundefs {
    // 这里是所有闭包的定义
    // 需要为所有参数和自由变量预留接口(内存地址)
    // 在程序中创建闭包时，将自由变量的值写入内存
    // 在调用闭包时，提取自由变量的值，然后和参数一起写入内存并调用
    // 栈顶往上的（参数+自由变量）个数 位置存（参数+自由变量）的地址
    // 执行完成后 a0 是 返回值 的地址
    let mut ctx = LocalEnv::new()
    for arg in f.args {
      ctx = ctx.add(arg.0, global_offset.val)
      global_offset.val += 1
    }
    for fv in f.formal_free_vars {
      ctx = ctx.add(fv.0, global_offset.val)
      global_offset.val += 1
    }
    
    function_asms.push(
      {name: f.name._, export: true, body: closure_to_riscv(env, ctx, f.body) })
  }
  global_offset.val = 0
  function_asms.push(
    {name: "name", export: true, body: closure_to_riscv(env, LocalEnv::new(), input.body) })
  concat(init, function_asms)
}

fn closure_to_riscv(
  env : InterpreterEnv,
  ctx : LocalEnv,
  expr : Expr
) -> Array[RvAsm] {
  match expr {
    Unit => [Mv(A0, Zero)]
    Bool(true) => {
      [
        Li(T0, "1"),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 1)
      ]
    }
    Bool(false) => {
      [
        Li(T0, "0"),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 1)
      ]
    }
    
    Int(i) => {
      [
        let i = find(ctx, i)
        Lw(T0, {base: Fp, offset: i}),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 4)
      ]
    }
    

    Double(i) => {
      [
        let i = find(ctx, i)
        Ld(T0, {base: Fp, offset: i}),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 8)
      ]
    }

    Not(Name) => {
      let addr = find(ctx, Name);
      [
          Lw(T0, {base: Fp, offset: addr}),
          Xori(T0, T0, "1"),
          Sw(T0, {base: Sp, offset: 0}),
          Mv(A0, Sp),
          Addi(Sp, Sp, 1)
      ]
    }

    Array(Name1, Name2) => {
      let addr1 = find(ctx, Name1);
      let addr2 = find(ctx, Name2);
      [
          Lw(T0, {base: Fp, offset: addr1}),
          Lw(T1, {base: Fp, offset: addr2}),
          Sw(T0, {base: Sp, offset: 0}),
          Sw(T1, {base: Sp, offset: 4}),
          Mv(A0, Sp),
          Addi(Sp, Sp, 8)
      ]
    }

    Neg(Name) => {
        let addr = find(ctx, Name);
        [
            Lw(T0, {base: Fp, offset: addr}),
            Neg(T0, T0),
            Sw(T0, {base: Sp, offset: 0}),
            Mv(A0, Sp),
            Addi(Sp, Sp, 4)
        ]
    }
    
    Add(x, y) => {
      let x = find(ctx, x)
      let y = find(ctx, y)
      [
        Lw(T0, {base: Fp, offset: x}),
        Lw(T1, {base: Fp, offset: y}),
        Add(T0, T0, T1),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 4)
      ]
    }


    Sub(x, y) => {
      let x = find(ctx, x)
      let y = find(ctx, y)
      [
        Lw(T0, {base: Fp, offset: x}),
        Lw(T1, {base: Fp, offset: y}),
        Sub(T0, T0, T1),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 4)
      ]
    }

    Mul(Name, Name) => {
      let x = find(ctx, x)
      let y = find(ctx, y)
      [
        Lw(T0, {base: Fp, offset: x}),
        Lw(T1, {base: Fp, offset: y}),
        Mul(T0, T0, T1),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 4)
      ]
    }

    Div(Name, Name) => {
      let x = find(ctx, x)
      let y = find(ctx, y)
      [
        Lw(T0, {base: Fp, offset: x}),
        Lw(T1, {base: Fp, offset: y}),
        Div(T0, T0, T1),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 4)
      ]
    }

    FNeg(Name) => {
        let addr = find(ctx, Name);
        [
            Flw(Ft0, {base: Fp, offset: addr}),
            FNeg.d(Ft0, Ft0),  // 如果是双精度则为 FNeg.d
            Fsw(Ft0, {base: Sp, offset: 0}),
            Mv(A0, Sp),
            Addi(Sp, Sp, 8)  // 单精度浮点数占4字节，双精度则为8字节
        ]
    }

    FAdd(Name1, Name2) => {
        let addr1 = find(ctx, Name1);
        let addr2 = find(ctx, Name2);
        [
            Flw(Ft0, {base: Fp, offset: addr1}),
            Flw(Ft1, {base: Fp, offset: addr2}),
            FAdd.d(Ft0, Ft0, Ft1),  // 假设是单精度浮点加法，如果是双精度则用 FAdd.d
            Fsw(Ft0, {base: Sp, offset: 0}),
            Mv(A0, Sp),
            Addi(Sp, Sp, 8)  // 单精度浮点数通常占 4 字节，如果是双精度这里是 8
        ]
    }

    FSub(Name) => {
        let addr1 = find(ctx, Name1);
        let addr2 = find(ctx, Name2);
        [
            Flw(Ft0, {base: Fp, offset: addr1}),
            Flw(Ft1, {base: Fp, offset: addr2}),
            FAdd.d(Ft0, Ft0, Ft1),  // 假设是单精度浮点加法，如果是双精度则用 FAdd.d
            Fsw(Ft0, {base: Sp, offset: 0}),
            Mv(A0, Sp),
            Addi(Sp, Sp, 8)  // 单精度浮点数通常占 4 字节，如果是双精度这里是 8
        ]
    }

    FMul(Name) => {
        let addr1 = find(ctx, Name1);
        let addr2 = find(ctx, Name2);
        [
            Flw(Ft0, {base: Fp, offset: addr1}),
            Flw(Ft1, {base: Fp, offset: addr2}),
            FMul.d(Ft0, Ft0, Ft1),  // 假设是单精度浮点加法，如果是双精度则用 FAdd.d
            Fsw(Ft0, {base: Sp, offset: 0}),
            Mv(A0, Sp),
            Addi(Sp, Sp, 8)  // 单精度浮点数通常占 4 字节，如果是双精度这里是 8
        ]
    }

    FDiv(Name) => {
        let addr1 = find(ctx, Name1);
        let addr2 = find(ctx, Name2);
        [
            Flw(Ft0, {base: Fp, offset: addr1}),
            Flw(Ft1, {base: Fp, offset: addr2}),
            FDiv.d(Ft0, Ft0, Ft1),  // 假设是单精度浮点加法，如果是双精度则用 FAdd.d
            Fsw(Ft0, {base: Sp, offset: 0}),
            Mv(A0, Sp),
            Addi(Sp, Sp, 8)  // 单精度浮点数通常占 4 字节，如果是双精度这里是 8
        ]
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
     
     
     
      Var(Name) => {
          let addr = find(ctx, Name);
          [
              Lw(T0, {base: Fp, offset: addr})
          ]
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