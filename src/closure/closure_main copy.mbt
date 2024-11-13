// pub fn knf_program_to_closure(
//   prog : Knf,
//   extern_env : Map[String, Type] // not used
// ) -> Program {
//   global_closure.clear()
//   let body = knf_to_closure(LocalEnv::new(), prog)
//   { fundefs: global_closure, body }
// }

// fn type2lowtype(ty: Type) -> LowType {
//   match ty {
//     Unit => Unit
//     Bool => Bool
//     Int => Int
//     Double => Double
//     Tuple(ts) => Tuple(ts.map(type2lowtype))
//     Array(t) => Array(type2lowtype(t))
//     Fun(args, ret) => ClosureFn(args.map(type2lowtype), type2lowtype(ret))
//     Var( {val: Some(t)} ) => type2lowtype(t)
//     Var( {val: None} ) => Unit // for test only
//     _ => @util.die("Closure Error: type not supported. \{ty}")
//   }
// }

// typealias Set = @immut/hashset.T[Name]
// fn union(a: Set, b: Set) -> Set {
//   let mut res = a
//   for x in b {
//     res = res.add(x)
//   }
//   res
// }
// fn get_fv(e: Knf) -> Set{
//   match e {
//     Unit | Bool(_) | Int(_) | Double(_) => Set::new()
//     Not(x) | Neg(x) | Var(x)=> Set::of([x])
//     Array(x, y) => Set::of([x, y])
//     Add(a, b) | Sub(a, b) | Mul(a, b) | Div(a, b) | 
//       FAdd(a, b) | FSub(a, b) | FMul(a, b) | FDiv(a, b) => Set::of([a, b])
//     IfEq(a, b, e1, e2) | IfLe(a, b, e1, e2)=> {
//       union(get_fv(e1), get_fv(e2)).remove(a).remove(b)
//     }
//     Let( (x, _), e, rest) => {
//       union(get_fv(e), get_fv(rest)).remove(x)
//     }
//     LetRec( {name: f, args, body, ..}, rest ) => {
//       let mut fv = union(get_fv(body), get_fv(rest)).remove(f)
//       for arg in args { fv = fv.remove(arg.0) }
//       fv
//     }
//     Apply(f, args) => union(Set::from_array(args), Set::of([f]))
//     Tuple(xs) => Set::from_array(xs)
//     LetTuple(xs, e, rest) => {
//       let mut fv = union(get_fv(rest), get_fv(e))
//       for x in xs { fv = fv.remove(x.0) }
//       fv
//     }
//     Get(x, y) => Set::of([x, y])
//     Put(x, y, z, rest) => union(Set::of([x, y, z]), get_fv(rest))
//     ExternalFunctionApplication(_, args) => Set::from_array(args)
//     _ => @util.die("Closure Error: get_fv not supported.")
//   }
// }

// let global_closure: Array[FuncDef] = []
// typealias LocalEnv = @immut/hashmap.T[Name, LowType]
// fn knf_to_closure(
//   ctx: LocalEnv,
//   knf : Knf
// ) -> Expr {
//   match knf {
//     Unit => Unit
//     Bool(b) => Bool(b)
//     Int(i) => Int(i)
//     Double(d) => Double(d)
//     Not(x) => Not(x)
//     Neg(x) => Neg(x)
//     Array(x, y) => MakeArray(x, y)
//     Add(x, y) => Add(x, y)
//     Sub(x, y) => Sub(x, y)
//     Mul(x, y) => Mul(x, y)
//     Div(x, y) => Div(x, y)
//     FNeg(x) => FNeg(x)
//     FAdd(x, y) => FAdd(x, y)
//     FSub(x, y) => FSub(x, y)
//     FMul(x, y) => FMul(x, y)
//     FDiv(x, y) => FDiv(x, y)
//     IfEq(x, y, e1, e2) => {
//       IfEq(x, y, knf_to_closure(ctx, e1), knf_to_closure(ctx, e2))
//     }
//     IfLe(x, y, e1, e2) => {
//       IfLe(x, y, knf_to_closure(ctx, e1), knf_to_closure(ctx, e2))
//     }
//     Let((x, ty), e1, e2) => {
//       let new_ctx = ctx.add(x, type2lowtype(ty))
//       Let((x, type2lowtype(ty)), knf_to_closure(ctx, e1), knf_to_closure(new_ctx, e2))
//     }
//     Var(x) => Var(x)
//     LetRec( {name: f, ty, args, body}, rest ) => {
//       let fv = get_fv(knf)
      
//       let ty = 
//         if fv.size() == 0 { match ty { Fun(args, ret) => DirectFn(args.map(type2lowtype), type2lowtype(ret)) } }
//         else { match ty { Fun(args, ret) => ClosureFn(args.map(type2lowtype), type2lowtype(ret)) } }
      
//       let ctx_with_f = ctx.add(f, ty)
//       let mut new_ctx = ctx_with_f
//       for x in args {
//         new_ctx = new_ctx.add(x.0, type2lowtype(x.1))
//       }
      
//       if fv.size() == 0 {
//         global_closure.push(
//           FuncDef::{ name: f.to_string(),
//             old_name: f,
//             is_closure: false,
//             ty,
//             args: args.map( fn { (name, ty) => (name, type2lowtype(ty)) }),
//             formal_free_vars: [],
//             body: knf_to_closure(new_ctx, body)
//           }
//         )
        
//         knf_to_closure(ctx_with_f, rest)
//       }
//       else {
//         let free_vars = []
//         for x in fv { free_vars.push(x) }
//         global_closure.push(
//           FuncDef::{ name: f.to_string(),
//             old_name: f,
//             is_closure: true,
//             ty,
//             args: args.map( fn { (name, ty) => (name, type2lowtype(ty)) }),
//             formal_free_vars: free_vars.map( fn { name => (name, ctx.find(name).unwrap()) }),
//             body: knf_to_closure(new_ctx, body)
//           }
//         )
//         MakeClosure(
//           (f, ty),
//           { name: f.to_string(), actual_free_vars: free_vars },
//           knf_to_closure(ctx_with_f, rest) )
//       }
//     }
//     Apply(f, args) => {
//       let func = ctx.find(f).unwrap()
//       match func {
//         ClosureFn(_, _) => CallClosure(f, args)
//         DirectFn(_, _) => CallDirect(f.to_string(), args)
//         _ => @util.die("Closure Error: Apply not supported.")
//       }
//     }
//     Tuple(xs) => MakeTuple(xs)
//     LetTuple(xs, y, e) => {
//       let mut new_ctx = ctx
//       for x in xs {
//         new_ctx = new_ctx.add(x.0, type2lowtype(x.1))
//       }
//       LetTuple(xs.map( fn { (name, ty) => (name, type2lowtype(ty)) }),
//         knf_to_closure(ctx, y), knf_to_closure(new_ctx, e))
//     }
//     Get(x, y) => ArrayGet(x, y)
//     Put(x, y, z, w) => ArrayPut(x, y, z, knf_to_closure(ctx, w))
//     ExternalFunctionApplication(name, args) => {
//       CallDirect(name, args)
//     }
//     _ => @util.die("Closure Error: knf_to_closure not supported.")
//   }
// }
// test "knf_to_closure letrec" {
//   inspect!(knf_to_closure( LocalEnv::new(), 
//     Let( (Name::name_only("x"), Type::Int), Int(3), 
//       LetRec( {
//         name: Name::name_only("f"), 
//         ty: Fun([Int], Int),
//         args: [(Name::name_only("n"), Int)], 
//         body: Add(Name::name_only("x"), Name::name_only("n"))},
//         Unit
//       )))
//   , content=
//     #|Let((x, Int), Int(3), MakeClosure((f, ClosureFn([Int], Int)), {name: Label("f"), actual_free_vars: [x]}, Unit))
//   )
// }
