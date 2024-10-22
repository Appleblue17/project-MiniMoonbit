// Begin: 多元素表达式对应组合子

pub fn parser(tokens: ArrayView[Token]) -> Syntax {
  let result = top_level(tokens)
  match result {
    Some((syntax, [])) => syntax
    _ => @util.die("Parse error: cannot parse all the tokens.")
  }
}

// Top-level
fn top_level (tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(top_let_decl)
  .or(main_fn_decl)
  .or(top_fn_decl)
  .or(
    unit
    .map( fn { _ => Syntax::Unit } )
  )
  .parse(tokens)
}
test "top_level: basic functionality" {
  inspect!(top_level([
    Token::LET,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("x", Int), Int(1), Unit), []))
  )

  inspect!(top_level([
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("main", Fun([], Unit)), args: [], body: Bool(true)}, Unit), []))
  )
}
test "top_level: boundary cases" {
  inspect!(top_level([
    Token::LET,
    Token::IDENTIFIER("z"),
    Token::COLON,
    Token::UNIT,
    Token::ASSIGN,
    Token::LPAREN,
    Token::RPAREN,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("z", Unit), Unit, Unit), []))
  )

  inspect!(top_level([
    Token::FN,
    Token::IDENTIFIER("init"),
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("init", Fun([], Unit)), args: [], body: Bool(false)}, Unit), []))
  )
}
test "top_level: random valid cases" {
  inspect!(top_level([
    Token::LET,
    Token::IDENTIFIER("a"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("10"),
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("a", Int), Int(10), Unit), []))
  )

  inspect!(top_level([
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("f", Fun([], Bool)), args: [], body: Bool(true)}, Unit), []))
  )

  inspect!(top_level([
    Token::LET,
    Token::IDENTIFIER("b"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("3"),
    Token::DOT,
    Token::NUMBER("14"),
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("b", Double), Double(3.14), Unit), []))
  )

  inspect!(top_level([
    Token::FN,
    Token::IDENTIFIER("g"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("g", Fun([Int, Double], Bool)), args: [("x", Int), ("y", Double)], body: Bool(true)}, Unit), []))
  )
}
test "top_level: invalid cases" {
  inspect!(top_level([
    Token::LET,
    Token::IDENTIFIER("d"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::SEMICOLON
  ][:]), content=
    #|None
  )

  inspect!(top_level([
    Token::FN,
    Token::IDENTIFIER("h"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET
  ][:]), content=
    #|None
  )
}
test "top_level: edge cases" {
  inspect!(top_level([
    Token::LET,
    Token::IDENTIFIER("e"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5")
  ][:]), content=
    #|None
  )

  inspect!(top_level([
    Token::FN,
    Token::IDENTIFIER("i"),
    Token::LPAREN,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET
  ][:]), content=
    #|None
  )
}


fn top_let_decl(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  ctrl_let
  .and(identifier)
  .and(colon)
  .and(typ)
  .and(assign)
  .and(expr)
  .and(semicolon)
  .and(top_level)
  .map( fn { (((((((_, IDENTIFIER(id)), _), typ), _), expr), _), rest) 
        => Syntax::Let((id, typ), expr, rest) } )
  .parse(tokens)
}
test "top_let_decl: boundary cases" {
  inspect!(top_let_decl([
    // let z: Unit = ();
    Token::LET,
    Token::IDENTIFIER("z"),
    Token::COLON,
    Token::UNIT,
    Token::ASSIGN,
    Token::LPAREN,
    Token::RPAREN,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("z", Unit), Unit, Unit), []))
  )

  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("w"),
    Token::COLON,
    Token::BOOL,
    Token::ASSIGN,
    Token::TRUE,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("w", Bool), Bool(true), Unit), []))
  )
}
test "top_let_decl: random valid cases" {
  inspect!(top_let_decl([
    // let a: Int = 10;
    Token::LET,
    Token::IDENTIFIER("a"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("10"),
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("a", Int), Int(10), Unit), []))
  )

  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("b"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("3"),
    Token::DOT,
    Token::NUMBER("14"),
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("b", Double), Double(3.14), Unit), []))
  )

  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("c"),
    Token::COLON,
    Token::BOOL,
    Token::ASSIGN,
    Token::FALSE,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("c", Bool), Bool(false), Unit), []))
  )
}
test "top_let_decl: invalid cases" {
  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("d"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::SEMICOLON
  ][:]), content=
    #|None
  )

  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("e"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5")
  ][:]), content=
    #|None
  )
}
test "top_let_decl: edge cases" {
  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("f"),
    Token::COLON,
    Token::ARRAY,
    Token::LBRACKET,
    Token::INT,
    Token::RBRACKET,
    Token::ASSIGN,
    Token::ARRAY,
    Token::COLON,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    Token::NUMBER("5"),
    Token::COMMA,
    Token::NUMBER("0"),
    Token::RPAREN,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("f", Array(Int)), Array(Int(5), Int(0)), Unit), []))
  )

  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("g"),
    Token::COLON,
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ASSIGN,
    Token::LPAREN,
    Token::NUMBER("1"),
    Token::COMMA,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5"),
    Token::RPAREN,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("g", Tuple([Int, Double])), Tuple([Int(1), Double(2.5)]), Unit), []))
  )
}
test "top_let_decl: basic functionality" {
  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("x", Int), Int(1), Unit), []))
  )

  inspect!(top_let_decl([
    Token::LET,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5"),
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((Let(("y", Double), Double(2.5), Unit), []))
  )
}

fn main_fn_decl(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  ctrl_fn
  .and(
    identifier_main
      .or(identifier_init)
  )
  .and(fn_body)
  .and(semicolon)
  .and(top_level)
  .map( fn { ((((_, IDENTIFIER(id)), body), _), rest)
        => Syntax::LetRec(
          { name: (id, Fun([], Unit) ), args: [], body: body },
          rest )
      } )
  .parse(tokens)
}
test "main_fn_decl: valid main function declaration" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(main_fn_decl(tokens), content=
    #|Some((LetRec({name: ("main", Fun([], Unit)), args: [], body: Bool(true)}, Unit), []))
  )
}
test "main_fn_decl: valid init function declaration" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("init"),
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(main_fn_decl(tokens), content=
    #|Some((LetRec({name: ("init", Fun([], Unit)), args: [], body: Bool(false)}, Unit), []))
  )
}
test "main_fn_decl: missing function body" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(main_fn_decl(tokens), content="None")
}
test "main_fn_decl: invalid function name" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("invalid"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(main_fn_decl(tokens), content="None")
}
test "main_fn_decl: random valid cases" {
  inspect!(main_fn_decl([
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    Token::NUMBER("1"),
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("main", Fun([], Unit)), args: [], body: Int(1)}, Unit), []))
  )
  
  inspect!(main_fn_decl([
    Token::FN,
    Token::IDENTIFIER("init"),
    Token::LCURLYBRACKET,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5"),
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("init", Fun([], Unit)), args: [], body: Double(2.5)}, Unit), []))
  )
  
  inspect!(main_fn_decl([
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("main", Fun([], Unit)), args: [], body: Bool(true)}, Unit), []))
  )
  
  inspect!(main_fn_decl([
    Token::FN,
    Token::IDENTIFIER("init"),
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("init", Fun([], Unit)), args: [], body: Bool(false)}, Unit), []))
  )
}
test "main_fn_decl: boundary cases" {
  inspect!(main_fn_decl([
    // fn main { () )}
    Token::FN,
    Token::IDENTIFIER("main"),
    Token::LCURLYBRACKET,
    Token::LPAREN,
    Token::RPAREN,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("main", Fun([], Unit)), args: [], body: Unit}, Unit), []))
  )
  
  inspect!(main_fn_decl([
    Token::FN,
    Token::IDENTIFIER("init"),
    Token::LCURLYBRACKET,
    Token::LPAREN,
    Token::RPAREN,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ][:]), content=
    #|Some((LetRec({name: ("init", Fun([], Unit)), args: [], body: Unit}, Unit), []))
  )
}

// Function declarations

fn top_fn_decl(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  ctrl_fn
  .and(identifier)
  .and(lparen)
  .and(
    Parser(param_list)
    .optional()
  )
  .and(rparen)
  .and(arrow)
  .and(typ)
  .and(fn_body)
  .and(semicolon)
  .and(top_level)
  .map( fn { (((((((((_, IDENTIFIER(id)), _), param_list), _), _), typ), body), _), rest)
        => {
          let type_list = param_list.map( fn { (_,t) => t })
          Syntax::LetRec(
            { name: ( id, Fun(type_list, typ) ), args: param_list, body: body },
            rest )
        }
      } )
  .parse(tokens)
}
test "top_fn_decl: valid function declaration with no parameters and no return type" {
  let tokens = ([
    // fn f() -> Bool { true }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(top_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([], Bool)), args: [], body: Bool(true)}, Unit), []))
  )
}
test "top_fn_decl: valid function declaration with parameters and return type" {
  let tokens = ([
    // fn f(x: Int, y: Double) -> Bool { true }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(top_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([Int, Double], Bool)), args: [("x", Int), ("y", Double)], body: Bool(true)}, Unit), []))
  )
}
test "top_fn_decl: valid function declaration with parameters but no return type" {
  let tokens = ([
    // fn f(x: Int, y: Double) -> Bool { true }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(top_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([Int, Double], Bool)), args: [("x", Int), ("y", Double)], body: Bool(true)}, Unit), []))
  )
}
test "top_fn_decl: valid function declaration with no parameters but with return type" {
  let tokens = ([
    // fn f() -> Bool { True }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(top_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([], Bool)), args: [], body: Bool(true)}, Unit), []))
  )
}
test "top_fn_decl: invalid function declaration with missing closing parenthesis" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::TRUE,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(top_fn_decl(tokens), content="None")
}
test "top_fn_decl: invalid function declaration with missing closing curly bracket" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::SEMICOLON,
    Token::UNIT,
  ])[:]
  inspect!(top_fn_decl(tokens), content="None")
}
test "top_fn_decl: function declaration with missing arrow and return type" {
  let tokens = ([
    // fn f() -> Bool { true }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(top_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([], Bool)), args: [], body: Bool(true)}, Unit), []))
  )
}
test "top_fn_decl: invalid function declaration with missing identifier" {
  let tokens = ([
    Token::FN,
    Token::LPAREN,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::UNIT
  ])[:]
  inspect!(top_fn_decl(tokens), content="None")
}

fn param_list(tokens: ArrayView[Token]) -> (Array[(String, Type)], ArrayView[Token])?{
  Parser(param)
  .and(
    comma
      .and(param)
      .map( fn { (_, param) => param } )
    .many()
  )
  .map( fn { (param, params) => {
              params.insert(0, param)
              params
            } 
          } )
  .parse(tokens)
}
test "param_list: valid parameter list with a single parameter" {
  let tokens = ([
    Token::IDENTIFIER("x"), 
    Token::COLON, 
    Token::INT
  ][:])
  inspect!(param_list(tokens), content="Some(([(\"x\", Int)], []))")
}
test "param_list: invalid parameter list with missing type annotation" {
  let tokens = ([
    Token::IDENTIFIER("x"), 
    Token::COMMA, 
    Token::IDENTIFIER("y"), 
    Token::COLON, 
    Token::DOUBLE
  ][:])
  inspect!(param_list(tokens), content="None")
}
test "param_list: invalid parameter list with missing comma" {
  let tokens = ([
    Token::IDENTIFIER("x"), 
    Token::COLON, 
    Token::INT, 
    Token::IDENTIFIER("y"), 
    Token::COLON, 
    Token::DOUBLE
  ][:])
  inspect!(param_list(tokens), content=
    #|Some(([("x", Int)], [IDENTIFIER("y"), COLON, DOUBLE]))
  )
}
test "param_list: random valid cases" {
  inspect!(param_list([
    Token::IDENTIFIER("a"), 
    Token::COLON, 
    Token::INT, 
    Token::COMMA, 
    Token::IDENTIFIER("b"), 
    Token::COLON, 
    Token::DOUBLE
  ][:]), content="Some(([(\"a\", Int), (\"b\", Double)], []))")
  
  inspect!(param_list([
    Token::IDENTIFIER("c"), 
    Token::COLON, 
    Token::BOOL, 
    Token::COMMA, 
    Token::IDENTIFIER("d"), 
    Token::COLON, 
    Token::INT, 
    Token::COMMA, 
    Token::IDENTIFIER("e"), 
    Token::COLON, 
    Token::DOUBLE
  ][:]), content="Some(([(\"c\", Bool), (\"d\", Int), (\"e\", Double)], []))")
  
  inspect!(param_list([
    Token::IDENTIFIER("f"), 
    Token::COLON, 
    Token::ARRAY, 
    Token::LBRACKET, 
    Token::INT, 
    Token::RBRACKET, 
    Token::COMMA, 
    Token::IDENTIFIER("g"), 
    Token::COLON, 
    Token::BOOL
  ][:]), content="Some(([(\"f\", Array(Int)), (\"g\", Bool)], []))")
  
  inspect!(param_list([
    Token::IDENTIFIER("h"), 
    Token::COLON, 
    Token::LPAREN, 
    Token::INT, 
    Token::COMMA, 
    Token::DOUBLE, 
    Token::RPAREN, 
    Token::COMMA, 
    Token::IDENTIFIER("i"), 
    Token::COLON, 
    Token::BOOL
  ][:]), content="Some(([(\"h\", Tuple([Int, Double])), (\"i\", Bool)], []))")
}
test "param_list: boundary cases" {
  inspect!(param_list([
    Token::IDENTIFIER("x"), 
    Token::COLON, 
    Token::INT
  ][:]), content="Some(([(\"x\", Int)], []))")
  
  inspect!(param_list([
    Token::IDENTIFIER("y"), 
    Token::COLON, 
    Token::DOUBLE
  ][:]), content="Some(([(\"y\", Double)], []))")
  
  inspect!(param_list([
    Token::IDENTIFIER("z"), 
    Token::COLON, 
    Token::BOOL
  ][:]), content="Some(([(\"z\", Bool)], []))")
}
test "param_list: valid parameter list with multiple parameters" {
  let tokens = ([
    Token::IDENTIFIER("x"), 
    Token::COLON, 
    Token::INT, 
    Token::COMMA, 
    Token::IDENTIFIER("y"), 
    Token::COLON, 
    Token::DOUBLE, 
    Token::COMMA, 
    Token::IDENTIFIER("z"), 
    Token::COLON, 
    Token::BOOL
  ][:])
  inspect!(param_list(tokens), content="Some(([(\"x\", Int), (\"y\", Double), (\"z\", Bool)], []))")
}

fn param(tokens: ArrayView[Token]) -> ((String, Type), ArrayView[Token])?{
  identifier
  .and(type_annotation)
  .map( fn { ( IDENTIFIER(id), typ)
        => (id, typ) } )
  .parse(tokens)
}

fn fn_body(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  lcurlybracket
  .and(stmt)
  .and(rcurlybracket)
  .map( fn { ((_, stmt), _)
        => stmt } )
  .parse(tokens)
}
test "fn_body: ex_frac" {
  let tokens = ([
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
  ])[:]
  inspect!(fn_body(tokens), content=
    #|Some((If(Eq(Var("n"), Int(1)), Int(1), Prim(App(Var("frac"), [Prim(Var("n"), Int(1), Sub, kind=None)]), Var("n"), Mul, kind=None)), []))
  )
}
test "fn_body: valid function body with a single statement" {
  let tokens = ([
    Token::LCURLYBRACKET,
    Token::NUMBER("1"), // Assuming stmt returns Syntax::Int(1)
    Token::RCURLYBRACKET
  ])[:]
  inspect!(fn_body(tokens), content="Some((Int(1), []))")
}
test "fn_body: missing closing curly bracket" {
  let tokens = ([
    Token::LCURLYBRACKET,
    Token::NUMBER("1"), // Assuming stmt returns Syntax::Int(1)
  ])[:]
  inspect!(fn_body(tokens), content="None")
}
test "fn_body: empty function body" {
  let tokens = ([
    Token::LCURLYBRACKET,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(fn_body(tokens), content="None")
}
test "fn_body: function body with invalid token sequence" {
  let tokens = ([
    Token::LCURLYBRACKET,
    Token::ADD,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(fn_body(tokens), content="None")
}
test "fn_body: function body with nested curly brackets" {
  let tokens = ([
    // {{1}}
    Token::LCURLYBRACKET,
    Token::LCURLYBRACKET,
    Token::NUMBER("1"), // Assuming stmt returns Syntax::Int(1)
    Token::RCURLYBRACKET,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(fn_body(tokens), content="Some((Int(1), []))")
}
test "fn_body: function body with invalid statement" {
  let tokens = ([
    Token::LCURLYBRACKET,
    Token::ADD,
    Token::NUMBER("1"), // Assuming stmt returns Syntax::Int(1)
    Token::RCURLYBRACKET
  ])[:]
  inspect!(fn_body(tokens), content="None")
}

fn nontop_fn_decl(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  ctrl_fn
  .and(identifier)
  .and(lparen)
  .and(
    Parser(nontop_param_list)
    .optional()
  )
  .and(rparen)
  .and(
    arrow
      .and(typ)
    .map( fn { (_, typ) => typ } )
    .optional_type()
  )
  .and(fn_body)
  .and(semicolon)
  .and(stmt)
  .map( fn { ((((((((_, IDENTIFIER(id)), _), param_list), _), typ), body), _), rest)
        => {
          let type_list = param_list.map( fn { (_,t) => t })
          Syntax::LetRec(
            { name: ( id, Fun(type_list, typ) ), args: param_list, body: body },
            rest )
        }
      } )
  .parse(tokens)
}
test "nontop_fn_decl: ex_frac" {
  let tokens = ([
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
    
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content=
    #|Some((LetRec({name: ("frac", Fun([Var({val: None})], Var({val: None}))), args: [("n", Var({val: None}))], body: If(Eq(Var("n"), Int(1)), Int(1), Prim(App(Var("frac"), [Prim(Var("n"), Int(1), Sub, kind=None)]), Var("n"), Mul, kind=None))}, Bool(true)), []))
  )
}
test "nontop_fn_decl: valid function declaration with no parameters and no return type" {
  let tokens = ([
    // fn f() { true }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([], Var({val: None}))), args: [], body: Bool(true)}, Bool(true)), []))
  )
}
test "nontop_fn_decl: valid function declaration with parameters and return type" {
  let tokens = ([
    // fn f(x: Int, y: Double) -> Bool { true }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([Int, Double], Bool)), args: [("x", Int), ("y", Double)], body: Bool(true)}, Bool(true)), []))
  )
}
test "nontop_fn_decl: valid function declaration with parameters but no return type" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([Int, Double], Var({val: None}))), args: [("x", Int), ("y", Double)], body: Bool(true)}, Bool(true)), []))
  )
}
test "nontop_fn_decl: valid function declaration with no parameters but with return type" {
  let tokens = ([
    // fn f() -> Bool { True }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([], Bool)), args: [], body: Bool(true)}, Bool(true)), []))
  )
}
test "nontop_fn_decl: invalid function declaration with missing closing parenthesis" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content="None")
}
test "nontop_fn_decl: invalid function declaration with missing closing curly bracket" {
  let tokens = ([
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content="None")
}
test "nontop_fn_decl: function declaration with missing arrow and return type" {
  let tokens = ([
    // fn f() { true }
    Token::FN,
    Token::IDENTIFIER("f"),
    Token::LPAREN,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content=
    #|Some((LetRec({name: ("f", Fun([], Var({val: None}))), args: [], body: Bool(true)}, Bool(true)), []))
  )
}
test "nontop_fn_decl: invalid function declaration with missing identifier" {
  let tokens = ([
    Token::FN,
    Token::LPAREN,
    Token::RPAREN,
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(nontop_fn_decl(tokens), content="None")
}



fn nontop_param_list(tokens: ArrayView[Token]) -> (Array[(String, Type)], ArrayView[Token])?{
  Parser(nontop_param)
  .and(
    comma
      .and(nontop_param)
      .map( fn { (_, param) => param } )
    .many()
  )
  .map( fn { (param, params) => {
              params.insert(0, param)
              params
            } 
          } )
  .parse(tokens)
}
test "nontop_param_list: random valid cases" {
  inspect!(nontop_param_list([
    Token::IDENTIFIER("a"), 
    Token::COLON, 
    Token::INT, 
    Token::COMMA, 
    Token::IDENTIFIER("b"), 
    Token::COLON, 
    Token::DOUBLE
  ][:]), content="Some(([(\"a\", Int), (\"b\", Double)], []))")
  
  inspect!(nontop_param_list([
    Token::IDENTIFIER("c"), 
    Token::COLON, 
    Token::BOOL, 
    Token::COMMA, 
    Token::IDENTIFIER("d"), 
    Token::COLON, 
    Token::INT, 
    Token::COMMA, 
    Token::IDENTIFIER("e"), 
    Token::COLON, 
    Token::DOUBLE
  ][:]), content="Some(([(\"c\", Bool), (\"d\", Int), (\"e\", Double)], []))")
  
  inspect!(nontop_param_list([
    Token::IDENTIFIER("f"), 
    Token::COLON, 
    Token::ARRAY, 
    Token::LBRACKET, 
    Token::INT, 
    Token::RBRACKET, 
    Token::COMMA, 
    Token::IDENTIFIER("g"), 
    Token::COLON, 
    Token::BOOL
  ][:]), content="Some(([(\"f\", Array(Int)), (\"g\", Bool)], []))")
  
  inspect!(nontop_param_list([
    Token::IDENTIFIER("h"), 
    Token::COLON, 
    Token::LPAREN, 
    Token::INT, 
    Token::COMMA, 
    Token::DOUBLE, 
    Token::RPAREN, 
    Token::COMMA, 
    Token::IDENTIFIER("i"), 
    Token::COLON, 
    Token::BOOL
  ][:]), content="Some(([(\"h\", Tuple([Int, Double])), (\"i\", Bool)], []))")
}
test "nontop_param_list: invalid cases" {
  inspect!(nontop_param_list([
    Token::IDENTIFIER("j"), 
    Token::COLON, 
    Token::ARRAY
  ][:]), content="Some(([(\"j\", Var({val: None}))], [COLON, ARRAY]))") // Missing type inside array
  
  inspect!(nontop_param_list([
    Token::IDENTIFIER("k"), 
    Token::COLON, 
    Token::LPAREN, 
    Token::INT, 
    Token::COMMA, 
    Token::DOUBLE
  ][:]), content="Some(([(\"k\", Var({val: None}))], [COLON, LPAREN, INT, COMMA, DOUBLE]))") // Missing closing parenthesis for tuple type
  
  inspect!(nontop_param_list([
    // l: Int, m
    Token::IDENTIFIER("l"), 
    Token::COLON, 
    Token::INT, 
    Token::COMMA, 
    Token::IDENTIFIER("m")
  ][:]), content=
    #|Some(([("l", Int), ("m", Var({val: None}))], []))
  ) // Missing colon and type for second identifier
}
test "nontop_param_list: boundary cases" {
  inspect!(nontop_param_list([
    Token::IDENTIFIER("x"), 
    Token::COLON, 
    Token::INT
  ][:]), content="Some(([(\"x\", Int)], []))")
  
  inspect!(nontop_param_list([
    Token::IDENTIFIER("y"), 
    Token::COLON, 
    Token::DOUBLE
  ][:]), content="Some(([(\"y\", Double)], []))")
  
  inspect!(nontop_param_list([
    Token::IDENTIFIER("z"), 
    Token::COLON, 
    Token::BOOL
  ][:]), content="Some(([(\"z\", Bool)], []))")
}

fn nontop_param(tokens: ArrayView[Token]) -> ((String, Type), ArrayView[Token])?{
  identifier
  .and(
    Parser(type_annotation)
    .optional_type()
  )
  .map( fn { ( IDENTIFIER(id), typ)
        => (id, typ) } )
  .parse(tokens)
}
test "nontop_param: edge cases" {
  inspect!(nontop_param([
    Token::IDENTIFIER("i"), 
    Token::COLON, 
    Token::LPAREN, 
    Token::INT, 
    Token::COMMA, 
    Token::DOUBLE, 
    Token::RPAREN
  ][:]), content="Some(((\"i\", Tuple([Int, Double])), []))")
  
  inspect!(nontop_param([
    Token::IDENTIFIER("j"), 
    Token::COLON, 
    Token::LPAREN, 
    Token::INT, 
    Token::COMMA, 
    Token::DOUBLE, 
    Token::RPAREN, 
    Token::ARROW, 
    Token::BOOL
  ][:]), content="Some(((\"j\", Fun([Int, Double], Bool)), []))")
  
  inspect!(nontop_param([
    Token::IDENTIFIER("k"), 
    Token::COLON, 
    Token::ARRAY, 
    Token::LBRACKET, 
    Token::INT, 
    Token::RBRACKET
  ][:]), content="Some(((\"k\", Array(Int)), []))")
  
  inspect!(nontop_param([
    // h: (Int, Double) -> Bool
    Token::IDENTIFIER("h"), 
    Token::COLON, 
    Token::LPAREN, 
    Token::INT, 
    Token::COMMA, 
    Token::DOUBLE, 
    Token::RPAREN, 
    Token::ARROW, 
    Token::BOOL
  ][:]), content=
    #|Some((("h", Fun([Int, Double], Bool)), []))
  )
}
test "nontop_param: invalid cases" {
  inspect!(nontop_param([
    Token::IDENTIFIER("f"), 
    Token::COLON, 
    Token::ARRAY
  ][:]), content=
    #|Some((("f", Var({val: None})), [COLON, ARRAY]))
  ) // Missing type inside array
  
  inspect!(nontop_param([
    Token::IDENTIFIER("g"), 
    Token::COLON, 
    Token::LPAREN, 
    Token::INT, 
    Token::COMMA, 
    Token::DOUBLE
  ][:]), content=
    #|Some((("g", Var({val: None})), [COLON, LPAREN, INT, COMMA, DOUBLE]))
  ) // Missing closing parenthesis for tuple type
}
test "nontop_param: random valid cases" {
  inspect!(nontop_param([
    Token::IDENTIFIER("a"), 
    Token::COLON, 
    Token::INT
  ][:]), content="Some(((\"a\", Int), []))")
  
  inspect!(nontop_param([
    Token::IDENTIFIER("b"), 
    Token::COLON, 
    Token::DOUBLE
  ][:]), content="Some(((\"b\", Double), []))")
  
  inspect!(nontop_param([
    Token::IDENTIFIER("c"), 
    Token::COLON, 
    Token::BOOL
  ][:]), content="Some(((\"c\", Bool), []))")
  
  inspect!(nontop_param([
    Token::IDENTIFIER("d"), 
    Token::COLON, 
    Token::UNIT
  ][:]), content="Some(((\"d\", Unit), []))")
  
  inspect!(nontop_param([
    Token::IDENTIFIER("e"), 
    Token::COLON, 
    Token::ARRAY, 
    Token::LBRACKET, 
    Token::INT, 
    Token::RBRACKET
  ][:]), content="Some(((\"e\", Array(Int)), []))")
}

// Statements

fn stmt(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(let_tuple_stmt)
  .or(let_stmt)
  .or(nontop_fn_decl)
  .or(assign_stmt)
  .or(expr)
  .parse(tokens)
}
test "stmt function: empty" {
  inspect!(stmt([][:]), content="None")
}
test "stmt function: edge cases" {
  inspect!(stmt([Token::LET, Token::IDENTIFIER("z"), Token::COLON, Token::UNIT, Token::ASSIGN, Token::LPAREN, Token::RPAREN, Token::SEMICOLON][:]), content="None")
  inspect!(stmt([Token::LET, Token::IDENTIFIER("w"), Token::COLON, Token::BOOL, Token::ASSIGN, Token::TRUE, Token::SEMICOLON][:]), content="None")
}
test "stmt function: basic functionality" {
  inspect!(stmt([Token::LET, Token::IDENTIFIER("x"), Token::COLON, Token::INT, Token::ASSIGN, Token::NUMBER("1"), Token::SEMICOLON][:]), content="None")
  inspect!(stmt([Token::LET, Token::IDENTIFIER("y"), Token::COLON, Token::DOUBLE, Token::ASSIGN, Token::NUMBER("2"), Token::DOT, Token::NUMBER("5"), Token::SEMICOLON][:]), content="None")
}

fn let_tuple_stmt(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  ctrl_let
  .and(lparen)
  .and(
    identifier
      .map( fn { IDENTIFIER(id) => id } )
    .and(
      comma
        .and(identifier)
        .map( fn { (_, IDENTIFIER(id) ) => id } )
      .many()
    )
    .map( fn { (id, ids) => {
                ids.insert(0, id)
                ids
              } 
            } )
  )
  .and(rparen)
  .and(
    Parser(type_annotation)
    .optional_type()
  )
  .and(assign)
  .and(value_expr)
  .and(semicolon)
  .and(stmt)
  .map( fn! { ((((((((_, _), id_list), _), typ), _), expr), _), rest)
          => {
            let length = id_list.length()
            let type_list = match typ{
              Var({val: None}) => Array::make(length, Type::Var({val: None}))
              Tuple(type_list) => type_list
              _ => raise ParseErr("Parsing Error: Type_annotation is not a tuple.")
            }
            guard(type_list.length() == length) else{
                raise ParseErr("Parsing Error: Type_annotation length does not correpond to the tuple.")
            }
            
            let elements = []
            for i in 0 ..< length {
              elements.push( (id_list[i], type_list[i]) )
            }
            Syntax::LetTuple(elements, expr, rest)
          }
        } )
  .parse(tokens)
}
test "let_tuple_stmt: basic functionality" {
  let tokens = ([
    /// Let(x, y, z): (Int, Double, Bool) = (2, 1.4, false)
    Token::LET,
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COMMA,
    Token::IDENTIFIER("z"),
    Token::RPAREN,
    
    Token::COLON,
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE,
    Token::COMMA,
    Token::BOOL,
    Token::RPAREN,
    
    Token::ASSIGN,
    Token::LPAREN,
    Token::NUMBER("2"),
    Token::COMMA,
    Token::NUMBER("1"),
    Token::DOT,
    Token::NUMBER("4"),
    Token::COMMA,
    Token::FALSE,
    Token::RPAREN,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(let_tuple_stmt(tokens), content=
    #|Some((LetTuple([("x", Int), ("y", Double), ("z", Bool)], Tuple([Int(2), Double(1.4), Bool(false)]), Bool(true)), []))
  )
}
test "let_tuple_stmt: ommit types" {
  let tokens = ([
    /// Let(x, y, z) = (2, 1.4, false)
    Token::LET,
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COMMA,
    Token::IDENTIFIER("z"),
    Token::RPAREN,
    
    Token::ASSIGN,
    Token::LPAREN,
    Token::NUMBER("2"),
    Token::COMMA,
    Token::NUMBER("1"),
    Token::DOT,
    Token::NUMBER("4"),
    Token::COMMA,
    Token::FALSE,
    Token::RPAREN,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(let_tuple_stmt(tokens), content=
    #|Some((LetTuple([("x", Var({val: None})), ("y", Var({val: None})), ("z", Var({val: None}))], Tuple([Int(2), Double(1.4), Bool(false)]), Bool(true)), []))
  )
}
test "let_tuple_stmt: invalid length" {
  let tokens = ([
    /// Let(x, y, z): (Int, Bool) = (2, 1.4, false)
    Token::LET,
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COMMA,
    Token::IDENTIFIER("z"),
    Token::RPAREN,
    
    Token::COLON,
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::BOOL,
    Token::RPAREN,
    
    Token::ASSIGN,
    Token::LPAREN,
    Token::NUMBER("2"),
    Token::COMMA,
    Token::NUMBER("1"),
    Token::DOT,
    Token::NUMBER("4"),
    Token::COMMA,
    Token::FALSE,
    Token::RPAREN,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(let_tuple_stmt(tokens), content=
    "None"
  )
}
test "let_tuple_stmt: invalid - type is not tuple" {
  let tokens = ([
    /// Let(x, y, z): (Int, Bool) = (2, 1.4, false)
    Token::LET,
    Token::LPAREN,
    Token::IDENTIFIER("x"),
    Token::COMMA,
    Token::IDENTIFIER("y"),
    Token::COMMA,
    Token::IDENTIFIER("z"),
    Token::RPAREN,
    
    Token::COLON,
    Token::INT,
    
    Token::ASSIGN,
    Token::LPAREN,
    Token::NUMBER("2"),
    Token::COMMA,
    Token::NUMBER("1"),
    Token::DOT,
    Token::NUMBER("4"),
    Token::COMMA,
    Token::FALSE,
    Token::RPAREN,
    Token::SEMICOLON,
    Token::TRUE
  ])[:]
  inspect!(let_tuple_stmt(tokens), content=
    "None"
  )
}

fn let_stmt(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  ctrl_let
  .and(identifier)
  .and(
    Parser(type_annotation)
    .optional_type()
  )
  .and(assign)
  .and(expr)
  .and(semicolon)
  .and(stmt)
  .map( fn { ((((((_, IDENTIFIER(id)), typ), _), expr), _), rest)
          => {
            Syntax::Let( (id, typ), expr, rest)
          }
        } )
  .parse(tokens)
}
test "let_stmt: boundary cases" {
  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("z"),
    Token::COLON,
    Token::UNIT,
    Token::ASSIGN,
    Token::LPAREN,
    Token::RPAREN,
    Token::SEMICOLON,
    Token::FALSE
  ][:]), content=
    #|Some((Let(("z", Unit), Unit, Bool(false)), []))
  )
  
  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("w"),
    Token::COLON,
    Token::BOOL,
    Token::ASSIGN,
    Token::TRUE,
    Token::SEMICOLON,
    Token::FALSE
  ][:]), content=
    #|Some((Let(("w", Bool), Bool(true), Bool(false)), []))
  )
}
test "let_stmt: random valid cases" {
  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("a"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("10"),
    Token::SEMICOLON,
    Token::FALSE
  ][:]), content=
    #|Some((Let(("a", Int), Int(10), Bool(false)), []))
  )

  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("b"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("3"),
    Token::DOT,
    Token::NUMBER("14"),
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content=
    #|Some((Let(("b", Double), Double(3.14), Bool(true)), []))
  )

  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("c"),
    Token::COLON,
    Token::BOOL,
    Token::ASSIGN,
    Token::FALSE,
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content=
    #|Some((Let(("c", Bool), Bool(false), Bool(true)), []))
  )
}
test "let_stmt: invalid cases" {
  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("d"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::SEMICOLON
  ][:]), content=
    #|None
  )

  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("e"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5")
  ][:]), content=
    #|None
  )
}
test "let_stmt: basic functionality" {
  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("x"),
    Token::COLON,
    Token::INT,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content=
    #|Some((Let(("x", Int), Int(1), Bool(true)), []))
  )

  inspect!(let_stmt([
    Token::LET,
    Token::IDENTIFIER("y"),
    Token::COLON,
    Token::DOUBLE,
    Token::ASSIGN,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5"),
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content=
    #|Some((Let(("y", Double), Double(2.5), Bool(true)), []))
  )
}

fn type_annotation(tokens: ArrayView[Token]) -> (Type, ArrayView[Token])?{
  colon
  .and(typ)
  .map( fn { (_, typ) => typ})
  .parse(tokens)
}
test "let_stmt: basic functionality" {
  inspect!(type_annotation([
    Token::COLON,
    Token::INT,
  ][:]), content="Some((Int, []))")
}
// x[y] = z

fn assign_stmt(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(get_expr)
  .and(assign)
  .and(expr)
  .and(semicolon)
  .and(stmt)
  .map( fn { ((((get_expr, _), expr), _), rest)
          => Syntax::Put(get_expr, expr, rest) })
  .parse(tokens)
}
test "assign_stmt: random valid cases" {
  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("5"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::NUMBER("10"),
    Token::SEMICOLON,
    Token::FALSE
  ][:]), content=
    #|Some((Put(Get(Var("x"), Int(5)), Int(10), Bool(false)), []))
  )

  inspect!(assign_stmt([
    Token::IDENTIFIER("y"),
    Token::LBRACKET,
    Token::NUMBER("3"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::NUMBER("7"),
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content=
    #|Some((Put(Get(Var("y"), Int(3)), Int(7), Bool(true)), []))
  )

  inspect!(assign_stmt([
    Token::IDENTIFIER("z"),
    Token::LBRACKET,
    Token::NUMBER("1"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::NUMBER("100"),
    Token::SEMICOLON,
    Token::FALSE
  ][:]), content=
    #|Some((Put(Get(Var("z"), Int(1)), Int(100), Bool(false)), []))
  )
}
test "assign_stmt: invalid token sequence" {
  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::ADD,
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content="None")

  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::SUB,
    Token::SEMICOLON,
    Token::FALSE
  ][:]), content="None")
}
test "assign_stmt: missing semicolon" {
  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::TRUE
  ][:]), content="None")
}
test "assign_stmt: missing assign token" {
  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::NUMBER("1"),
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content="None")
}
test "assign_stmt: boundary cases" {
  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::NUMBER("0"),
    Token::SEMICOLON,
    Token::FALSE
  ][:]), content=
    #|Some((Put(Get(Var("x"), Int(0)), Int(0), Bool(false)), []))
  )

  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::NUMBER("2147483647"),
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content=
    #|Some((Put(Get(Var("x"), Int(0)), Int(2147483647), Bool(true)), []))
  )
}
test "assign_stmt: basic functionality" {
  inspect!(assign_stmt([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET,
    Token::ASSIGN,
    Token::NUMBER("1"),
    Token::SEMICOLON,
    Token::TRUE
  ][:]), content=
    #|Some((Put(Get(Var("x"), Int(0)), Int(1), Bool(true)), []))
  )
}

fn get_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(get_or_apply_level_expr)
  .map( fn! {
            Syntax::Get(_, _) as input => input
            _ => raise ParseErr("Parsing Error: cannot assign value to apply method.")
        } )
  .parse(tokens)
}
test "assign_stmt: basic functionality" {
  inspect!(get_expr([
    Token::IDENTIFIER("x"),
    Token::LBRACKET,
    Token::NUMBER("0"),
    Token::RBRACKET
  ][:]), content=
    #|Some((Get(Var("x"), Int(0)), []))
  )
}
// Expressions, in order of precedence.

// expr: not associative
fn expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(add_sub_level_expr)
  .and(eq)
  .and(add_sub_level_expr)
  .map( fn { ((x, _), y)
          => Syntax::Eq(x, y) } )
  .or(
    Parser(add_sub_level_expr)
    .and(le)
    .and(add_sub_level_expr)
    .map( fn { ((x, _), y)
          => Syntax::LE(x, y) } )
  )
  .or(
    add_sub_level_expr
  )
  .parse(tokens)
}
test "expr function: empty input" {
  inspect!(expr([][:]), content="None")
}
test "expr function: nested expressions" {
  inspect!(expr([Token::NUMBER("1"), Token::ADD, Token::NUMBER("2"), Token::MUL, Token::NUMBER("3"), Token::EQ, Token::NUMBER("7")][:]), content="Some((Eq(Prim(Int(1), Prim(Int(2), Int(3), Mul, kind=None), Add, kind=None), Int(7)), []))")
  inspect!(expr([Token::NUMBER("1"), Token::MUL, Token::NUMBER("2"), Token::ADD, Token::NUMBER("3"), Token::LE, Token::NUMBER("5")][:]), content="Some((LE(Prim(Prim(Int(1), Int(2), Mul, kind=None), Int(3), Add, kind=None), Int(5)), []))")
}

// add_sub_level_expr: left associative
fn add_sub_level_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(mul_div_level_expr)
  .and(
    ptoken( fn {
              ADD | SUB => true
              _ => false
            })
    .and(mul_div_level_expr)
    .many()
  )
  .map( fn { (e, list) => {
              list.fold(
                init = e, 
                fn {
                  e, (ADD, expr) => Syntax::Prim(e, expr, Add, kind = None)
                  e, (SUB, expr) => Syntax::Prim(e, expr, Sub, kind = None)
                }
              )
            }
        } )
  .parse(tokens)
}
test "add_sub_level_expr: basic functionality" {
  inspect!(add_sub_level_expr([
    Token::NUMBER("1"),
    Token::ADD,
    Token::NUMBER("2"),
    Token::SUB,
    Token::NUMBER("3")
  ][:]), content=
   #|Some((Prim(Prim(Int(1), Int(2), Add, kind=None), Int(3), Sub, kind=None), []))
  )
}
test "add_sub_level_expr: boundary cases" {
  inspect!(add_sub_level_expr([
    Token::IDENTIFIER("x"),
    Token::ADD,
    Token::NUMBER("0")
  ][:]), content=
    #|Some((Prim(Var("x"), Int(0), Add, kind=None), []))
  )

  inspect!(add_sub_level_expr([
    Token::NUMBER("5"),
    Token::SUB,
    Token::NUMBER("7")
  ][:]), content="Some((Prim(Int(5), Int(7), Sub, kind=None), []))")
}
test "add_sub_level_expr: invalid token sequence" {
  inspect!(add_sub_level_expr([
    Token::NUMBER("1"),
    Token::ADD,
    Token::SUB,
    Token::NUMBER("2")
  ][:]), content="Some((Prim(Int(1), Neg(Int(2), kind=None), Add, kind=None), []))")

  inspect!(add_sub_level_expr([
    Token::NUMBER("1"),
    Token::ADD,
    Token::MUL,
    Token::NUMBER("2")
  ][:]), content=
    #|Some((Int(1), [ADD, MUL, NUMBER("2")]))
  )
}
test "add_sub_level_expr: nested expressions" {
  inspect!(add_sub_level_expr([
    Token::NUMBER("1"),
    Token::ADD,
    Token::NUMBER("2"),
    Token::MUL,
    Token::NUMBER("3"),
  ][:]), content=
    "Some((Prim(Int(1), Prim(Int(2), Int(3), Mul, kind=None), Add, kind=None), []))"
  )

  inspect!(add_sub_level_expr([
    Token::NUMBER("1"),
    Token::MUL,
    Token::NUMBER("2"),
    Token::ADD,
    Token::NUMBER("3"),
  ][:]), content="Some((Prim(Prim(Int(1), Int(2), Mul, kind=None), Int(3), Add, kind=None), []))")
}
test "add_sub_level_expr: empty input" {
  inspect!(add_sub_level_expr([][:]), content="None")
}

// mul_div_level_expr: left associative
fn mul_div_level_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(if_level_expr)
  .and(
    ptoken( fn {
              MUL | DIV => true
              _ => false
            })
    .and(if_level_expr)
    .many()
  )
  .map( fn { (e, list) => {
              list.fold(
                init = e, 
                fn {
                  e, (MUL, expr) => Syntax::Prim(e, expr, Mul, kind = None)
                  e, (DIV, expr) => Syntax::Prim(e, expr, Div, kind = None)
                }
              )
            }
        } )
  .parse(tokens)
}

fn if_level_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(get_or_apply_level_expr)
  .or(if_expr)
  .parse(tokens)
}

fn if_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  ctrl_if
  .and(expr)
  .and(block_expr)
  .and(
    ctrl_else
    .and(block_expr)
    .map( fn { (_, block_expr)
            => block_expr } )
    .or(
      fn { input => Some( (Syntax::Unit, input) ) }
    )
  )
  .map( fn { (((_, expr), if_expr), else_expr)
            => Syntax::If(expr, if_expr, else_expr) } )
  .parse(tokens)
}
test "if_expr: random valid expression with nested if-else and multiple conditions" {
  let tokens = ([
    Token::IF,
    Token::NUMBER("5"),
    Token::EQ,
    Token::NUMBER("5"),
    Token::LCURLYBRACKET,
    Token::IF,
    Token::NUMBER("3"),
    Token::EQ,
    Token::NUMBER("3"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET,
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(if_expr(tokens), content="Some((If(Eq(Int(5), Int(5)), If(Eq(Int(3), Int(3)), Bool(true), Bool(false)), Bool(false)), []))")
}
test "if_expr: missing closing curly bracket" {
  let tokens = ([
    Token::IF,
    Token::NUMBER("5"),
    Token::EQ,
    Token::NUMBER("5"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE
  ])[:]
  inspect!(if_expr(tokens), content="None")
}
test "if_expr: random valid expression with nested if-else" {
  let tokens = ([
    Token::IF,
    Token::NUMBER("5"),
    Token::EQ,
    Token::NUMBER("5"),
    Token::LCURLYBRACKET,
    Token::IF,
    Token::NUMBER("3"),
    Token::EQ,
    Token::NUMBER("3"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET,
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(if_expr(tokens), content="Some((If(Eq(Int(5), Int(5)), If(Eq(Int(3), Int(3)), Bool(true), Bool(false)), Bool(false)), []))")
}
test "if_expr: nested if-else expression" {
  let tokens = ([
    Token::IF,
    Token::NUMBER("5"),
    Token::EQ,
    Token::NUMBER("5"),
    Token::LCURLYBRACKET,
    Token::IF,
    Token::NUMBER("3"),
    Token::EQ,
    Token::NUMBER("3"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET,
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(if_expr(tokens), content="Some((If(Eq(Int(5), Int(5)), If(Eq(Int(3), Int(3)), Bool(true), Bool(false)), Bool(false)), []))")
}
test "if_expr: missing else block" {
  let tokens = ([
    Token::IF,
    Token::NUMBER("5"),
    Token::EQ,
    Token::NUMBER("5"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(if_expr(tokens), content="Some((If(Eq(Int(5), Int(5)), Bool(true), Unit), []))")
}
test "if_expr: valid if-else expression" {
  let tokens = ([
    Token::IF,
    Token::NUMBER("5"),
    Token::EQ,
    Token::NUMBER("5"),
    Token::LCURLYBRACKET,
    Token::TRUE,
    Token::RCURLYBRACKET,
    Token::ELSE,
    Token::LCURLYBRACKET,
    Token::FALSE,
    Token::RCURLYBRACKET
  ])[:]
  inspect!(if_expr(tokens), content="Some((If(Eq(Int(5), Int(5)), Bool(true), Bool(false)), []))")
}

enum Get_or_apply_args{
  Get_arg(Syntax)
  Apply_args(Array[Syntax])
} derive(Show)

fn get_or_apply_level_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(value_expr)
  .and(
    lbracket
      .and(expr)
      .and(rbracket)
      .map( fn { ((_, arg), _) => Get_arg(arg) } )
    .or(
      lparen
      .and(expr)
      .and(
        comma
          .and(expr)
          .map( fn { (_, arg) => arg } )
        .many()
      )
      .and(rparen)
      .map( fn { (((_, arg_0), args), _)
              => {
                args.insert(0, arg_0)
                Apply_args(args) 
              }
            } )
    )
    .or(
      lparen
      .and(rparen)
      .map( fn { _ => Apply_args([]) })
    )
    .many()
  )
  .map( fn { (e, list) => {
              list.fold(
                init = e, 
                fn {
                  e, Get_arg(arg) => Syntax::Get(e, arg)
                  e, Apply_args(args) => Syntax::App(e, args)
                }
              )
            }
        } )
  .parse(tokens)
}
test "get_or_apply_level_expr: multiple cases" {
  inspect!(get_or_apply_level_expr([
    //f[x](y)[z]
    Token::IDENTIFIER("f"), 
    Token::LBRACKET, 
    Token::IDENTIFIER("x"), 
    Token::RBRACKET, 
    Token::LPAREN, 
    Token::IDENTIFIER("y"), 
    Token::RPAREN, 
    Token::LBRACKET, 
    Token::IDENTIFIER("z"), 
    Token::RBRACKET
    ][:]), content=
      #|Some((Get(App(Get(Var("f"), Var("x")), [Var("y")]), Var("z")), []))
    )
}
test "get_or_apply_level_expr: nested expressions" {
  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LPAREN, 
    Token::IDENTIFIER("x"), 
    Token::RPAREN, 
    Token::LPAREN, 
    Token::IDENTIFIER("y"), 
    Token::RPAREN
    ][:]), content=
      #|Some((App(App(Var("f"), [Var("x")]), [Var("y")]), []))
    )

  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LBRACKET, 
    Token::IDENTIFIER("x"), 
    Token::RBRACKET, 
    Token::LBRACKET, 
    Token::IDENTIFIER("y"), 
    Token::RBRACKET
    ][:]), content=
      #|Some((Get(Get(Var("f"), Var("x")), Var("y")), []))
    )
}
test "get_or_apply_level_expr: random valid cases" {
  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LPAREN, 
    Token::IDENTIFIER("x"), 
    Token::COMMA, 
    Token::IDENTIFIER("y"), 
    Token::COMMA, 
    Token::IDENTIFIER("z"), 
    Token::RPAREN
    ][:]), content=
      #|Some((App(Var("f"), [Var("x"), Var("y"), Var("z")]), []))
    )

  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LBRACKET, 
    Token::IDENTIFIER("x"), 
    Token::RBRACKET, 
    Token::LPAREN, 
    Token::IDENTIFIER("y"), 
    Token::RPAREN
    ][:]), content=
      #|Some((App(Get(Var("f"), Var("x")), [Var("y")]), []))
    )

  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LPAREN, 
    Token::IDENTIFIER("x"), 
    Token::RPAREN, 
    Token::LBRACKET, 
    Token::IDENTIFIER("y"), 
    Token::RBRACKET
    ][:]), content=
      #|Some((Get(App(Var("f"), [Var("x")]), Var("y")), []))
    )
}
test "get_or_apply_level_expr: boundary cases" {
  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LPAREN, 
    Token::RPAREN
    ][:]), content=
      #|Some((App(Var("f"), []), []))
    )

  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LBRACKET, 
    Token::RBRACKET
    ][:]), content=
      #|Some((Var("f"), [LBRACKET, RBRACKET]))
    )
}
test "get_or_apply_level_expr: basic functionality" {
  inspect!(get_or_apply_level_expr([
    Token::IDENTIFIER("f"), 
    Token::LPAREN, 
    Token::IDENTIFIER("x"), 
    Token::COMMA, 
    Token::IDENTIFIER("y"), 
    Token::RPAREN
    ][:]), content=
      #|Some((App(Var("f"), [Var("x"), Var("y")]), []))
    )
}

// Value expressions

fn value_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  Parser(unit_expr)
  .or(tuple_expr)
  .or(bool_expr)
  .or(identifier_expr)
  .or(block_expr)
  .or(neg_expr)
  .or(floating_point_expr)
  .or(int_expr)
  .or(not_expr)
  .or(array_make_expr)
  .parse(tokens)
}

fn unit_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // ()
  lparen
  .and(rparen)
  .map( fn { _
            => Syntax::Unit } )
  .parse(tokens)
}

fn tuple_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // (x, y, ...); 1-tuple is not allowed
  lparen
  .and(
    Parser(expr)
    .and(comma)
    .and(expr)
    .and(
      comma
        .and(expr)
        .map( fn { (_, expr) => expr } )
      .many()
    )
    .map( fn { (((element_0, _), element_1), elements) => {
                let element_list = [element_0, element_1]
                element_list.append(elements)
                element_list
              } 
            } )
  )
  .and(rparen)
  .map( fn { ((_, element_list), _)
            => Syntax::Tuple(element_list) } )
  .parse(tokens)
}

test "tuple_expr: valid tuple expressions" {
  inspect!(tuple_expr([
    Token::LPAREN, 
    Token::NUMBER("1"), 
    Token::COMMA, 
    Token::NUMBER("2"), 
    Token::RPAREN
  ][:]), content="Some((Tuple([Int(1), Int(2)]), []))")
  inspect!(tuple_expr([
    Token::LPAREN, 
    Token::TRUE, 
    Token::COMMA, 
    Token::NUMBER("1"), 
    Token::COMMA, 
    Token::NUMBER("2"), 
    Token::DOT, 
    Token::NUMBER("3"), 
    Token::RPAREN
  ][:]), content="Some((Tuple([Bool(true), Int(1), Double(2.3)]), []))")
}

fn block_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // { ... }
  lcurlybracket
  .and(stmt)
  .and(rcurlybracket)
  .map( fn { ((_, body), _)
            => body } )
  .parse(tokens)
}
test "block_expr: valid block expression" {
  let tokens = ([
    Token::LCURLYBRACKET,
    Token::NUMBER("1"), // Assuming stmt returns Syntax::Int(1)
    Token::RCURLYBRACKET
  ])[:]
  inspect!(block_expr(tokens), content="Some((Int(1), []))")
}

fn bool_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // TRUE or FALSE
  bool_true
  .map( fn { _ => Syntax::Bool(true) } )
  .or(
    bool_false
    .map( fn { _ => Syntax::Bool(false) } )
  )
  .parse(tokens)
}
test "bool_expr: valid boolean expressions" {
  inspect!(bool_expr([Token::TRUE][:]), content="Some((Bool(true), []))")
  inspect!(bool_expr([Token::FALSE][:]), content="Some((Bool(false), []))")
}


fn neg_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // TRUE or FALSE
  sub
  .and(value_expr)
  .map( fn { (_, expr)
            => Syntax::Neg(expr, kind = None) } )
  .parse(tokens)
}
test "neg_expr: boundary cases" {
  let tokens = ([
    Token::SUB,
    Token::NUMBER("0"), 
  ])[:]
  inspect!(neg_expr(tokens), content="Some((Neg(Int(0), kind=None), []))")

  let tokens = ([
    Token::SUB,
    Token::NUMBER("2147483647"), 
  ])[:]
  inspect!(neg_expr(tokens), content="Some((Neg(Int(2147483647), kind=None), []))")
}
test "neg_expr: random valid expression with nested neg" {
  let tokens = ([
    Token::SUB,
    Token::SUB,
    Token::INT, // Assuming value_expr returns Syntax::Int(1)
  ])[:]
  inspect!(neg_expr(tokens), content="None")
}
test "neg_expr: valid neg expression" {
  let tokens = ([
    Token::SUB,
    Token::INT, // Assuming value_expr returns Syntax::Int(1)
  ])[:]
  inspect!(neg_expr(tokens), content="None")
}

fn floating_point_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // [0-9]+'.'[0-9]*
  number
  .and(dot)
  .and(
    number
    .or(
      fn { input => Some( (NUMBER(""), input) ) }
    )
  )
  .map( fn { ((NUMBER(whole), _), NUMBER(dec))
            => {
              let whole_length = whole.length()
              let mut whole_value: Double = 0
              for i in 0 ..< whole_length {
                whole_value = whole_value*10.0+(whole[i].to_int()-('0').to_int()).to_double()
              }
              
              let dec_length = dec.length()
              let mut dec_value: Double = 0
              for i = dec_length-1; i >= 0; i = i-1 {
                dec_value = dec_value*0.1+(dec[i].to_int()-('0').to_int()).to_double()
              }
              
              Syntax::Double(whole_value+dec_value*0.1)
            }
          } )
  .parse(tokens)
}
test "floating_point_expr: edge cases with leading zeros" {
  inspect!(floating_point_expr([Token::NUMBER("001"),Token::DOT,Token::NUMBER("001")][:]), content="Some((Double(1.001), []))")
  inspect!(floating_point_expr([Token::NUMBER("000"),Token::DOT,Token::NUMBER("000")][:]), content="Some((Double(0), []))")
  inspect!(floating_point_expr([Token::NUMBER("000"),Token::DOT,Token::NUMBER("1")][:]), content="Some((Double(0.1), []))")
}
test "floating_point_expr: random invalid cases" {
  inspect!(floating_point_expr([Token::NUMBER("123"),Token::DOT,Token::SUB][:]), content="Some((Double(123), [SUB]))")
  inspect!(floating_point_expr([Token::NUMBER("123"),Token::DOT,Token::MUL][:]), content="Some((Double(123), [MUL]))")
  inspect!(floating_point_expr([Token::NUMBER("123"),Token::DOT,Token::DIV][:]), content="Some((Double(123), [DIV]))")
  inspect!(floating_point_expr([Token::NUMBER("123"),Token::DOT,Token::LBRACKET][:]), content="Some((Double(123), [LBRACKET]))")
  inspect!(floating_point_expr([Token::NUMBER("123"),Token::DOT,Token::RBRACKET][:]), content="Some((Double(123), [RBRACKET]))")
}
test "floating_point_expr: boundary cases" {
  inspect!(floating_point_expr([Token::NUMBER("0"),Token::DOT,Token::NUMBER("0")][:]), content="Some((Double(0), []))")
  inspect!(floating_point_expr([Token::NUMBER("999999"),Token::DOT,Token::NUMBER("999")][:]), content="Some((Double(999999.999), []))")
  inspect!(floating_point_expr([Token::NUMBER("1"),Token::DOT,Token::NUMBER("0")][:]), content="Some((Double(1), []))")
  inspect!(floating_point_expr([Token::NUMBER("0"),Token::DOT,Token::NUMBER("1")][:]), content="Some((Double(0.1), []))")
}
test "floating_point_expr: random valid cases" {
  inspect!(floating_point_expr([Token::NUMBER("123"),Token::DOT,Token::NUMBER("456")][:]), content="Some((Double(123.456), []))")
  inspect!(floating_point_expr([Token::NUMBER("0"),Token::DOT,Token::NUMBER("001")][:]), content="Some((Double(0.0010000000000000002), []))")
  inspect!(floating_point_expr([Token::NUMBER("987654"),Token::DOT,Token::NUMBER("321")][:]), content="Some((Double(987654.321), []))")
  inspect!(floating_point_expr([Token::NUMBER("123"),Token::DOT][:]), content="Some((Double(123), []))")
  inspect!(floating_point_expr([Token::NUMBER("100"),Token::DOT,Token::NUMBER("000")][:]), content="Some((Double(100), []))")
}

fn int_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // [0-9]+
  number
  .map( fn! { NUMBER(str)
            => {
              let length = str.length()
              let mut value: Int = 0
              
              guard(length <= 10) else { 
                raise ParseErr("Parsing Error: Int value out of range.") 
              }
              for i in 0 ..< length-1 {
                value = value*10+str[i].to_int()-('0').to_int()
              }
              let digit = str[length-1].to_int()-('0').to_int()
              
              if value > max_Int/10 || (value == max_Int/10 && digit > max_Int%10) {
                raise ParseErr("Parsing Error: Int value out of range.")
              }
              value = value*10 + digit
              
              Syntax::Int(value)
            }
          } )
  .parse(tokens)
}
test "int_expr: invalid cases" {
  inspect!(int_expr([Token::NUMBER("2147483648")][:]), content="None") // Out of range
  inspect!(int_expr([Token::NUMBER("9999999999")][:]), content="None") // Out of range
}
test "int_expr: random invalid cases" {
  inspect!(int_expr([Token::NUMBER("12345678901")][:]), content="None") // Out of range
  inspect!(int_expr([Token::NUMBER("123456789012")][:]), content="None") // Out of range
  inspect!(int_expr([Token::NUMBER("1234567890123")][:]), content="None") // Out of range
  inspect!(int_expr([Token::NUMBER("12345678901234")][:]), content="None") // Out of range
  inspect!(int_expr([Token::NUMBER("123456789012345")][:]), content="None") // Out of range
}
test "int_expr: edge cases with leading zeros" {
  inspect!(int_expr([Token::NUMBER("001")][:]), content="Some((Int(1), []))")
  inspect!(int_expr([Token::NUMBER("0000000001")][:]), content="Some((Int(1), []))")
  inspect!(int_expr([Token::NUMBER("0000000000")][:]), content="Some((Int(0), []))")
}
test "int_expr: random valid cases" {
  inspect!(int_expr([Token::NUMBER("12345")][:]), content="Some((Int(12345), []))")
  inspect!(int_expr([Token::NUMBER("987654321")][:]), content="Some((Int(987654321), []))")
  inspect!(int_expr([Token::NUMBER("1")][:]), content="Some((Int(1), []))")
  inspect!(int_expr([Token::NUMBER("10")][:]), content="Some((Int(10), []))")
  inspect!(int_expr([Token::NUMBER("123")][:]), content="Some((Int(123), []))")
  inspect!(int_expr([Token::NUMBER("456789")][:]), content="Some((Int(456789), []))")
}
test "int_expr: boundary cases" {
  inspect!(int_expr([Token::NUMBER("0")][:]), content="Some((Int(0), []))")
  inspect!(int_expr([Token::NUMBER("2147483647")][:]), content="Some((Int(2147483647), []))")
  // inspect!(int_expr([Token::NUMBER("2147483648")][:]), content="None") // Out of range
}



fn not_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // not(x)
  bool_not
  .and(lparen)
  .and(expr)
  .and(rparen)
  .map( fn { (((_, _), expr), _)
            => Syntax::Not(expr) } )
  .parse(tokens)
}
test "not_expr: random valid expression with nested not" {
  let tokens = ([
    Token::NOT,
    Token::LPAREN,
    Token::NOT,
    Token::LPAREN,
    Token::TRUE,
    Token::RPAREN,
    Token::RPAREN
  ])[:]
  inspect!(not_expr(tokens), content="Some((Not(Not(Bool(true))), []))")
}
test "not_expr: invalid token sequence" {
  let tokens = ([
    Token::NOT,
    Token::LPAREN,
    Token::ADD,
    Token::RPAREN
  ])[:]
  inspect!(not_expr(tokens), content="None")
}
test "not_expr: valid not expression" {
  let tokens = ([
    Token::NOT,
    Token::LPAREN,
    Token::TRUE,
    Token::RPAREN
  ])[:]
  inspect!(not_expr(tokens), content="Some((Not(Bool(true)), []))")
}

fn array_make_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // Array::make(x, y)
  array
  .and(colon)
  .and(colon)
  .and(ctrl_make)
  .and(lparen)
  .and(expr)
  .and(comma)
  .and(expr)
  .and(rparen)
  .map( fn { ((((((((_, _), _), _), _), x), _), y), _)
            => Syntax::Array(x, y) } )
  .parse(tokens)
}
test "array_make_expr: random valid expression with array type" {
  let tokens = ([
    Token::ARRAY,
    Token::COLON,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    
    Token::ARRAY,
    Token::COLON,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    Token::NUMBER("1"),
    Token::COMMA,
    Token::NUMBER("1"),
    Token::RPAREN,
    
    Token::COMMA,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("5"),
    Token::RPAREN
  ])[:]
  inspect!(array_make_expr(tokens), content="Some((Array(Array(Int(1), Int(1)), Double(2.5)), []))")
}
test "array_make_expr: random valid expression with nested tuple" {
  let tokens = ([
    Token::ARRAY,
    Token::COLON,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    
    Token::LPAREN,
    Token::NUMBER("1"),
    Token::COMMA,
    Token::NUMBER("2"),
    Token::RPAREN,
    
    Token::COMMA,
    Token::TRUE, // Assuming expr returns Syntax::Bool(true)
    Token::RPAREN
  ])[:]
  inspect!(array_make_expr(tokens), content="Some((Array(Tuple([Int(1), Int(2)]), Bool(true)), []))")
}
test "array_make_expr: missing colon colon" {
  let tokens = ([
    Token::ARRAY,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    Token::INT, // Assuming expr returns Syntax::Int(1)
    Token::COMMA,
    Token::DOUBLE, // Assuming expr returns Syntax::Double(2.0)
    Token::RPAREN
  ])[:]
  inspect!(array_make_expr(tokens), content="None")
}
test "array_make_expr: missing closing parenthesis" {
  let tokens = ([
    //Array::make(Int,Double
    Token::ARRAY,
    Token::COLON,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    Token::INT, // Assuming expr returns Syntax::Int(1)
    Token::COMMA,
    Token::DOUBLE // Assuming expr returns Syntax::Double(2.0)
  ])[:]
  inspect!(array_make_expr(tokens), content="None")
}
test "array_make_expr: valid Array::make(x, y) expression" {
  let tokens = ([
    Token::ARRAY,
    Token::COLON,
    Token::COLON,
    Token::MAKE,
    Token::LPAREN,
    Token::NUMBER("1"),
    Token::COMMA,
    Token::NUMBER("2"),
    Token::DOT,
    Token::NUMBER("0"),
    Token::RPAREN
  ])[:]
  inspect!(array_make_expr(tokens), content="Some((Array(Int(1), Double(2)), []))")
}

fn identifier_expr(tokens: ArrayView[Token]) -> (Syntax, ArrayView[Token])?{
  // x
  identifier
  .map( fn { IDENTIFIER(id)
            => Syntax::Var(id) } )
  .parse(tokens)
}
test "identifier_expr: identifier with numbers" {
  let tokens = ([
    Token::IDENTIFIER("x123")
  ])[:]
  inspect!(identifier_expr(tokens), content="Some((Var(\"x123\"), []))")
}
test "identifier_expr: multiple identifiers" {
  let tokens = ([
    Token::IDENTIFIER("x"),
    Token::IDENTIFIER("y")
  ])[:]
  inspect!(identifier_expr(tokens), content="Some((Var(\"x\"), [IDENTIFIER(\"y\")]))")
}

fn typ(tokens: ArrayView[Token]) -> (Type, ArrayView[Token])?{
  unit
  .map( fn { _ => Type::Unit })
  .or(
    bool
    .map( fn { _ => Type::Bool })
  )
  .or(
    int
    .map( fn { _ => Type::Int })
  )
  .or(
    double
    .map( fn { _ => Type::Double })
  )
  .or(
    Parser(array_type)
  )
  .or(
    Parser(function_type)
  )
  .or(
    Parser(tuple_type)
  )
  .parse(tokens)
}
test "typ function test cases" {
  // Boundary cases
  inspect!(typ([Token::UNIT][:]), content="Some((Unit, []))")
  inspect!(typ([Token::BOOL][:]), content="Some((Bool, []))")
  inspect!(typ([Token::INT][:]), content="Some((Int, []))")
  inspect!(typ([Token::DOUBLE][:]), content="Some((Double, []))")

  // Random cases
  inspect!(typ([Token::ARRAY, Token::LBRACKET, Token::INT, Token::RBRACKET][:]), content="Some((Array(Int), []))")
  inspect!(typ([Token::LPAREN, Token::INT, Token::COMMA, Token::DOUBLE, Token::RPAREN][:]), content="Some((Tuple([Int, Double]), []))")
  inspect!(typ([Token::LPAREN, Token::INT, Token::COMMA, Token::DOUBLE, Token::RPAREN, Token::ARROW, Token::BOOL][:]), content="Some((Fun([Int, Double], Bool), []))")

  // Edge cases
  inspect!(typ([Token::LPAREN, Token::INT, Token::COMMA, Token::DOUBLE][:]), content="None") // Missing closing parenthesis
  inspect!(typ([Token::ARRAY, Token::LBRACKET, Token::INT][:]), content="None") // Missing closing bracket
  inspect!(typ([Token::LPAREN, Token::INT, Token::COMMA, Token::DOUBLE, Token::RPAREN, Token::ARROW][:]), content="Some((Tuple([Int, Double]), [ARROW]))") // Missing return type in function type
}

fn array_type(tokens: ArrayView[Token]) -> (Type, ArrayView[Token])?{
  // Array[_]
  array
  .and(lbracket)
  .and(typ)
  .and(rbracket)
  .map( fn { (((_, _), typ), _)
            => Type::Array(typ) } )
  .parse(tokens)
}
test "array_type: valid Array[_] type" {
  let tokens = ([
    Token::ARRAY,
    Token::LBRACKET,
    Token::INT,
    Token::RBRACKET
  ])[:]
  inspect!(array_type(tokens), content="Some((Array(Int), []))")
}
test "array_type: missing closing bracket" {
  let tokens = ([
    Token::ARRAY,
    Token::LBRACKET,
    Token::INT
  ])[:]
  inspect!(array_type(tokens), content="None")
}
test "array_type: invalid token sequence" {
  let tokens = ([
    Token::ARRAY,
    Token::LBRACKET,
    Token::ADD,
    Token::RBRACKET
  ])[:]
  inspect!(array_type(tokens), content="None")
}

fn tuple_type(tokens: ArrayView[Token]) -> (Type, ArrayView[Token])?{
  // (_, _, _)
  lparen
  .and(
    Parser(typ)
    .and(comma)
    .and(typ)
    .and(
      comma
        .and(typ)
        .map( fn { (_, typ) => typ } )
      .many()
    )
    .map( fn { (((element_0, _), element_1), elements) => {
                let element_list = [element_0, element_1]
                element_list.append(elements)
                element_list
              } 
            } )
  )
  .and(rparen)
  .map( fn { ((_, element_list), _)
            => Type::Tuple(element_list) } )
  .parse(tokens)
}
test "tuple_type: valid tuple type" {
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE,
    Token::COMMA,
    Token::BOOL,
    Token::RPAREN
  ])[:]
  inspect!(tuple_type(tokens), content="Some((Tuple([Int, Double, Bool]), []))")
}
test "tuple_type: single element tuple" {
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::RPAREN
  ])[:]
  inspect!(tuple_type(tokens), content="None") // Single element tuple should fail
}
test "tuple_type: random valid tuple type with nested tuple" {
  let tokens = ([
    Token::LPAREN,
    Token::BOOL,
    Token::COMMA,
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE,
    Token::RPAREN,
    Token::COMMA,
    Token::ARRAY,
    Token::LBRACKET,
    Token::INT,
    Token::RBRACKET,
    Token::RPAREN
  ])[:]
  inspect!(tuple_type(tokens), content="Some((Tuple([Bool, Tuple([Int, Double]), Array(Int)]), []))")
}

fn function_type(tokens: ArrayView[Token]) -> (Type, ArrayView[Token])?{
  // (_, _, _)
  lparen
  .and(
    Parser(typ)
    .and(
      comma
        .and(typ)
        .map( fn { (_, typ) => typ } )
      .many()
    )
    .map( fn { (arg, args) => {
                args.insert(0, arg)
                args
              } 
            } )
  )
  .and(rparen)
  .and(arrow)
  .and(typ)
  .map( fn { ((((_, arg_list), _), _), typ)
            => Type::Fun(arg_list, typ) } )
  .parse(tokens)
}
test "function_type: valid function type" {
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL
  ])[:]
  inspect!(function_type(tokens), content="Some((Fun([Int, Double], Bool), []))")
}
test "function_type: single argument function" {
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::RPAREN,
    Token::ARROW,
    Token::DOUBLE
  ])[:]
  inspect!(function_type(tokens), content="Some((Fun([Int], Double), []))")
}
test "function_type: missing closing parenthesis" {
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE
  ])[:]
  inspect!(function_type(tokens), content="None")
}
test "function_type: missing arrow" {
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE,
    Token::RPAREN,
    Token::BOOL
  ])[:]
  inspect!(function_type(tokens), content="None")
}
test "function_type: nested function type" {
  //(Int,(Double,Bool)->Unit)->Array(Int)
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::LPAREN,
    Token::DOUBLE,
    Token::COMMA,
    Token::BOOL,
    Token::RPAREN,
    Token::ARROW,
    Token::UNIT,
    Token::RPAREN,
    Token::ARROW,
    Token::ARRAY,
    Token::LBRACKET,
    Token::INT,
    Token::RBRACKET
  ])[:]
  inspect!(function_type(tokens), content="Some((Fun([Int, Fun([Double, Bool], Unit)], Array(Int)), []))")
}
test "function_type: random valid function type with nested tuple" {
  let tokens = ([
    Token::LPAREN,
    Token::BOOL,
    Token::COMMA,
    Token::LPAREN,
    Token::INT,
    Token::COMMA,
    Token::DOUBLE,
    Token::RPAREN,
    Token::COMMA,
    Token::ARRAY,
    Token::LBRACKET,
    Token::INT,
    Token::RBRACKET,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL
  ])[:]
  inspect!(function_type(tokens), content="Some((Fun([Bool, Tuple([Int, Double]), Array(Int)], Bool), []))")
}
test "function_type: invalid token sequence" {
  let tokens = ([
    Token::LPAREN,
    Token::INT,
    Token::ADD,
    Token::DOUBLE,
    Token::RPAREN,
    Token::ARROW,
    Token::BOOL
  ])[:]
  inspect!(function_type(tokens), content="None")
}

// End: 多元素表达式对应组合子