test "fib" {
  inspect!(parser.parse([
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
    ][:]), content=
    #|Some((LetRec({name: ("fib", Int), args: [("n", Int)], body: If(LE(Var("n"), Int(1)), Var("n"), Prim(App(Var("fib"), [Prim(Var("n"), Int(1), Sub, kind=None)]), App(Var("fib"), [Prim(Var("n"), Int(2), Sub, kind=None)]), Add, kind=None))}, LetRec({name: ("main", Fun([], Unit)), args: [], body: App(Var("print_int"), [App(Var("fib"), [Int(30)])])}, Unit)), []))
  )
}

test "ex_frac" {
  inspect!(parser.parse([
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
    ][:]), content=
    #|Some((LetRec({name: ("main", Fun([], Unit)), args: [], body: LetRec({name: ("frac", Fun([Var({val: None})], Var({val: None}))), args: [("n", Var({val: None}))], body: If(Eq(Var("n"), Int(1)), Int(1), Prim(App(Var("frac"), [Prim(Var("n"), Int(1), Sub, kind=None)]), Var("n"), Mul, kind=None))}, App(Var("print_int"), [App(Var("frac"), [Int(6)])]))}, Unit), []))
  )
}