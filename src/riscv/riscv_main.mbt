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
    Bool(false) => ...
    Int(i) => ...
    
    ...
    
    Add(x, y) => {
      let x = find(ctx, x)
      let y = find(ctx, y)
      [
        Lw(T0, {base: Fp, offset: x}),
        Lw(T1, {base: Fp, offset: y}),
        Add(T0, T0, T1),
        Sw(T0, {base: Sp, offset: 0}),
        Mv(A0, Sp),
        Addi(Sp, Sp, 1)
      ]
    }
  }
}