Some(
  (
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
    Unit
  ), [])
)

