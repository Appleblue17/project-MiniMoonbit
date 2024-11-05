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
  // println(res)
  println(@json.stringify(res.to_json()))
}

test "adder" {
  let syntax: Syntax =
    LetRec({name: ("make_adder", Fun([Int], Fun([Int], Int))), args: [("x", Int)], body: 
      LetRec({name: ("adder", Fun([Int], Int)), args: [("y", Int)], body: 
        Prim(Var("x"), Var("y"), Add, kind=Some(@types.Kind::Int))
      }, 
      Var("adder"))
    }, 
    LetRec({name: ("main", Fun([], Unit)), args: [], body: 
      App(Var("print_int"), [App(App(Var("make_adder"), [Int(3)]), [Int(7)])])
    }, 
    Unit))
  // println(show(infer?(@immut/hashmap.new(), syntax)))
  // topo_sort()
  let res = typing(syntax)
  // println(res)
  println(@json.stringify(res.to_json()))
}