Some(
  (
    LetRec({name: ("fib", Int), args: [("n", Int)], body: 
      If(LE(Var("n"), Int(1)), 
        Var("n"),
        Prim(
          App(Var("fib"), [Prim(Var("n"), Int(1), Sub, kind=None)]), 
          App(Var("fib"), [Prim(Var("n"), Int(2), Sub, kind=None)]), 
          Add, 
          kind=None
        )
      )
    }, 
    LetRec({name: ("main", Fun([], Unit)), args: [], body: 
      App(Var("print_int"), [App(Var("fib"), [Int(30)])])
    }), 
    Unit
  ), [])
)
  