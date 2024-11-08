typealias Name = @types.Name
typealias Type = @types.Type
typealias Syntax = @types.Syntax

pub enum Knf {
  Unit
  Bool(Bool) // Bool modified
  Int(Int)
  Double(Double)
  Not(Name) // Bool modified
  Array(Name, Name) // Array::make modified
  Neg(Name) // Int
  Add(Name, Name)
  Sub(Name, Name)
  Mul(Name, Name)
  Div(Name, Name)
  FNeg(Name) // Float
  FAdd(Name, Name)
  FSub(Name, Name)
  FMul(Name, Name)
  FDiv(Name, Name)
  IfEq(Name, Name, Knf, Knf)
  IfLe(Name, Name, Knf, Knf)
  Let((Name, Type), Knf, Knf)
  Var(Name)
  LetRec(FuncDef, Knf)
  Apply(Name, Array[Name])
  Tuple(Array[Name])
  LetTuple(Array[(Name, Type)], Name, Knf)
  Get(Name, Name)
  Put(Name, Name, Name)
  ExternalArray(Name) // not used
  ExternalFunctionApplication(String, Array[Name])
} derive(Show, Eq)

pub struct FuncDef {
  name : Name
  ty : Type
  args : Array[(Name, Type)]
  body : Knf
} derive(Show, Eq)
