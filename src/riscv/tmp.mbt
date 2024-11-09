let offset: Ref[Int] = {val: 0} // 当前内存地址。不用回收，随便用

// fn alloc(ty: LowType) -> Array[RvAsm] {
//   match ty {
//     Unit => []
//     Bool => [minimbt_alloc(...)]
//     Int => [minimbt_alloc(...)]
//     Double => [minimbt_alloc(...)]
    
//   }
// }

pub fn emit(
  input : Program
) -> Array[AssemblyFunction] {
  offset.val = 0
  let function_asms = []
  // for closure in input.fundefs {
  //   // 这里是所有闭包的定义
  //   // 需要为所有参数和自由变量预留接口(内存地址)
  //   // 在程序中创建闭包时，将自由变量的值写入内存
  //   // 在调用闭包时，提取自由变量的值，然后和参数一起写入内存并调用
  //   let env = LocalEnv::new()
  //   for fv in fvs {
      
  //   }
    
  //   let closure_asm = closure_to_riscv(env, closure.body)
  //   function_asms.push(closure_asm)
  // }
  // let body_asm = expr_to_riscv(LocalEnv::new(), input.body)
  // function_asms.push(body_asm)
  function_asms
}

// fn closure_to_riscv(ctx: LocalEnv, expr: Expr) -> AssemblyFunction {
  
// }

// fn expr_to_riscv(ctx: LocalEnv, expr: Expr) -> AssemblyFunction {
  
// }