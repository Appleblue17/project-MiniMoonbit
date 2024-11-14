typealias Expr = @closure.Expr
typealias LowType = @closure.LowType
typealias Program = @closure.Program
typealias Name = @types.Name

pub struct AssemblyFunction {
  name : String
  export : Bool
  is_text: Bool
  body : AsmList
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
  for asm in self.body._ {
    Show::output(asm, logger)
    logger.write_string("\n")
  }
}

pub fn print_functions(asm : Array[AssemblyFunction]) -> String {
  let logger = Buffer::new()
  logger.write_string(".data\n")
  let mut flag = true
  for f in asm {
    if f.is_text && flag {
      logger.write_string(".text\n")
      flag = false
    }
    f.output(logger)
    logger.write_string("\n")
  }
  logger.to_string()
}


type AsmList Array[RvAsm] derive(Show)

fn AsmList::appendx(self : AsmList, a : AsmList) -> Unit {
  for x in a._ {
    self._.push(x)
  }
}

fn concat[T](a : Array[T], b : Array[T]) -> Array[T] {
  for x in b {
    a.push(x)
  }
  a
}

fn AsmList::op_add(self : AsmList, b : AsmList) -> AsmList {
  for x in b._ {
    self._.push(x)
  }
  self
}
