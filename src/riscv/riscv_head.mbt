typealias Expr = @closure.Expr
typealias LowType = @closure.LowType
typealias Program = @closure.Program
typealias Name = @types.Name

pub typealias LocalEnv = @immut/hashmap.T[Name, Int] // 

pub struct AssemblyFunction {
  name : String
  export : Bool
  body : Array[RvAsm]
}

pub fn AssemblyFunction::output(
  self : AssemblyFunction,
  logger : Logger
) -> Unit {
  let name = self.name
  if self.export {
    logger.write_string(".global \{name}\n")
  }
  logger.write_string("\{name}:\n")
  for asm in self.body {
    Show::output(asm, logger)
    logger.write_string("\n")
  }
}

pub fn print_functions(asm : Array[AssemblyFunction]) -> String {
  let logger = Buffer::new()
  for f in asm {
    f.output(logger)
    logger.write_string("\n")
  }
  logger.to_string()
}

fn appendx[T](a : Array[T], b : Array[T]) -> Unit {
  for x in b {
    a.push(x)
  }
}

fn concat[T](a : Array[T], b : Array[T]) -> Array[T] {
  for x in b {
    a.push(x)
  }
  a
}