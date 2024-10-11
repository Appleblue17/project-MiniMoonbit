test "fib" {
  let res = parser([
    Token::FN,
    Token::IDENTIFIER("fib"),
    Token::LPAREN,
    Token::IDENTIFIER("n"),
    Token::COLON,
    Token::INT,
    Token::RPAREN,
    Token::ARROW,
    Token::INT,
    Token::LCURLYBRACKET,
    
    Token::IF,
    Token::IDENTIFIER("n"),
    Token::LE,
    Token::NUMBER("1"),
    Token::LCURLYBRACKET,
    Token::IDENTIFIER("n"),
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::IDENTIFIER("fib"),
    Token::LPAREN,
    Token::IDENTIFIER("n"),
    Token::SUB,
    Token::NUMBER("1"),
    Token::RPAREN,
    Token::ADD,
    Token::IDENTIFIER("fib"),
    Token::LPAREN,
    Token::IDENTIFIER("n"),
    Token::SUB,
    Token::NUMBER("2"),
    Token::RPAREN,
    Token::RCURLYBRACKET,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    Token::IDENTIFIER("print_int"),
    Token::LPAREN,
    Token::IDENTIFIER("fib"),
    Token::LPAREN,
    Token::NUMBER("30"),
    Token::RPAREN,
    Token::RPAREN,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    
    Token::UNIT
  ][:])
  inspect!(res, content=
    #|LetRec({name: ("fib", Fun([Int], Int)), args: [("n", Int)], body: If(LE(Var("n"), Int(1)), Var("n"), Prim(App(Var("fib"), [Prim(Var("n"), Int(1), Sub, kind=None)]), App(Var("fib"), [Prim(Var("n"), Int(2), Sub, kind=None)]), Add, kind=None))}, LetRec({name: ("main", Fun([], Unit)), args: [], body: App(Var("print_int"), [App(Var("fib"), [Int(30)])])}, Unit))
  )
  println(@json.stringify(res.to_json()))
}

test "ex_frac" {
  let res = parser([
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    
    Token::FN,
    Token::IDENTIFIER("frac"),
    Token::LPAREN,
    Token::IDENTIFIER("n"),
    Token::RPAREN,
    Token::LCURLYBRACKET,
    
    Token::IF,
    Token::IDENTIFIER("n"),
    Token::EQ,
    Token::NUMBER("1"),
    Token::LCURLYBRACKET,
    Token::NUMBER("1"),
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::IDENTIFIER("frac"),
    Token::LPAREN,
    Token::IDENTIFIER("n"),
    Token::SUB,
    Token::NUMBER("1"),
    Token::RPAREN,
    Token::MUL,
    Token::IDENTIFIER("n"),
    Token::RCURLYBRACKET,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    
    Token::IDENTIFIER("print_int"),
    Token::LPAREN,
    Token::IDENTIFIER("frac"),
    Token::LPAREN,
    Token::NUMBER("6"),
    Token::RPAREN,
    Token::RPAREN,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    
    Token::UNIT
  ][:])
  
  inspect!(res, content=
    #|LetRec({name: ("main", Fun([], Unit)), args: [], body: LetRec({name: ("frac", Fun([Var({val: None})], Var({val: None}))), args: [("n", Var({val: None}))], body: If(Eq(Var("n"), Int(1)), Int(1), Prim(App(Var("frac"), [Prim(Var("n"), Int(1), Sub, kind=None)]), Var("n"), Mul, kind=None))}, App(Var("print_int"), [App(Var("frac"), [Int(6)])]))}, Unit)
  )
  println(@json.stringify(res.to_json()))
}

test "func" {
  let res = parser([
    Token::FN,
    Token::IDENTIFIER("fib"),
    Token::LPAREN,
    Token::IDENTIFIER("n"),
    Token::COLON,
    Token::INT,
    Token::RPAREN,
    Token::ARROW,
    Token::INT,
    Token::LCURLYBRACKET,
    Token::NUMBER("1"),
    Token::ADD,
    Token::NUMBER("1"),
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:])
  inspect!(res, content=
    #|LetRec({name: ("fib", Fun([Int], Int)), args: [("n", Int)], body: Prim(Int(1), Int(1), Add, kind=None)}, Unit)
  )
  println(@json.stringify(res.to_json()))
}

test "non-tail-if2" {
  let res = parser([
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::NUMBER("12345"),
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    
    Token::LET,
    Token::IDENTIFIER("y"),
    Token::ASSIGN,
    Token::ARRAY,
    Token::COLON,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    Token::NUMBER("10"),
    Token::COMMA,
    Token::NUMBER("3"),
    Token::RPAREN,
    Token::SEMICOLON,
    
    Token::LET,
    Token::IDENTIFIER("x"),
    Token::ASSIGN,
    Token::NUMBER("67890"),
    Token::SEMICOLON,
    
    Token::IDENTIFIER("print_int"),
    Token::LPAREN,
    Token::IF,
    Token::IDENTIFIER("y"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::EQ,
    Token::NUMBER("3"),
    Token::LCURLYBRACKET,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::ADD,
    Token::IDENTIFIER("y"),
    Token::LBRACKET,
    Token::NUMBER("1"),
    Token::RBRACKET,
    Token::ADD,
    Token::IDENTIFIER("x"),
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::NUMBER("7"),
    Token::RCURLYBRACKET,
    Token::RPAREN,
    
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    
    Token::UNIT
  ][:])
  
  inspect!(res, content=
    #|LetRec({name: ("main", Fun([], Unit)), args: [], body: LetRec({name: ("f", Fun([], Var({val: None}))), args: [], body: Int(12345)}, Let(("y", Var({val: None})), Array(Int(10), Int(3)), Let(("x", Var({val: None})), Int(67890), App(Var("print_int"), [If(Eq(Get(Var("y"), Int(0)), Int(3)), Prim(Prim(App(Var("f"), []), Get(Var("y"), Int(1)), Add, kind=None), Var("x"), Add, kind=None), Int(7))]))))}, Unit)
  )
  println(@json.stringify(res.to_json()))
}

test {
  let str = 
  // #|["LetRec",{"name":["fib",["Fun",["Int"],"Int"]],"args":[["n","Int"]],"body":["If",["LE",["Var","n"],["Int",1]],["Var","n"],["{op}",["App",["Var","fib"],[["{op}",["Var","n"],["Int",1]]]],["App",["Var","fib"],[["{op}",["Var","n"],["Int",2]]]]]]},["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["App",["Var","print_int"],[["App",["Var","fib"],[["Int",30]]]]]},"Unit"]]
  #|["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["LetRec",{"name":["frac",["Fun",[["Var","None"]],["Var","None"]]],"args":[["n",["Var","None"]]],"body":["If",["Eq",["Var","n"],["Int",1]],["Int",1],["Mul",["App",["Var","frac"],[["Sub",["Var","n"],["Int",1]]]],["Var","n"]]]},["App",["Var","print_int"],[["App",["Var","frac"],[["Int",6]]]]]]},"Unit"]
  // #|["LetRec",{"name":["fib",["Fun",["Int"],"Int"]],"args":[["n","Int"]],"body":["Add",["Int",1],["Int",1]]},"Unit"]
  let tmp = @json.parse!(str)
  // println(tmp)
  let ast = @types.Syntax::from_json!(tmp)
  println(ast)
}