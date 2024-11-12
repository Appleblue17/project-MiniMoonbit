// typealias LocalEnv = @immut/hashmap.T[Name, LowType]

fn type2lowtype(ty: Type) -> LowType {
  match ty {
    Unit => Unit
    Bool => Bool
    Int => Int
    Double => Double
    Fun(args, ret) => DirectFn(args.map(type2lowtype), type2lowtype(ret))
    Tuple(ts) => Tuple(ts.map(type2lowtype))
    Array(t) => Array(type2lowtype(t))
    Var( {val: Some(t)} ) => type2lowtype(t)
    Var( {val: None} ) => Unit // for test only
    _ => @util.die("Closure Error: type not supported.")
  }
}

typealias Set = @immut/hashset.T[Name]
fn union(a: Set, b: Set) -> Set {
  let mut res = a
  for x in b {
    res = res.add(x)
  }
  res
}
fn get_fv(e: Knf) -> Set{
  match e {
    Unit | Bool(_) | Int(_) | Double(_) => Set::new()
    Not(x) | Neg(x) | Var(x)=> Set::of([x])
    Array(x, y) => Set::of([x, y])
    Add(a, b) | Sub(a, b) | Mul(a, b) | Div(a, b) | 
      FAdd(a, b) | FSub(a, b) | FMul(a, b) | FDiv(a, b) => Set::of([a, b])
    IfEq(a, b, e1, e2) | IfLe(a, b, e1, e2)=> {
      union(get_fv(e1), get_fv(e2)).remove(a).remove(b)
    }
    Let( (x, _), e, rest) => {
      union(get_fv(e), get_fv(rest)).remove(x)
    }
    LetRec( {name: f, args, body, ..}, rest ) => {
      let mut fv = union(get_fv(body), get_fv(rest)).remove(f)
      for arg in args { fv = fv.remove(arg.0) }
      fv
    }
    Apply(f, args) => union(Set::from_array(args), Set::of([f]))
    Tuple(xs) => Set::from_array(xs)
    LetTuple(xs, e, rest) => {
      let mut fv = union(get_fv(rest), get_fv(e))
      for x in xs { fv = fv.remove(x.0) }
      fv
    }
    Get(x, y) => Set::of([x, y])
    Put(x, y, z, rest) => union(Set::of([x, y, z]), get_fv(rest))
    ExternalFunctionApplication(_, args) => Set::from_array(args)
    _ => @util.die("Closure Error: get_fv not supported.")
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
      let fv = get_fv(knf)
      let free_vars = []
      for x in fv {
        free_vars.push(x)
      }
      gloabal_closure.push(
        FuncDef::{ name: f.to_string(),
          old_name: f,
          is_closure: true,
          ty: type2lowtype(ty),
          args: args.map( fn { (name, ty) => (name, type2lowtype(ty)) }),
          formal_free_vars: free_vars.map( fn { (name) => (name, LowType::Unit) }),
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
        knf_to_closure(y), knf_to_closure(e))
    }
    Get(x, y) => ArrayGet(x, y)
    Put(x, y, z, w) => ArrayPut(x, y, z, knf_to_closure(w))
    ExternalFunctionApplication(name, args) => {
      CallDirect(name, args)
    }
    _ => @util.die("Closure Error: knf_to_closure not supported.")
  }
}
test "knf_to_closure letrec" {
  inspect!(knf_to_closure(
    Let( (Name::name_only("x"), Type::Int), Int(3), 
      LetRec( {
        name: Name::name_only("f"), 
        ty: Fun([Int], Int),
        args: [(Name::name_only("n"), Int)], 
        body: Add(Name::name_only("x"), Name::name_only("n"))},
        Unit
      )))
  , content=
    #|Let((x, Int), Int(3), MakeClosure((f, DirectFn([Int], Int)), {name: Label("f"), actual_free_vars: [x]}, Unit))
  )
}
test "knf_to_closure edge cases" {
  inspect!(knf_to_closure(IfEq(Name::name_only("x"), Name::name_only("y"), Unit, Unit)), content="IfEq(x, y, Unit, Unit)")
  inspect!(knf_to_closure(IfLe(Name::name_only("x"), Name::name_only("y"), Unit, Unit)), content="IfLe(x, y, Unit, Unit)")
  inspect!(knf_to_closure(Let((Name::name_only("x"), Type::Int), Unit, Unit)), content="Let((x, Int), Unit, Unit)")
  inspect!(knf_to_closure(Var(Name::name_only("x"))), content="Var(x)")
  inspect!(knf_to_closure(Tuple([Name::name_only("x"), Name::name_only("y")])), content="MakeTuple([x, y])")
  inspect!(knf_to_closure(LetTuple([(Name::name_only("x"), Type::Int)], Knf::Int(5), Unit)), content="LetTuple([(x, Int)], Int(5), Unit)")
  inspect!(knf_to_closure(Get(Name::name_only("x"), Name::name_only("y"))), content="ArrayGet(x, y)")
  inspect!(knf_to_closure(Put(Name::name_only("x"), Name::name_only("y"), Name::name_only("z"), Knf::Unit)), content="ArrayPut(x, y, z, Unit)")
}

test "knf_to_closure random cases" {
  inspect!(knf_to_closure(Add(Name::name_only("x"), Name::name_only("y"))), content="Add(x, y)")
  inspect!(knf_to_closure(Sub(Name::name_only("x"), Name::name_only("y"))), content="Sub(x, y)")
  inspect!(knf_to_closure(Mul(Name::name_only("x"), Name::name_only("y"))), content="Mul(x, y)")
  inspect!(knf_to_closure(Div(Name::name_only("x"), Name::name_only("y"))), content="Div(x, y)")
  inspect!(knf_to_closure(FNeg(Name::name_only("x"))), content="FNeg(x)")
  inspect!(knf_to_closure(FAdd(Name::name_only("x"), Name::name_only("y"))), content="FAdd(x, y)")
  inspect!(knf_to_closure(FSub(Name::name_only("x"), Name::name_only("y"))), content="FSub(x, y)")
  inspect!(knf_to_closure(FMul(Name::name_only("x"), Name::name_only("y"))), content="FMul(x, y)")
  inspect!(knf_to_closure(FDiv(Name::name_only("x"), Name::name_only("y"))), content="FDiv(x, y)")
  inspect!(knf_to_closure(Apply(Name::name_only("f"), [Name::name_only("x"), Name::name_only("y")])), content="CallClosure(f, [x, y])")
  inspect!(knf_to_closure(ExternalFunctionApplication("external_func", [Name::name_only("x"), Name::name_only("y")])), content=
    #|CallDirect(Label("external_func"), [x, y])
  )
}

test "knf_to_closure basic functionality" {
  inspect!(knf_to_closure(Unit), content="Unit")
  inspect!(knf_to_closure(Bool(true)), content="Bool(true)")
  inspect!(knf_to_closure(Int(42)), content="Int(42)")
  inspect!(knf_to_closure(Double(3.14)), content="Double(3.14)")
  inspect!(knf_to_closure(Not(Name::name_only("x"))), content="Not(x)")
  inspect!(knf_to_closure(Neg(Name::name_only("x"))), content="Neg(x)")
  inspect!(knf_to_closure(Array(Name::name_only("x"), Name::name_only("y"))), content="MakeArray(x, y)")
}

pub fn knf_program_to_closure(
  prog : Knf,
  extern_env : Map[String, Type] // not used
) -> Program {
  gloabal_closure.clear()
  let body = knf_to_closure(prog)
  { fundefs: gloabal_closure, body }
}
