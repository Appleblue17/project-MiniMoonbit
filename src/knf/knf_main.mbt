fn ast_to_knf(env : KnfEnv, syntax : Syntax) -> Knf {
  match syntax {
    Unit => Unit
    Bool(value) => Bool(value)
    Int(value) => Int(value)
    Double(value) => Double(value)
    Var(str) => {
      match env.ctx[str] {
        Some(name) => Var(name)
        None => { @util.die("KNF error: function/variable not bounded.") }
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
        names.push(env.new_name())
        name_and_elements.push((names[i], elements[i]))
      }
      
      name_and_elements.fold( init = Tuple(names),
        fn { 
          knf, (name, element) => 
            Let((name, Var({val: None})), ast_to_knf(env, element), knf)
        } )
    }
    Not(expr) => {
      // let expr_name = <expr> in
      // Not(expr_name)
      let expr_name = env.new_name()
      Let((expr_name, Bool), ast_to_knf(env, expr), Not(expr_name))
    }
    Array(expr, num) => {
      // let expr_name = <expr> in
      // let num_name = <num> in
      // Array::make(expr_name, num_name)
      let expr_name = env.new_name()
      let num_name = env.new_name()
      Let((expr_name, Var({val: None})), ast_to_knf(env, expr),
        Let((num_name, Int), ast_to_knf(env, num),
          Array(expr_name, num_name)
        )
      )
    }
    Neg(expr, ~kind) => {
      // let expr_name = <expr> in
      // Neg(expr_name)
      let expr_name = env.new_name()
      Let((expr_name, Int), ast_to_knf(env, expr), 
        match kind {
          Some(Int) => Neg(expr_name)
          Some(Double) => FNeg(expr_name)
          _ => @util.die("KNF error: Neg must have a kind, there is a problem with typing.")
        }
      )
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
        arg_names.push(env.new_name())
        name_and_args.push((arg_names[i], args[i]))
      }
      
      let init = match func {
        Var(str) => {
          if(env.ctx[str] != None) { Apply(env.ctx[str].unwrap(), arg_names) }
          else {
            if (env.externals[str] != None) { ExternalFunctionApplication("minimbt_"+str, arg_names) }
            else { @util.die("KNF error: function not found.") }
          }
        }
        _ => Apply(env.new_name(), arg_names)
      }
      
      name_and_args.fold( ~init,
        fn { 
          knf, (name, arg) => 
            Let((name, Var({val: None})), ast_to_knf(env, arg), knf)
        } )
    }
    Get(expr, index) => {
      // let expr_name = <expr> in
      // let index_name = <index> in
      // Get(expr_name, index_name)
      let expr_name = env.new_name()
      let index_name = env.new_name()
      Let((expr_name, Var({val: None})), ast_to_knf(env, expr),
        Let((index_name, Int), ast_to_knf(env, index),
          Get(expr_name, index_name)
        )
      )
    }
    If(cond, then, els) => {
      // let cond_name = <cond> in
      // let true_name = True
      // ifEq (cond_name, true_name) then <then> else <els>
      let cond_name = env.new_name()
      let true_name = env.new_name()
      
      Let((cond_name, Bool), ast_to_knf(env, cond),
        Let((true_name, Bool), Bool(true),
          IfEq(cond_name, true_name, ast_to_knf(env, then), ast_to_knf(env, els)),
        )
      )
    }
    Prim(a, b, op, ~kind) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // a_name + b_name
      let a_name = env.new_name()
      let b_name = env.new_name()
      
      Let((a_name, Var({val: None})), ast_to_knf(env, a),
        Let((b_name, Var({val: None})), ast_to_knf(env, b),
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
    }
    Eq(a, b) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // IfEq (a_name, b_name) then <true> else <false>)
      let a_name = env.new_name()
      let b_name = env.new_name()
      
      Let((a_name, Var({val: None})), ast_to_knf(env, a),
        Let((b_name, Var({val: None})), ast_to_knf(env, b),
          IfEq(a_name, b_name, Bool(true), Bool(false))
        )
      )
    }
    LE(a, b) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // IfLe (a_name, b_name) then <true> else <false>)
      let a_name = env.new_name()
      let b_name = env.new_name()
      
      Let((a_name, Var({val: None})), ast_to_knf(env, a),
        Let((b_name, Var({val: None})), ast_to_knf(env, b),
          IfLe(a_name, b_name, Bool(true), Bool(false))
        )
      )
    }
    Let((str, ty), value, rest) => {
      // let name = <value> in <rest>
      let name = env.new_str_name(str)
      let value_knf = ast_to_knf(env, value)
      let new_env = {..env, ctx: env.ctx.add(str, name) }
      Let((name, ty), value_knf, ast_to_knf(new_env, rest))
    }
    LetRec( {name: (str, ty), args, body}, rest) => {
      // let fun(x, y, z, ...) = {x..y..z..} in <body>
      let name = env.new_str_name(str)
      
      let name_and_types = Array::new()
      let mut new_ctx = env.ctx
      for arg in args {
        let arg_name = env.new_str_name(arg.0)
        name_and_types.push((arg_name, arg.1))
        new_ctx = new_ctx.add(arg.0, arg_name)
      }
      let new_env = {..env, ctx: new_ctx.add(str, name) }
      let body_knf = ast_to_knf(new_env, body)
      
      let env_with_f = {..new_env, ctx: env.ctx.add(str, name) }
      LetRec( { name, ty, args: name_and_types, 
          body: body_knf }, ast_to_knf(env_with_f, rest) )
    }
    
    LetTuple(elements, tuple, rest) => {
      // let name_x = <x> in
      // let name_y = <y> in
      // let name_z = <z> in
      // ...
      
      // It's gauranteed that tuple is Tuple(...).
      match tuple {
        Tuple(_) => ()
        _ => @util.die("KNF error: LetTuple must have a tuple as the second argument.")
      }
      let Tuple(exprs) = tuple
      let exprs_knf = exprs.map( fn { expr => ast_to_knf(env, expr) } )
      
      let mut new_ctx = env.ctx
      let name_and_elements = Array::new()
      for i in 0..<elements.length() {
        name_and_elements.push( (env.new_str_name(elements[i].0), exprs_knf[i]) )
        new_ctx = new_ctx.add(elements[i].0, name_and_elements[i].0)
      }
      let new_env = {..env, ctx: new_ctx }
      name_and_elements.fold( init = ast_to_knf(new_env, rest),
        fn { 
          knf, (name, element) => 
            Let((name, Var({val: None})), element, knf)
        } )
      
    }
    
    Put(a, b, c) => {
      // let a_name = <a> in
      // let b_name = <b> in
      // let c_name = <c> in
      // Put(a_name, b_name, c_name)
      let a_name = env.new_name()
      let b_name = env.new_name()
      let c_name = env.new_name()
      
      Let((a_name, Var({val: None})), ast_to_knf(env, a),
        Let((b_name, Var({val: None})), ast_to_knf(env, b),
          Let((c_name, Var({val: None})), ast_to_knf(env, c),
            Put(a_name, b_name, c_name)
          )
        )
      )
    }
  }
  
}
test "ex_frac" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  let var_name = env.new_str_name("main")
  let new_env = {..env,
      externals: env.externals.add("print_int", Unit), 
      ctx: env.ctx.add("main", var_name) }
  
  let input = @types.Syntax::from_json!(@json.parse!(
    #|["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["LetRec",{"name":["frac",["Fun",[["Var",["Some","Int"]]],["Var",["Some","Int"]]]],"args":[["n",["Var",["Some","Int"]]]],"body":["If",["Eq",["Var","n"],["Int",1]],["Int",1],["Mul",["App",["Var","frac"],[["Sub",["Var","n"],["Int",1]]]],["Var","n"]]]},["App",["Var","print_int"],[["App",["Var","frac"],[["Int",6]]]]]]},"Unit"] 
  ))
  println(new_env.to_knf(input).to_pretty_print())
}
test "non-tail-if2" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  let var_name = env.new_str_name("main")
  let new_env = {..env,
      externals: env.externals.add("print_int", Unit), 
      ctx: env.ctx.add("main", var_name) }
  
  let input = @types.Syntax::from_json!(@json.parse!(
    #|["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["LetRec",{"name":["f",["Fun",[],["Var",["Some","Int"]]]],"args":[],"body":["Int",12345]},["Let",["y",["Var",["Some",["Array","Int"]]]],["Array",["Int",10],["Int",3]],["Let",["x",["Var",["Some","Int"]]],["Int",67890],["App",["Var","print_int"],[["If",["Eq",["Get",["Var","y"],["Int",0]],["Int",3]],["Add",["Add",["App",["Var","f"],[]],["Get",["Var","y"],["Int",1]]],["Var","x"]],["Int",7]]]]]]]},"Unit"] 
  ))
  println(new_env.to_knf(input).to_pretty_print())
}


test "If Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  
  // Test If conversion
  println(ast_to_knf(env, If(Bool(true), Int(1), Int(0))).to_pretty_print())
}
test "Let Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  
  // Test Let conversion
  println(ast_to_knf(env, Let(("x", Type::Int), Int(10), Var("x"))).to_pretty_print())
}

test "Prim Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  
  // Test Prim conversion
  println(ast_to_knf(env, Prim(Double(5), Double(3), Div, kind=Some(Double))).to_pretty_print())
}
test "App Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  // Test App conversion
  println(ast_to_knf(env, App(Var("f"), [Int(1), Int(2)])).to_pretty_print())
}
test "Array Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  
  // Test Array conversion
  println(ast_to_knf(env, Array(Int(1), Int(5))).to_pretty_print())
}
test "Neg Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  
  // Test Neg conversion
  println(ast_to_knf(env, Neg(Int(10), kind=Some(Int))).to_pretty_print())
}

test "LetTuple Conversion" {
  // Test LetTuple conversion
  let env = KnfEnv::new(@immut/hashmap.T::new())
  
  let tuple_elements = [("x", Type::Int), ("y", Type::Bool)]
  let tuple_exprs = [Syntax::Int(1), Syntax::Bool(true)]
  let st = Syntax::LetTuple(tuple_elements, Tuple(tuple_exprs), Var("x"))
  println(ast_to_knf(env, st).to_pretty_print());
}
test "Variable and Tuple Conversion" {
  // Test Tuple conversion
  let env = KnfEnv::new(@immut/hashmap.T::new())
  let tuple_elements = [Syntax::Int(1), Bool(false), Double(2.71)]
  println(ast_to_knf(env, Tuple(tuple_elements)).to_pretty_print())
}
test "Variable Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  let var_name = env.new_str_name("x")
  let new_env = {..env, ctx: env.ctx.add("x", var_name) }
  println(ast_to_knf(new_env, Var("x")).to_pretty_print())
}
test "Basic Syntax Conversion" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  
  // Test Unit conversion
  inspect!(ast_to_knf(env, Unit), content="Unit")
  
  // Test Bool conversion
  inspect!(ast_to_knf(env, Bool(true)), content="Bool(true)")
  
  // Test Int conversion
  inspect!(ast_to_knf(env, Int(42)), content="Int(42)")
  
  // Test Double conversion
  inspect!(ast_to_knf(env, Double(3.14)), content="Double(3.14)")
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
  let new_syntax = syntax_preprocess(syntax, None)
  ast_to_knf(self, new_syntax)
}