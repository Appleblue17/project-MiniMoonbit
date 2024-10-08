fn repr(self: Type) -> Type {
  match self {
    Var(~t = Some(ty)) as tvar => {
      let actual_ty = ty.repr()
      tvar.t = Some(actual_ty)
      actual_ty
    }
    ty => ty
  }
}

fn unify(t Ty, t Ty) -> Unit!TyErr {
  let t= trepr()
  let t= trepr()
  if physical_equal(t t { return }
  match (t t {
    (Int, Int) | (Bool, Bool) => ()
    (TVar(~t=None) as tvar, ty) | (ty, TVar(~t=None) as tvar) => {
      check_occur!(tvar, ty)
      tvar.t = Some(ty)
    }
    .. // handle the function, tuple, and array type  
    _ => raise TyErr
  }
}


pub let extenv : Map[String, @types.Type] = { 
  "print_int": Fun([Int], Unit),
  "print_char": Fun([Int], Unit),
  ..
}
struct LocalCtx @immut/hashmap.T[String, Ty]

fn infer(ctx : LocalCtx, e : Syntax) -> Type!TyErr {
  match e {
    Int(_) => Int; Bool(_) => Bool
    Var(x) =>
      match ctx._[x] {
        Some(t) => t
        None =>
          match extenv[x] {
            Some(t) => t
            None => {
              let t = new_tvar()
              extenv[x] = t
              t
            }
          }
      }
    
    LetRec({ name: (f, t), params, body }, rest) => {
      let env_with_f = ctx._.insert(f, t)
      let params_ty = params.map(fn { (_, t) => t })
      let mut env_with_params = env_with_f
      for p in params {
        env_with_params = env_with_params.insert(p. p.
      }
      let body_ty = infer!(env_with_params, body)
      unify!(t, Fun(params_ty, body_ty))
      infer!(env_with_f, rest)
    }
    
    App(f, args) => {
      let ret_ty = new_tvar()
      let f_ty = infer!(ctx, f)
      let args_ty = []
      for a in args {
        args_ty.push(infer!(ctx, a))
      }
      unify!(f_ty, Fun(args_ty, ret_ty))
      ret_ty
    }
    
    ...
  }
}




fn deref_type(t : Type) -> Type {
  match t {
    Fun(params, result) =>
    Fun(params.map(fn { t => deref_type(t) }), deref_type(result))
    Tuple(types) => Tuple(types.map(fn { t => deref_type(t) }))
    Array(t) => Array(deref_type(t))
    Var(~t = Some(t)) as tvar => {
      let t = deref_type(t)
      tvar.t = Some(t)
      t
    }
    Var(~t = None) as tvar => {
      tvar.t = Some(Unit)
      Unit
    }
    t => t
  }
}
 
fn deref_term(syntax : Syntax) -> Syntax { .. }

pub fn typing(e : Syntax) -> Syntax!TyErr {
  unify!(Unit, infer!(@immut/sorted_map.empty(), e))
  for ext_f, ext_t in extenv {
    extenv[ext_f] = deref_type(ext_t)
  }
  deref_term(e)
}
