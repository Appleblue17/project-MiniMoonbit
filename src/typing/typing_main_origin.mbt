
// fn repr(ty: Type) -> Type {
//   match ty {
//     Var({val: Some(ty)}) as tvar => {
//       let actual_ty = repr(ty)
//       tvar.modify(Some(actual_ty))
//       actual_ty
//     }
//     ty => ty
//   }
// }

// /// Check if the rucursive definition of ty includes tvar.
// /// Note that tvar is unknown so far, and we are going to let tvar -> Var(ty).
// fn check_occur(tvar: Type, ty: Type) -> Unit!TypeErr {
//   let ty = repr(ty)
//   if physical_equal(tvar, ty) {
//     raise TypeErr("Type error: self-reference occurs.")
//   }
//   match ty {
//     Unit | Bool | Int | Double => return
//     Fun(args, ty) => {
//       for arg in args { check_occur!(tvar, arg) }
//       check_occur!(tvar, ty)
//     }
//     Tuple(elements) =>{
//       for element in elements { check_occur!(tvar, element) }
//     }
//     Array(ty) => check_occur!(tvar, ty)
//     ..
//   }
// }

// fn unify(t1: Type, t2: Type) -> Unit!TypeErr {
//   let t1 = repr(t1)
//   let t2 = repr(t2)
//   if physical_equal(t1, t2) { return }
//   match (t1, t2) {
//     (Unit, Unit) | (Bool, Bool) | (Int, Int) | (Double, Double) 
//       | (Kind, Int) | (Int, Kind) | (Kind, Double)| (Double, Kind) => return
//     (Fun(args1, t1), Fun(args2, t2)) => {
//       let length = args1.length();
//       guard args2.length() == length else {
//         raise TypeErr("Type error: Function args length not match.")
//       }
//       for i in 0 ..< length { unify!(args1[i],args2[i]) }
//       unify!(t1, t2)
//     }
//     (Tuple(list1), Tuple(list2)) => {
//       let length = list1.length();
//       guard(list2.length() != length) else { 
//         raise TypeErr("Type error: Tuple element length not match.")
//       }
//       for i in 0 ..< length { unify!(list1[i],list2[i]) }
//     }
//     (Array(t1), Array(t2)) => { unify!(t1, t2) }
//     (Var({val: None}) as tvar, ty) | (ty, Var({val: None}) as tvar) => {
//       check_occur!(tvar, ty)
//       tvar.modify(Some(ty))
//     }
//     _ => raise TypeErr("Type error: type not match.")
//   }
// }

// pub let extenv : Map[String, @types.Type] = {
//   // 输入输出函数
//   "read_int": Fun([], Int),
//   "print_int": Fun([Int], Unit),
//   "read_char": Fun([], Int),
//   "print_char": Fun([Int], Unit),
//   "print_newline": Fun([], Unit),
//   // 数学函数
//   "int_of_float": Fun([Double], Int),
//   "float_of_int": Fun([Int], Double),
//   "truncate": Fun([Double], Int),
//   "floor": Fun([Double], Double),
//   "abs_float": Fun([Double], Double),
//   "sqrt": Fun([Double], Double),
//   "sin": Fun([Double], Double),
//   "cos": Fun([Double], Double),
//   "atan": Fun([Double], Double),
// }

// typealias LocalCtx = @immut/hashmap.T[String, Type]


// /// This infer function is only for **nontop** syntax.
// /// @TODO For top functions & variables, it need to be added to extenv initially in the entry function.
// /// @TODO Kind need to be decided to be Int or Double in deref and sync to syntax.
// fn infer(ctx : LocalCtx, e : Syntax) -> Type!TypeErr {
//   match e {
//     Bool(_) => Bool
//     Int(_) => Int
//     Double(_) => Double
//     Var(x) => {
//       match ctx[x] {
//         Some(t) => t
//         None =>{
//           match extenv[x] {
//             Some(t) => t
//             None => { raise TypeErr("Type error: function/variable not bounded.") }
//             // For nontop syntax, it's not allowed to use before declaration.
//           }
//         }
//       }
//     }
//     Tuple(elements) => {
//       let elements_ty = []
//       for element in elements {
//         elements_ty.push(infer!(ctx, element))
//       }
//       Tuple(elements_ty)
//     }
//     Not(ty) => {
//       let ty = infer!(ctx, ty)
//       unify!(ty, Bool)
//       ty
//     }
//     Array(x, num) => {
//       let ty = infer!(ctx, x)
//       let num_ty = infer!(ctx, num)
//       unify!(num_ty, Int)
//       ty
//     }
//     Neg(x, ..)=> {
//       let ty = infer!(ctx, x)
//       unify!(ty, Kind)
//       ty
//     }
//     App(f, args) => {
//       let ret_ty = @types.new_tvar()
//       let f_ty = infer!(ctx, f)
//       let args_ty = []
//       for arg in args {
//         args_ty.push(infer!(ctx, arg))
//       }
//       unify!(f_ty, Fun(args_ty, ret_ty))
//       ret_ty
//     }
//     Get(f, index) => {
//       let ret_ty = @types.new_tvar()
//       let f_ty = infer!(ctx, f)
//       let index_ty = infer!(ctx, index)
//       unify!(index_ty, Int)
//       unify!(f_ty, Array(ret_ty))
//       ret_ty
//     }
//     If(expr, expr_if, expr_else) => {
//       let expr_ty = infer!(ctx, expr)
//       unify!(expr_ty, Bool)
//       let expr_if_ty = infer!(ctx, expr_if)
//       let expr_else_ty = infer!(ctx, expr_else)
//       unify!(expr_if_ty, expr_else_ty)
//       expr_if_ty
//     }
//     Prim(expr1, expr2, _, ..) => {
//       let expr1_ty = infer!(ctx, expr1)
//       let expr2_ty = infer!(ctx, expr2)
//       unify!(expr1_ty, Kind)
//       unify!(expr2_ty, expr1_ty)
//       expr1_ty
//     }
//     Eq(expr1, expr2) | LE(expr1, expr2)=> {
//       let expr1_ty = infer!(ctx, expr1)
//       let expr2_ty = infer!(ctx, expr2)
//       unify!(expr2_ty, expr1_ty)
//       expr1_ty
//     }
//     Let((f, t), expr, rest) => {
//       let env_with_f = ctx.add(f, t)
//       let expr_ty = infer!(ctx, expr)
//       unify!(t, expr_ty)
//       infer!(env_with_f, rest)
//     }
//     LetRec({ name: (f, t), args, body }, rest) => {
//       let env_with_f = ctx.add(f, t)
//       let args_ty = args.map(fn { (_, t) => t })
//       let mut env_with_params = env_with_f
//       for arg in args {
//         env_with_params = env_with_params.add(arg.0, arg.1)
//       }
//       let body_ty = infer!(env_with_params, body)
//       unify!(t, Fun(args_ty, body_ty))
//       infer!(env_with_f, rest)
//     }
//     LetTuple(elements, expr, rest) => {
//       // It's guaranteed that the length of elements and values are equal in parsing section.
//       let mut env_with_elements = ctx
//       let length = elements.length()
//       let elements_ty = elements.map( fn { (_,t) => t } )
//       for i in 0 ..< length {
//         env_with_elements = env_with_elements.add(elements[i].0, elements[i].1)
//       }
//       let expr_ty = infer!(ctx, expr)
//       unify!(Tuple(elements_ty), expr_ty)
//       infer!(env_with_elements, rest)
//     }
//     Put(var, expr, rest) => {
//       let var_ty = infer!(ctx, var)
//       let expr_ty = infer!(ctx, expr)
//       unify!(var_ty, expr_ty)
//       infer!(ctx, rest)
//     }
    
//   }
// }


// fn deref_type(t : Type) -> Type!TypeErr {
//   match t {
//     Fun(params, result) => {
//       let params_ty = []
//       for param in params {
//         params_ty.push(deref_type!(param))
//       }
//       Fun(params_ty, deref_type!(result))
//     }
//     Tuple(elements) => {
//       let elements_ty = []
//       for element in elements {
//         elements_ty.push(deref_type!(element))
//       }
//       Tuple(elements_ty)
//     }
//     Array(t) => Array(deref_type!(t))
//     Var({val: Some(t)}) as tvar => {
//       let t = deref_type!(t)
//       tvar.modify(Some(t))
//       t
//     }
//     Var({val: None}) as tvar => {
//       raise TypeErr("Type error: cannot infer type.")
//     }
//     t => t
//   }
// }


// pub fn typing(e : Syntax) -> Syntax!TypeErr {
//   unify!(Unit, infer!(@immut/hashmap.new(), e))
//   for ext_f, ext_t in extenv {
//     extenv[ext_f] = deref_type(ext_t)
//   }
//   deref(e)
// }
