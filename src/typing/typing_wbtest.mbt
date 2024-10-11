test "if_else test" {
  let syntax: Syntax =
    If(Bool(true), Int(1), Int(0))
  // println(show(infer?(@immut/hashmap.new(), syntax)))
  // topo_sort()
  let res = typing(syntax)
  println(res)
}
test "ex_frac_mini" {
  // fn frac(n: ?) -> ? {
  //  if n == 1 {
  //    1
  //  } else {
  //    frac(n - 1) * n
  //  }
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
  // println(show(infer?(@immut/hashmap.new(), syntax)))
  // topo_sort()
  let res = typing(syntax)
  println(res)
}
test "ex_frac" {
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
  // println(show(infer?(@immut/hashmap.new(), syntax)))
  // topo_sort()
  let res = typing(syntax)
  println(res)
}