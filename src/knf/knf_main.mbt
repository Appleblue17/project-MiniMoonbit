let env: Ref[KnfEnv] = Ref::new(KnfEnv::new(@immut/hashmap.T::new()))

fn clean(ty : Type) -> Type {
  match ty {
    Var(t) =>
      match t.val {
        Some(t) => clean(t)
        None => @util.die("KNF error: type not resolved. There is a problem in typechecking.")
      }
    Tuple(tys) => Tuple(tys.map(clean))
    Array(ty) => Array(clean(ty))
    Fun(args, ret) => Fun(args.map(clean), clean(ret))
    _ => ty
  }
}

fn ast_to_knf(ctx : LocalEnv, syntax : Syntax) -> (Knf, Type) {
  match syntax {
    Unit => (Unit, Unit)
    Bool(value) => (Bool(value), Bool)
    Int(value) => (Int(value), Int)
    Double(value) => (Double(value), Double)
    Var(str) => {
      match ctx[str] {
        Some( (name, typ) ) => (Var(name), typ)
        None => { @util.die("KNF error: function/variable \{str} not bounded.") }
      }
    }
    Tuple(elements) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // ...
      // Tuple(a_name, b_name, ...)
      let names = Array::new()
      let name_and_elements = Array::new()
      for i in 0..<elements.length() {
        names.push(env.val.new_name())
        name_and_elements.push((names[i], elements[i]))
      }
      
      let typs = []
      let knf = 
        name_and_elements.fold( init = Tuple(names),
          fn { 
            knf, (name, element) => {
              let (ret, ty) = ast_to_knf(ctx, element)
              typs.push(ty)
              Let((name, ty), ret, knf)
            }
          } )
      (knf, Tuple(typs) )
    }
    Not(expr) => {
      // let expr_name = <expr> in
      // Not(expr_name)
      let expr_name = env.val.new_name()
      (Let((expr_name, Bool), ast_to_knf(ctx, expr).0, Not(expr_name)), Bool)
    }
    Array(expr, num) => {
      // let expr_name = <expr> in
      // let num_name = <num> in
      // Array::make(expr_name, num_name)
      let expr_name = env.val.new_name()
      let num_name = env.val.new_name()
      
      let (expr_ret, expr_ty) = ast_to_knf(ctx, expr)
      let (num_ret, num_ty) = ast_to_knf(ctx, num)
      let knf = 
        Let((expr_name, expr_ty), expr_ret,
          Let((num_name, Int), num_ret,
            Array(expr_name, num_name)
          )
        )
      (knf, Array(num_ty) )
    }
    Neg(expr, ~kind) => {
      // let expr_name = <expr> in
      // Neg(expr_name)
      
      let expr_name = env.val.new_name()
      (Let((expr_name, Int), ast_to_knf(ctx, expr).0, 
        match kind {
          Some(Int) => Neg(expr_name)
          Some(Double) => FNeg(expr_name)
          _ => @util.die("KNF error: Neg must have a kind, there is a problem with typing.")
        }
      ), Int)
    }
    App(func, args) => {
      // let func_name = <func> in
      // let arg1_name = <arg1> in
      // let arg2_name = <arg2> in
      // ...
      // Apply(func_name, [arg1_name, arg2_name, ...])
      
      let arg_names = Array::new()
      let name_and_args = Array::new()
      for i in 0..<args.length() {
        arg_names.push(env.val.new_name())
        name_and_args.push((arg_names[i], args[i]))
      }
      
      let (init, typ) = match func {
        Var(str) => {
          if(ctx[str] != None) {
            let (ret, ty) = ctx[str].unwrap()
            (Apply(ret, arg_names), ty)
          }
          else {
            let ty = env.val.externals[str]
            if (ty != None) { (ExternalFunctionApplication("minimbt_"+str, arg_names), ty.unwrap()) }
            else { @util.die("KNF error: function not found.") }
          }
        }
        _ => {
          let f_name = env.val.new_name()
          let (ret, ty) = ast_to_knf(ctx, func)
          ( Let( (f_name, ty), ret, Apply(f_name, arg_names) ), ty)
        }
      }
      
      let knf = 
        name_and_args.fold( ~init,
          fn { 
            knf, (name, arg) => {
              let (arg_knf, arg_ty) = ast_to_knf(ctx, arg)
              Let((name, arg_ty), arg_knf, knf)
            }
          } )
      
      match typ{
        Fun(_, ret) => (knf, ret)
        _ => @util.die("KNF error: function type not valid.")
      }
    }
    Get(expr, index) => {
      // let expr_name = <expr> in
      // let index_name = <index> in
      // Get(expr_name, index_name)
      let expr_name = env.val.new_name()
      let index_name = env.val.new_name()
      let (expr_ret, expr_ty) = ast_to_knf(ctx, expr)
      let knf =
        Let((expr_name, expr_ty), expr_ret,
          Let((index_name, Int), ast_to_knf(ctx, index).0,
            Get(expr_name, index_name)
          )
        )
      match expr_ty {
        Array(ty) => (knf, ty)
        _ => @util.die("KNF error: Get must have an array type.")
      }
    }
    If(cond, then, els) => {
      // let cond_name = <cond> in
      // let true_name = True
      // ifEq (cond_name, true_name) then <then> else <els>
      let cond_name = env.val.new_name()
      let true_name = env.val.new_name()
      
      let (then_ret, then_ty) = ast_to_knf(ctx, then)
      let (els_ret, els_ty) = ast_to_knf(ctx, els)
      guard then_ty == els_ty else { @util.die("KNF error: If branches must have the same type. There is a problem with typechecking.") }
      let knf =
        Let((cond_name, Bool), ast_to_knf(ctx, cond).0,
          Let((true_name, Bool), Bool(true),
            IfEq(cond_name, true_name, then_ret, els_ret),
          )
        )
      (knf, then_ty)
    }
    Prim(a, b, op, ~kind) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // a_name + b_name
      let a_name = env.val.new_name()
      let b_name = env.val.new_name()
      
      let (a_ret, a_ty) = ast_to_knf(ctx, a)
      let (b_ret, b_ty) = ast_to_knf(ctx, b)
      
      let knf = 
        Let((a_name, a_ty), a_ret,
          Let((b_name, b_ty), b_ret,
            match (op, kind) {
              (Add, Some(Int)) => Add(a_name, b_name)
              (Sub, Some(Int)) => Sub(a_name, b_name)
              (Mul, Some(Int)) => Mul(a_name, b_name)
              (Div, Some(Int)) => Div(a_name, b_name)
              (Add, Some(Double)) => FAdd(a_name, b_name)
              (Sub, Some(Double)) => FSub(a_name, b_name)
              (Mul, Some(Double)) => FMul(a_name, b_name)
              (Div, Some(Double)) => FDiv(a_name, b_name)
              _ => {
                @util.die("KNF error: Prim must have a kind, there is a problem with typing.")
              }
            }
          )
        )
      (knf, a_ty)
    }
    Eq(a, b) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // IfEq (a_name, b_name) then <true> else <false>)
      let a_name = env.val.new_name()
      let b_name = env.val.new_name()
      
      let (a_ret, a_ty) = ast_to_knf(ctx, a)
      let (b_ret, b_ty) = ast_to_knf(ctx, b)
      let knf = 
        Let((a_name, a_ty), a_ret,
          Let((b_name, b_ty), b_ret,
            IfEq(a_name, b_name, Bool(true), Bool(false))
          )
        )
      (knf, Bool)
    }
    LE(a, b) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // IfLe (a_name, b_name) then <true> else <false>)
      let a_name = env.val.new_name()
      let b_name = env.val.new_name()
      
      let (a_ret, a_ty) = ast_to_knf(ctx, a)
      let (b_ret, b_ty) = ast_to_knf(ctx, b)
      let knf = 
        Let((a_name, a_ty), a_ret,
          Let((b_name, b_ty), b_ret,
            IfLe(a_name, b_name, Bool(true), Bool(false))
          )
        )
      (knf, Bool)
    }
    Let((str, ty), value, rest) => {
      // let name = <value> in <rest>
      let name = env.val.new_str_name(str)
      let value_knf = ast_to_knf(ctx, value).0
      let new_ctx = ctx.add(str, (name, clean(ty)))
      
      let (rest_knf, rest_ty) = ast_to_knf(new_ctx, rest)
      (Let((name, clean(ty)), value_knf, rest_knf), rest_ty)
    }
    LetRec( {name: (str, ty), args, body}, rest) => {
      // let fun(x, y, z, ...) = {x..y..z..} in <body>
      let name = env.val.new_str_name(str)
      
      let name_and_types = Array::new()
      let mut new_ctx = ctx
      for arg in args {
        let arg_name = env.val.new_str_name(arg.0)
        name_and_types.push((arg_name, clean(arg.1)))
        new_ctx = new_ctx.add(arg.0, (arg_name, clean(arg.1)))
      }
      new_ctx = new_ctx.add(str, (name, clean(ty)))
      let body_knf = ast_to_knf(new_ctx, body)
      
      let ctx_with_f = ctx.add(str, (name, clean(ty)))
      
      let (rest_ret, rest_ty) = ast_to_knf(ctx_with_f, rest)
      let knf = 
        LetRec( { name, ty: clean(ty), args: name_and_types, 
            body: body_knf.0 }, rest_ret )
      (knf, rest_ty)
    }
    
    LetTuple(elements, value, rest) => {
      // let name_x = <x> in
      // let name_y = <y> in
      // let name_z = <z> in
      // ...
      
      let value_knf = ast_to_knf(ctx, value)
      let mut new_ctx = ctx
      let element_names = []
      for i in 0..<elements.length() {
        let element_str = elements[i].0
        let element_name = env.val.new_str_name(element_str)
        new_ctx = new_ctx.add(element_str, (element_name, clean(elements[i].1)))
        element_names.push( (element_name, clean(elements[i].1)) )
      }
      let (rest_ret, rest_ty) = ast_to_knf(new_ctx, rest)
      (LetTuple(element_names, value_knf.0, rest_ret), rest_ty)
    }
    
    Put(a, b, c, rest) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // let c_name = <c> in
      // Put(a_name, b_name, c_name)
      let a_name = env.val.new_name()
      let b_name = env.val.new_name()
      let c_name = env.val.new_name()
      
      let (a_ret, a_ty) = ast_to_knf(ctx, a)
      let (c_ret, c_ty) = ast_to_knf(ctx, c)
      let (rest_ret, rest_ty) = ast_to_knf(ctx, rest)
      let knf = 
        Let((a_name, a_ty), a_ret,
          Let((b_name, Int), ast_to_knf(ctx, b).0,
            Let((c_name, c_ty), c_ret,
              Put(a_name, b_name, c_name, rest_ret)
            )
          )
        )
      (knf, rest_ty)
    }
  } 
}

test "If Conversion" {
  let ctx = LocalEnv::new()
  
  // Test If conversion
  println(ast_to_knf(ctx, If(Bool(true), Int(1), Int(0))).0.to_pretty_print())
}
test "Let Conversion" {
  let ctx = LocalEnv::new()
  
  // Test Let conversion
  println(ast_to_knf(ctx, Let(("x", Type::Int), Int(10), Var("x"))).0.to_pretty_print())
}

test "Prim Conversion" {
  let ctx = LocalEnv::new()
  
  // Test Prim conversion
  println(ast_to_knf(ctx, Prim(Double(5), Double(3), Div, kind=Some(Double))).0.to_pretty_print())
}
test "App Conversion" {
  let ctx = LocalEnv::new().add("f", (env.val.new_str_name("f"), Type::Fun([Int], Unit)))
  // Test App conversion
  println(ast_to_knf(ctx, App(Var("f"), [Int(1), Int(2)])).0.to_pretty_print())
}
test "Array Conversion" {
  let ctx = LocalEnv::new()
  
  // Test Array conversion
  println(ast_to_knf(ctx, Array(Int(1), Int(5))).0.to_pretty_print())
}
test "Neg Conversion" {
  let ctx = LocalEnv::new()
  
  // Test Neg conversion
  println(ast_to_knf(ctx, Neg(Int(10), kind=Some(Int))).0.to_pretty_print())
}

test "LetTuple Conversion" {
  // Test LetTuple conversion
  let ctx = LocalEnv::new()
  
  let tuple_elements = [("x", Type::Int), ("y", Type::Bool)]
  let tuple_exprs = [Syntax::Int(1), Syntax::Bool(true)]
  let st = Syntax::LetTuple(tuple_elements, Tuple(tuple_exprs), Var("x"))
  println(ast_to_knf(ctx, st).0.to_pretty_print());
}
test "Variable and Tuple Conversion" {
  // Test Tuple conversion
  let ctx = LocalEnv::new()
  let tuple_elements = [Syntax::Int(1), Bool(false), Double(2.71)]
  println(ast_to_knf(ctx, Tuple(tuple_elements)).0.to_pretty_print())
}
test "Variable Conversion" {
  let var_name = env.val.new_str_name("x")
  let ctx = LocalEnv::new().add("x", (var_name, Type::Int))
  println(ast_to_knf(ctx, Var("x")).0.to_pretty_print())
}
test "Basic Syntax Conversion" {
  let ctx = LocalEnv::new()
  
  // Test Unit conversion
  inspect!(ast_to_knf(ctx, Unit), content="(Unit, Unit)")
  
  // Test Bool conversion
  inspect!(ast_to_knf(ctx, Bool(true)), content="(Bool(true), Bool)")
  
  // Test Int conversion
  inspect!(ast_to_knf(ctx, Int(42)), content="(Int(42), Int)")
  
  // Test Double conversion
  inspect!(ast_to_knf(ctx, Double(3.14)), content="(Double(3.14), Double)")
}

/// Preprocesses the syntax tree, extracting the contents of functions `main` and `init` to top-level.
fn KnfEnv::syntax_preprocess(e : Syntax, main: Syntax?) -> Syntax {
  match e {
    Let(name, expr, rest) => {
      Let(name, expr, syntax_preprocess(rest, main))
    }
    LetRec({ name: (str, _), body, .. } as func, rest) => {
      if str == "main" { syntax_preprocess(rest, Some(body)) }
      else { LetRec(func, syntax_preprocess(rest, main )) }
      
    }
    Unit => main.unwrap()
  }
}


pub fn KnfEnv::to_knf(self : KnfEnv, syntax : @types.Syntax) -> Knf {
  env.val = self
  let new_syntax = syntax_preprocess(syntax, None)
  ast_to_knf(LocalEnv::new(), new_syntax).0
}