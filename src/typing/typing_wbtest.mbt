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

test "matmul" {
  let syntax: Syntax =
    LetRec({name: ("matmul", Fun([Int, Int, Int, Array(Array(Double)), Array(Array(Double)), Array(Array(Double))], Unit)), args: [("l", Int), ("m", Int), ("n", Int), ("a", Array(Array(Double))), ("b", Array(Array(Double))), ("c", Array(Array(Double)))], body: LetRec({name: ("loop1", Fun([Int], Unit)), args: [("i", Int)], body: If(LE(Int(0), Var("i")), LetRec({name: ("loop2", Fun([Int], Unit)), args: [("j", Int)], body: If(LE(Int(0), Var("j")), LetRec({name: ("loop3", Fun([Int], Unit)), args: [("k", Int)], body: If(LE(Int(0), Var("k")), Put(Get(Get(Var("c"), Var("i")), Var("j")), Prim(Get(Get(Var("c"), Var("i")), Var("j")), Prim(Get(Get(Var("a"), Var("i")), Var("k")), Get(Get(Var("b"), Var("k")), Var("j")), Mul, kind=None), Add, kind=None), App(Var("loop3"), [Prim(Var("k"), Int(1), Sub, kind=None)])), Unit)}, Let(("_", Var({val: None})), App(Var("loop3"), [Prim(Var("m"), Int(1), Sub, kind=None)]), App(Var("loop2"), [Prim(Var("j"), Int(1), Sub, kind=None)]))), Unit)}, Let(("_", Var({val: None})), App(Var("loop2"), [Prim(Var("n"), Int(1), Sub, kind=None)]), App(Var("loop1"), [Prim(Var("i"), Int(1), Sub, kind=None)]))), Unit)}, App(Var("loop1"), [Prim(Var("l"), Int(1), Sub, kind=None)]))}, LetRec({name: ("main", Fun([], Unit)), args: [], body: Let(("dummy", Var({val: None})), Array(Int(0), Double(0)), LetRec({name: ("gen_arr", Fun([Int, Int], Array(Array(Double)))), args: [("m", Int), ("n", Int)], body: Let(("mat", Var({val: None})), Array(Var("m"), Var("dummy")), LetRec({name: ("init_arr", Fun([Int], Unit)), args: [("i", Int)], body: If(LE(Int(0), Var("i")), Put(Get(Var("mat"), Var("i")), Array(Var("n"), Double(0)), App(Var("init_arr"), [Prim(Var("i"), Int(1), Sub, kind=None)])), Unit)}, Let(("_", Var({val: None})), App(Var("init_arr"), [Prim(Var("m"), Int(1), Sub, kind=None)]), Var("mat"))))}, Let(("a", Var({val: None})), App(Var("gen_arr"), [Int(2), Int(3)]), Let(("b", Var({val: None})), App(Var("gen_arr"), [Int(3), Int(2)]), Let(("c", Var({val: None})), App(Var("gen_arr"), [Int(2), Int(2)]), Put(Get(Get(Var("a"), Int(0)), Int(0)), Double(1), Put(Get(Get(Var("a"), Int(0)), Int(1)), Double(2), Put(Get(Get(Var("a"), Int(0)), Int(2)), Double(3), Put(Get(Get(Var("a"), Int(1)), Int(0)), Double(4), Put(Get(Get(Var("a"), Int(1)), Int(1)), Double(5), Put(Get(Get(Var("a"), Int(1)), Int(2)), Double(6), Put(Get(Get(Var("b"), Int(0)), Int(0)), Double(7), Put(Get(Get(Var("b"), Int(0)), Int(1)), Double(8), Put(Get(Get(Var("b"), Int(1)), Int(0)), Double(9), Put(Get(Get(Var("b"), Int(1)), Int(1)), Double(10), Put(Get(Get(Var("b"), Int(2)), Int(0)), Double(11), Put(Get(Get(Var("b"), Int(2)), Int(1)), Double(12), Let(("_", Var({val: None})), App(Var("matmul"), [Int(2), Int(3), Int(2), Var("a"), Var("b"), Var("c")]), Let(("_", Var({val: None})), App(Var("print_int"), [App(Var("truncate"), [Get(Get(Var("c"), Int(0)), Int(0))])]), Let(("_", Var({val: None})), App(Var("print_endline"), []), Let(("_", Var({val: None})), App(Var("print_int"), [App(Var("truncate"), [Get(Get(Var("c"), Int(0)), Int(1))])]), Let(("_", Var({val: None})), App(Var("print_endline"), []), Let(("_", Var({val: None})), App(Var("print_int"), [App(Var("truncate"), [Get(Get(Var("c"), Int(1)), Int(0))])]), Let(("_", Var({val: None})), App(Var("print_endline"), []), Let(("_", Var({val: None})), App(Var("print_int"), [App(Var("truncate"), [Get(Get(Var("c"), Int(1)), Int(1))])]), Unit)))))))))))))))))))))))))}, Unit))
  
  // println(show(infer?(@immut/hashmap.new(), syntax)))
  // topo_sort()
  let res = typing(syntax)
  // println(res)
  println(@json.stringify(res.to_json()))
}
