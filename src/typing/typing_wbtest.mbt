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

test "cls-reg-bug" {
  let syntax: Syntax =
    LetRec({name: ("h", Fun([Tuple([Int, Int, Int, Int, Int, Int, Int, Int, Int, Int])], Int)), args: [("p", Tuple([Int, Int, Int, Int, Int, Int, Int, Int, Int, Int]))], body: LetTuple([("v1", Var({val: None})), ("v2", Var({val: None})), ("v3", Var({val: None})), ("v4", Var({val: None})), ("v5", Var({val: None})), ("v6", Var({val: None})), ("v7", Var({val: None})), ("v8", Var({val: None})), ("v9", Var({val: None})), ("v10", Var({val: None}))], Var("p"), LetRec({name: ("g", Fun([Int], Int)), args: [("z", Int)], body: Let(("r", Var({val: None})), Prim(Prim(Prim(Prim(Prim(Prim(Prim(Prim(Prim(Var("v1"), Var("v2"), Add, kind=None), Var("v3"), Add, kind=None), Var("v4"), Add, kind=None), Var("v5"), Add, kind=None), Var("v6"), Add, kind=None), Var("v7"), Add, kind=None), Var("v8"), Add, kind=None), Var("v9"), Add, kind=None), Var("v10"), Add, kind=None), If(Not(LE(Var("z"), Int(0))), Var("r"), App(Var("g"), [Neg(Var("z"), kind=None)])))}, App(Var("g"), [Int(1)])))}, LetRec({name: ("main", Fun([], Unit)), args: [], body: Let(("t1", Var({val: None})), App(Var("print_int"), [App(Var("h"), [Tuple([Int(1), Int(2), Int(3), Int(4), Int(5), Int(6), Int(7), Int(8), Int(9), Int(10)])])]), Unit)}, Unit))
  
  // println(show(infer?(@immut/hashmap.new(), syntax)))
  // topo_sort()
  let res = typing(syntax)
  // println(res)
  println(@json.stringify(res.to_json()))
}