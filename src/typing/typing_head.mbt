typealias Token = @types.TOKEN
typealias Syntax = @types.Syntax
typealias Kind = @types.Kind
typealias Op = @types.Op
typealias Fundef = @types.Fundef
typealias Type = @types.Type

// Since the interface cannot be modified, I will use a copy (but modified a little) of it in the typing section.
pub enum MyType {
  Unit
  Bool
  Int
  Double
  Kind // Int or Double
  Fun(Array[InfType], InfType) // (_, _, _) -> _
  Tuple(Array[InfType]) // (_, _, _)
  Array(InfType) // Array[_]
}

struct InfType{
  typ: MyType?
  mut sol_typ: Type
  dsu_father: Ref[InfType?]
  father: Array[InfType]
  mut unsolved_number: Int
  mut link: Syntax // link to the original Syntax tree, only for Prim, Let, LetRec, LetTuple
  id: Int
}

////////////// used to debug //////////////
fn to_string(self: MyType) -> String{
  match self {
    Unit => "Unit"
    Bool => "Bool"
    Int => "Int"
    Double => "Double"
    Kind => "Kind"
    Fun(args, ret) => {
      let mut str = "Fun(["
      for i in 0 ..< args.length() {
        str += args[i].to_string()
        if i < args.length()-1 {
          str += ", "
        }
      }
      str+"], "+ret.to_string()+")"
    }
    Tuple(args) => {
      let mut str = "("
      for i in 0 ..< args.length() {
        str += args[i].to_string()
        if i < args.length()-1 {
          str += ", "
        }
      }
      str+")"
    }
    Array(arg) => "Array(" + arg.to_string() + ")"
  }
}
fn to_string(self: InfType) -> String{
  let str = "<"+self.id.to_string()+">"
  match self.typ {
    Some(t) => str+t.to_string()
    None => str+"?"
  }
}
////////////////////////////////////////////


// Root is the origin of InfType.
let inftype_root: InfType = {typ: Some(Unit), sol_typ: Unit, dsu_father: Ref::new(None), father: [], unsolved_number: 0, id: 0, link: Unit}
// Basic (not recursive) types can share the same address to save memory.
let inftype_Unit: InfType = InfType::new(Unit)
let inftype_Double: InfType = InfType::new(Double)
let inftype_Int: InfType = InfType::new(Int)
let inftype_Bool: InfType = InfType::new(Bool)

let node_list: Array[InfType] = []
fn InfType::new(typ: MyType, ~link: Syntax = Unit) -> InfType{
  let arg_count = match typ {
    Fun(args, _) => args.length()+1
    Tuple(elements) => elements.length()
    Array(_) => 1
    _ => 0
  }
  let x = {typ: Some(typ), sol_typ: Unit, dsu_father: Ref::new(Some(inftype_root)), father: [], unsolved_number: arg_count, id: node_list.length(), link}
  x.dsu_father.val = Some(x)
  node_list.push(x)
  x
}
fn InfType::new_tvar() -> InfType{
  let x = {typ: None, sol_typ: Unit, dsu_father: Ref::new(Some(inftype_root)), father: [], unsolved_number: 0, id: node_list.length(), link: Unit}
  x.dsu_father.val = Some(x)
  node_list.push(x)
  x
}
fn InfType::type2inf(ty: Type) -> InfType {
  match ty {
    Unit => inftype_Unit
    Bool => inftype_Bool
    Int => inftype_Int
    Double => inftype_Double
    Fun(args, ret) => 
      InfType::new(Fun(args.map( fn { arg => type2inf(arg) } ), type2inf(ret)))
    Tuple(elements) =>
      InfType::new(Tuple(elements.map( fn { element => type2inf(element) } )))
    Array(ty) => InfType::new(Array(type2inf(ty)))
    _ => InfType::new_tvar()
  }
}