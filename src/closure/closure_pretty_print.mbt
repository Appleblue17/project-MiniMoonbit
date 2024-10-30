struct PrettyClosure {
  closure_ir: Program
}

pub fn Program::to_pretty_print(self : Program) -> PrettyClosure {
  { closure_ir: self }
}

fn PrettyClosure::print_one_level(
  self : PrettyClosure,
  logger : @util.IndentLogger,
  val : Expr
) -> Unit {
  match val {
    Unit => logger.write_string("Unit")
    Bool(b) => logger.write_string("Bool(\{b})") // added
    Int(i) => logger.write_string("Int(\{i})")
    Double(d) => logger.write_string("Double(\{d})")
    Not(name) => logger.write_string("Not(\{name})") // added
    MakeArray(name, size) => logger.write_string("MakeArray(\{name}, \{size})") // added
    Neg(e) => logger.write_string("Neg(\{e})")
    Var(name) => logger.write_string("Var(\{name})")
    Add(e1, e2) => logger.write_string("Add(\{e1}, \{e2})")
    Sub(e1, e2) => logger.write_string("Sub(\{e1}, \{e2})")
    Mul(e1, e2) => logger.write_string("Mul(\{e1}, \{e2})")
    Div(e1, e2) => logger.write_string("Div(\{e1}, \{e2})")
    FNeg(e) => logger.write_string("FNeg(\{e})")
    FAdd(e1, e2) => logger.write_string("FAdd(\{e1}, \{e2})")
    FSub(e1, e2) => logger.write_string("FSub(\{e1}, \{e2})")
    FMul(e1, e2) => logger.write_string("FMul(\{e1}, \{e2})")
    FDiv(e1, e2) => logger.write_string("FDiv(\{e1}, \{e2})")
    IfEq(e1, e2, e3, e4) => {
      logger.write_string("if (\{e1} == \{e2}) then {")
      logger.indent()
      logger.write_string("\n")
      self.print_one_level(logger, e3)
      logger.outdent()
      logger.write_string("\n")
      logger.write_string("} else {")
      logger.indent()
      logger.write_string("\n")
      self.print_one_level(logger, e4)
      logger.outdent()
      logger.write_string("\n}")
    }
    IfLe(e1, e2, e3, e4) => {
      logger.write_string("if (\{e1} <= \{e2}) then {")
      logger.indent()
      logger.write_string("\n")
      self.print_one_level(logger, e3)
      logger.outdent()
      logger.write_string("\n")
      logger.write_string("} else {")
      logger.indent()
      logger.write_string("\n")
      self.print_one_level(logger, e4)
      logger.outdent()
      logger.write_string("\n}")
    }
    Let((name, ty), e1, e2) => {
      logger.write_string("let \{name}: \{ty} = ")
      match e1 {
        Let(_) | MakeClosure(_) | LetTuple(_) => {
          logger.write_string("\n")
          logger.indent()
          self.print_one_level(logger, e1)
          logger.outdent()
        }
        _ => self.print_one_level(logger, e1)
      }
      logger.write_string("\n")
      self.print_one_level(logger, e2)
    }
    LetTuple(name_types, y, e) => {
      logger.write_string("let (")
      let mut first = true
      for nt in name_types {
        if first {
          first = false
          logger.write_string(", ")
        }
        let (name, ty) = nt
        logger.write_string("\{name}: \{ty}")
      }
      logger.write_string(") = \{y}")
      self.print_one_level(logger, e)
    }
    MakeClosure((name, ty), closure, e) => {
      logger.write_string("MakeClosure(\{name}: \{ty},")
      logger.indent()
      logger.write_string("\n")
      logger.write_string("closure: \{closure})")
      logger.outdent()
      logger.write_string("\n")
       
      self.print_one_level(logger, e)
    }
    CallClosure(name, args) => {
      logger.write_string("CallClosure(\{name}, [")
      for arg in args {
        logger.write_string(arg.to_string())
        logger.write_string(", ")
      }
      logger.write_string("])")
    }
    CallDirect(label, args) => {
      logger.write_string("CallDirect(\{label}, [")
      for arg in args {
        logger.write_string(arg.to_string())
        logger.write_string(", ")
      }
      logger.write_string("])")
    }
    MakeTuple(es) => {
      logger.write_string("Tuple([")
      for e in es {
        logger.write_string(e.to_string())
        logger.write_string(", ")
      }
      logger.write_string("])")
    }
    ArrayPut(e1, e2, e3) => logger.write_string("ArrayPut \{e1}[\{e2}] = \{e3}")
    ArrayGet(e1, e2) => logger.write_string("ArrayGet \{e1}[\{e2}]")
    ExternalArray(name) => logger.write_string("ExternalArray(\{name})")
  }
}

pub impl Show for PrettyClosure with output(self : PrettyClosure, logger : Logger) -> Unit {
  let indent_logger = @util.IndentLogger::new(logger)
  
  let closure_ir = self.closure_ir
  for fundef in closure_ir.fundefs {
    indent_logger.write_string("> \{fundef.name} \{fundef.args}/\{fundef.formal_free_vars} : \{fundef.ty}\n")
    indent_logger.indent()
    self.print_one_level(indent_logger, fundef.body)
    indent_logger.write_string("\n\n")
    indent_logger.outdent()
  }
  
  self.print_one_level(indent_logger, closure_ir.body)
}
