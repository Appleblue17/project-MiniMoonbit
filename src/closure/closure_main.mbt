// typealias LocalEnv = @immut/hashmap.T[Name, LowType]

fn type2lowtype(ty: Type) -> LowType {
  match ty {
    Unit => Unit
    Bool => Bool
    Int => Int
    Double => Double
    Fun(args, ret) => ClosureFn(args.map(type2lowtype), type2lowtype(ret))
    Tuple(ts) => Tuple(ts.map(type2lowtype))
    Array(t) => Array(type2lowtype(t))
    Var( {val: Some(t)} ) => type2lowtype(t)
    _ => abort("Closure Error: type not supported.")
  }
}

fn get_fv(e: Knf) -> Set[Name] {
  match e {
    Unit | Bool(_) | Int(_) | Double(_) => Set::new()
    Not(x) | Neg(x) | Var(x)=> Set::of([x])
    Array(x, y) => Set::of([x, y])
    Add(a, b) | Sub(a, b) | Mul(a, b) | Div(a, b) | 
      FAdd(a, b) | FSub(a, b) | FMul(a, b) | FDiv(a, b) => Set::of([a, b])
    IfEq(a, b, e1, e2) | IfLe(a, b, e1, e2)=> {
      let fv=union(get_fv(e1), get_fv(e2))
      fv.insert(a)
      fv.insert(b)
      fv
    }
    Let( (x, _), e, rest) => {
      let fv = union(get_fv(e), get_fv(rest))
      fv.remove(x)
      fv
    }
    LetRec( {name: f, args, body, ..}, rest ) => {
      let fv = union(get_fv(body), get_fv(rest))
      fv.remove(f)
      for arg in args { fv.remove(arg.0) }
      fv
    }
    Apply(f, args) => union(Set::from_array(args), Set::of([f]))
    Tuple(xs) => Set::from_array(xs)
    Get(x, y) => Set::of([x, y])
    Put(x, y, z) => Set::of([x, y, z])
    ExternalFunctionApplication(_, args) => Set::from_array(args)
    _ => abort("Closure Error: get_fv not supported.")
  }
}

let gloabal_closure: Array[FuncDef] = []
fn knf_to_closure(
  knf : Knf,
) -> Expr {
  match knf {
    Unit => Unit
    Bool(b) => Bool(b)
    Int(i) => Int(i)
    Double(d) => Double(d)
    Not(x) => Not(x)
    Neg(x) => Neg(x)
    Array(x, y) => MakeArray(x, y)
    Add(x, y) => Add(x, y)
    Sub(x, y) => Sub(x, y)
    Mul(x, y) => Mul(x, y)
    Div(x, y) => Div(x, y)
    FNeg(x) => FNeg(x)
    FAdd(x, y) => FAdd(x, y)
    FSub(x, y) => FSub(x, y)
    FMul(x, y) => FMul(x, y)
    FDiv(x, y) => FDiv(x, y)
    IfEq(x, y, e1, e2) => {
      IfEq(x, y, knf_to_closure(e1), knf_to_closure(e2))
    }
    IfLe(x, y, e1, e2) => {
      IfLe(x, y, knf_to_closure(e1), knf_to_closure(e2))
    }
    Let((x, ty), e1, e2) => {
      Let((x, type2lowtype(ty)), knf_to_closure(e1), knf_to_closure(e2))
    }
    Var(x) => Var(x)
    LetRec( {name: f, ty, args, body}, rest ) => {
      let free_vars = get_fv(knf).to_array()
      gloabal_closure.push(
        FuncDef::{ name: f.to_string(),
          old_name: f,
          is_closure: true,
          ty: type2lowtype(ty),
          args: args.map( fn { (name, ty) => (name, type2lowtype(ty)) }),
          formal_free_vars: free_vars.map( fn { (name) => (name, Unit) }),
          body: knf_to_closure(body)
        }
      )
      MakeClosure(
          (f, type2lowtype(ty)), 
          { name: f.to_string(), actual_free_vars: free_vars },
          knf_to_closure(rest) )
    }
    Apply(f, args) => {
      CallClosure(f, args)
    }
    Tuple(xs) => MakeTuple(xs)
    LetTuple(xs, y, e) => {
      LetTuple(xs.map( fn { (name, ty) => (name, type2lowtype(ty)) }),
        y, knf_to_closure(e))
    }
    Get(x, y) => ArrayGet(x, y)
    Put(x, y, z) => ArrayPut(x, y, z)
    ExternalFunctionApplication(name, args) => {
      CallDirect(name, args)
    }
  }
}

pub fn knf_program_to_closure(
  prog : Knf,
  extern_env : Map[String, Type]
) -> Program {
  gloabal_closure.clear()
  let body = knf_to_closure(prog)
  { fundefs: gloabal_closure, body }
}
