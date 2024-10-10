
/// Just conventional DSU operation :)
fn get_father(ty: InfType) -> InfType {
  if physical_equal(ty, ty.dsu_father.val.unwrap()) { ty }
  else {
    let father = get_father(ty.dsu_father.val.unwrap())
    ty.dsu_father.val = Some(father)
    father
  }
}

fn unify(t1: InfType, t2: InfType) -> Unit!TypeErr {
  let t1 = get_father(t1)
  let t2 = get_father(t2)
  if physical_equal(t1, t2) { return }
  println("     Unify: \{t1.id} and \{t2.id}")
  match (t1.typ, t2.typ) {
    (None, _) => { t1.dsu_father.val = Some(t2) }
    (_, None) | (Some(Int), Some(Kind)) | (Some(Double), Some(Kind)) => { t2.dsu_father.val = Some(t1) }
    _ => {
      t1.dsu_father.val = Some(t2)
      match (t1.typ.unwrap(), t2.typ.unwrap()) {
        (Unit, Unit) | (Bool, Bool) | (Int, Int) | (Double, Double)
          | (Kind, Int) | (Kind, Double) => return
        (Fun(args1, t1), Fun(args2, t2)) => {
          let length = args1.length();
          guard args2.length() == length else {
            raise TypeErr("Type error: Function args length not match.")
          }
          for i in 0 ..< length { unify!(args1[i],args2[i]) }
          unify!(t1, t2)
        }
        (Tuple(list1), Tuple(list2)) => {
          let length = list1.length();
          guard(list2.length() != length) else { 
            raise TypeErr("Type error: Tuple element length not match.")
          }
          for i in 0 ..< length { unify!(list1[i],list2[i]) }
        }
        (Array(t1), Array(t2)) => { unify!(t1, t2) }
        
        _ => raise TypeErr("Type error: type not match.")
      }
    }
  }
}

let extenv : Map[String, InfType] = {
  // 输入输出函数
  "read_int": new(Fun([], inftype_Int)),
  "print_int": new(Fun([inftype_Int], inftype_Unit)),
  "read_char": new(Fun([], inftype_Int)),
  "print_char": new(Fun([inftype_Int], inftype_Unit)),
  "print_newline": new(Fun([], inftype_Unit)),
  // 数学函数
  "int_of_float": new(Fun([inftype_Double], inftype_Int)),
  "float_of_int": new(Fun([inftype_Int], inftype_Double)),
  "truncate": new(Fun([inftype_Double], inftype_Int)),
  "floor": new(Fun([inftype_Double], inftype_Double)),
  "abs_float": new(Fun([inftype_Double], inftype_Double)),
  "sqrt": new(Fun([inftype_Double], inftype_Double)),
  "sin": new(Fun([inftype_Double], inftype_Double)),
  "cos": new(Fun([inftype_Double], inftype_Double)),
  "atan": new(Fun([inftype_Double], inftype_Double)),
}

typealias LocalCtx = @immut/hashmap.T[String, InfType]

/// This infer function is only for **nontop** syntax.
fn infer(ctx: LocalCtx, e: Syntax, ~is_top: Bool = false) -> InfType!TypeErr {
  match e {
    Unit => inftype_Unit
    Bool(_) => inftype_Bool
    Int(_) => inftype_Int
    Double(_) => inftype_Double
    Var(x) => {
      match ctx[x] {
        Some(t) => t
        None =>{
          match extenv[x] {
            Some(t) => t
            None => { raise TypeErr("Type error: function/variable not bounded.") }
            // For nontop syntax, it's not allowed to use before declaration.
          }
        }
      }
    }
    Tuple(elements) => {
      let elements_ty = []
      for element in elements {
        elements_ty.push(infer!(ctx, element))
      }
      new(Tuple(elements_ty))
    }
    Not(ty) => {
      let ty = infer!(ctx, ty)
      unify!(ty, inftype_Bool)
      ty
    }
    Array(x, num) => {
      let ty = infer!(ctx, x)
      let num_ty = infer!(ctx, num)
      unify!(num_ty, inftype_Int)
      ty
    }
    Neg(x, ..)=> {
      let ty = infer!(ctx, x)
      unify!(ty, inftype_Kind)
      ty
    }
    App(f, args) => {
      let ret_ty = new_tvar()
      let f_ty = infer!(ctx, f)
      let args_ty = []
      for arg in args {
        args_ty.push(infer!(ctx, arg))
      }
      println("App new: <\{node_list.length()}>\{Fun(args_ty, ret_ty)}")
      unify!(f_ty, new(Fun(args_ty, ret_ty)))
      println("App \{f}: \{f_ty.to_string()}")
      ret_ty
    }
    Get(f, index) => {
      let ret_ty = new_tvar()
      let f_ty = infer!(ctx, f)
      let index_ty = infer!(ctx, index)
      unify!(index_ty, inftype_Int)
      println("Get new: <\{node_list.length()}>\{Array(ret_ty)}")
      unify!(f_ty, new(Array(ret_ty)))
      println("Get: \{f_ty.to_string()}")
      println("Get_index: \{index_ty.to_string()}")
      ret_ty
    }
    If(expr, expr_if, expr_else) => {
      let expr_ty = infer!(ctx, expr)
      unify!(expr_ty, inftype_Bool)
      let expr_if_ty = infer!(ctx, expr_if)
      let expr_else_ty = infer!(ctx, expr_else)
      unify!(expr_if_ty, expr_else_ty)
      println("If_expr: \{expr_ty.to_string()}")
      println("If_if: \{expr_if_ty.to_string()}")
      println("If_else: \{expr_else_ty.to_string()}")
      expr_if_ty
    }
    Prim(expr1, expr2, _, ..) => {
      let expr1_ty = infer!(ctx, expr1)
      let expr2_ty = infer!(ctx, expr2)
      expr1_ty.link = e
      unify!(expr1_ty, inftype_Kind)
      unify!(expr2_ty, expr1_ty)
      println("Prim_Expr1: \{expr1_ty.to_string()}")
      println("Prim_Expr2: \{expr2_ty.to_string()}")
      expr1_ty
    }
    Eq(expr1, expr2) | LE(expr1, expr2) => {
      let expr1_ty = infer!(ctx, expr1)
      let expr2_ty = infer!(ctx, expr2)
      unify!(expr1_ty, expr2_ty)
      println("Eq/LE_Expr1: \{expr1_ty.to_string()}")
      println("Eq/LE_Expr2: \{expr2_ty.to_string()}")
      inftype_Bool
    }
    Let((f, t), expr, rest) => {
      let mut f_ty: InfType = inftype_root
      if is_top { f_ty = extenv[f].unwrap() }
      else { f_ty = type2inf(t); f_ty.link = e }
      
      let env_with_f = ctx.add(f, f_ty)
      
      let expr_ty = infer!(ctx, expr)
      unify!(f_ty, expr_ty)
      println("Let \{f}: \{f_ty.to_string()}")
      println("Let expr \{f}: \{f_ty.to_string()}")
      
      infer!(env_with_f, rest, ~is_top)
    }
    LetRec({ name: (f, t), args, body }, rest) => {
      let mut f_ty: InfType = inftype_root
      if is_top { f_ty = extenv[f].unwrap() }
      else { f_ty = type2inf(t); f_ty.link = e }
      
      let env_with_f = ctx.add(f, f_ty)
      let mut env_with_params = env_with_f
      
      let args_ty = args.map(fn { (_, t) => type2inf(t) })
      let length = args.length()
      for i in 0..<length {
        env_with_params = env_with_params.add(args[i].0, args_ty[i])
        println("Func args \{f}.\{i}: \{args_ty[i].to_string()}")
      }
      
      let body_ty = infer!(env_with_params, body)
      println("Func \{f}: \{f_ty.to_string()}")
      println("Func_body \{f}: \{body_ty.to_string()}")
      println("Func new \{f}: <\{node_list.length()}>\{Fun(args_ty, body_ty)}")
      unify!(f_ty, new(Fun(args_ty, body_ty)))
      
      infer!(env_with_f, rest, ~is_top)
    }
    LetTuple(elements, expr, rest) => {
      // It's guaranteed that the length of elements and values are equal in parsing section.
      let mut env_with_elements = ctx
      let length = elements.length()
      let elements_ty = elements.map( fn { (_,t) => type2inf(t) } )
      for i in 0 ..< length {
        env_with_elements = env_with_elements.add(elements[i].0, elements_ty[i])
      }
      let expr_ty = infer!(ctx, expr)
      println("LetTuple new: <\{node_list.length()}>\{Tuple(elements_ty)}")
      unify!(expr_ty, new(Tuple(elements_ty), link = e))
      println("LetTuple expr: \{expr_ty.to_string()}")
      infer!(env_with_elements, rest)
    }
    Put(var, expr, rest) => {
      let var_ty = infer!(ctx, var)
      let expr_ty = infer!(ctx, expr)
      unify!(var_ty, expr_ty)
      println("Put_var: \{var_ty.to_string()}")
      println("Put_expr: \{expr_ty.to_string()}")
      infer!(ctx, rest)
    }
  }
}
test "test" {
  println(inftype_Kind.to_string())
}
test "if_else test" {
  let ctx = @immut/hashmap.new()
  let syntax: Syntax =
    If(Bool(true), Int(1), Int(0))
  println(show(infer?(ctx, syntax)))
  topo_sort!()
}
test "ex_frac_mini" {
  let ctx = @immut/hashmap.new()
  let syntax: Syntax =
      LetRec({name: ("frac", Fun([Var({val: None})], Var({val: None}))), args: [("n", Var({val: None}))], body: 
        If(Bool(true), 
          Int(1), 
          Prim(
            App(Var("frac"), [Prim(Var("n"), Int(1), Sub, kind=None)]), 
            Var("n"), 
            Mul, 
            kind=None
          )
        )
      }, 
    Unit)
  println(show(infer?(ctx, syntax)))
  topo_sort!()
}
test "ex_frac" {
  let ctx = @immut/hashmap.new()
  /// fn main {
  ///   fn frac(n) {
  ///     if n == 1 {
  ///       1
  ///     } else {
  ///        frac(n - 1) * n
  ///     }
  ///   };
  ///   print_int(frac(6))
  /// };
  let syntax: Syntax =
    LetRec({name: ("main", Fun([], Unit)), args: [], body: 
      LetRec({name: ("frac", Fun([Var({val: None})], Var({val: None}))), args: [("n", Var({val: None}))], body: 
        If(Eq(Var("n"), Int(1)), 
          Int(1), 
          Prim(
            App(Var("frac"), [Prim(Var("n"), Int(1), Sub, kind=None)]), 
            Var("n"), 
            Mul, 
            kind=None
          )
        )
      }, 
    App(Var("print_int"), [App(Var("frac"), [Int(6)])]))}, 
    Unit)
  println(show(infer?(ctx, syntax)))
  topo_sort!()
}
test "infer recursive function" {
  // Test for recursive function
  let ctx = @immut/hashmap.new()
  /// fn fact(n: Int) -> Int {
  ///   if n == 0 { 1 }
  ///   else { n * fact(n - 1) }
  /// }
  let syntax: Syntax =
    LetRec(
      { name: ("fact", Fun([Int], Int)), args: [("n", Int)], body: 
        If(Eq(Int(0), Int(0)),
          Int(1), 
          Prim(
            Var("n"), 
            App(Var("fact"), [Prim(Var("n"), Int(1), Sub, kind = None)]), 
            Mul, 
            kind = None
          )
          ) 
      }, 
      Unit)
  println(show(infer?(ctx, syntax)))
}
test "infer edge cases" {
  // Test for edge cases
  let ctx = @immut/hashmap.new()
  let syntax: Syntax = Let(("x", Int), Int(42), Var("y")) // Variable 'y' is not defined
  println(show(infer?(ctx, syntax)))
}
test "infer random cases" {
  // Test for random cases
  let ctx = @immut/hashmap.new()
  let syntax: Syntax = Let(("x", Int), Int(42), Prim(Var("x"), Int(2), Mul, kind = None))
  println(show(infer?(ctx, syntax)))

  let syntax2: Syntax = Let(("x", Int), Int(42), Prim(Var("x"), Double(2.0), Mul, kind = None)) // Type mismatch
  println(show(infer?(ctx, syntax2)))
}
test "infer let binding" {
  // Test for let binding
  let ctx = @immut/hashmap.new()
  let syntax: Syntax = Let(("x", Var({val: None})), Int(42), Unit)
  println(show(infer?(ctx, syntax)))
}
test "infer tuple and array" {
  // Test for tuple and array
  println(show(infer?(@immut/hashmap.new(), Tuple([Int(1), Double(2.0)]))))
  println(show(infer?(@immut/hashmap.new(), Array(Int(1), Int(5)))))
}
test "infer function application" {
  // Test for function application
  // f: (Int) -> Int
  let ctx = @immut/hashmap.new().add("f", new(Fun([inftype_Int], inftype_Int)))
  println(show(infer?(ctx, Var("f"))))
  println(show(infer?(ctx, App(Var("f"), [Int(42)]))))
}
test "infer basic functionality" {
  // Test for basic types
  println(show(infer?(@immut/hashmap.new(), Bool(true))))
  println(show(infer?(@immut/hashmap.new(), Int(42))))
  println(show(infer?(@immut/hashmap.new(), Double(3.14))))

  // Test for variable lookup
  let ctx = @immut/hashmap.new().add("x", new(Int))
  println(show(infer?(ctx, Var("x"))))
}

fn modify(ty: Type, x: Type) -> Unit {
  match ty {
    Var({val: Some(_)} as ref) => ref.val = Some(x)
  }
}
fn topo_sort() -> Unit!TypeErr{
  let queue = @queue.new()
  for node in node_list {
    node.dsu_father.val = Some(get_father(node))
  }
  for node in node_list {
    if physical_equal(node, node.dsu_father.val.unwrap()) {
      if node.unsolved_number == 0 { queue.push(node) }
      match node.typ {
        None => {
          println("Type error: cannot infer all the types. ID: \{node.id}")
          raise TypeErr("Type error: cannot infer all the types.")
        }
        Some(Fun(args, ret)) => {
          for arg in args { arg.father.push(node) }
          ret.father.push(node)
        }
        Some(Tuple(elements)) => {
          for element in elements { element.father.push(node) }
        }
        Some(Array(ty)) => { ty.father.push(node) }
        _ => continue
      }
    }
  }
  for node in node_list {
    match node.typ {
      Some(ty) => println(" \{node.unsolved_number} \{ty.to_string()} => \{node.dsu_father.val.unwrap().to_string()}")
      None => { println(" \{node.unsolved_number} None => \{node.dsu_father.val.unwrap().to_string()}") }
    }
  }
  while not(queue.is_empty()) {
    let node = queue.pop().unwrap()
    
    node.sol_typ = match node.typ.unwrap() {
      Unit => Unit
      Bool => Bool
      Int | Kind => Int
      Double => Double
      Fun(args, ret) => {
        let sol_args = []
        for arg in args { sol_args.push(arg.dsu_father.val.unwrap().sol_typ) }
        Fun(sol_args, ret.dsu_father.val.unwrap().sol_typ)
      }
      Tuple(elements) => {
        let sol_elements = []
        for element in elements { 
          sol_elements.push(element.dsu_father.val.unwrap().sol_typ) 
        }
        Tuple(sol_elements)
      }
      Array(ty) => { ty.dsu_father.val.unwrap().sol_typ }
    }
    match node.link {
      Unit => continue
      Let((_, ty), _, _) => {
        modify(ty, node.sol_typ)
      }
      LetRec({ name: (_, t), args: arg_list, .. }, _) => {
        let Fun(args, ret) = t
        let Fun(sol_args, sol_ret) = node.sol_typ
        let length = args.length()
        for i in 0..<length {
          modify(args[i], sol_args[i])
          modify(arg_list[i].1, sol_args[i])
        }
        modify(ret, sol_ret)
      }
      LetTuple(elements, _, _) => {
        let Tuple(sol_elements) = node.sol_typ
        let length = elements.length()
        for i in 0 ..<length {
          modify(elements[i].1, sol_elements[i])
        }
      }
      Prim(_) as syntax=> {
        match node.sol_typ {
          Int => syntax.kind = Some(Int)
          Double => syntax.kind = Some(Double)
        }
      }
    }
    
    for fat in node.father {
      fat.unsolved_number -= 1
      if fat.unsolved_number == 0 { queue.push(fat) }
    }
  }
}

pub fn typing(e : Syntax) -> Syntax!TypeErr {
  // TODO: init, reset node_list and extenv
  loop e {
    Let((f, t), _, rest) => {
      let f_ty = type2inf(t); f_ty.link = e
      extenv[f] = f_ty
      continue rest
    }
    LetRec({ name: (f, t), .. }, rest) => {
      let f_ty = type2inf(t); f_ty.link = e
      extenv[f] = f_ty
      continue rest
    }
  }
  ignore(infer!(@immut/hashmap.new(), e))
  topo_sort!()
  e
}