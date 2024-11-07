test "int_literal" {
  let input = "fn make_adder(x: Int) -> (Int) -> Int {fn adder(y: Int) -> Int {x + y};adder};fn main {print_int((make_adder(3))(7))};";
  let result = tokens.parse(input);  // 假设 `int_literal` 用于解析整数字面量
  
  inspect!(result, content= 
    #|Some(("FN, IDENTIFIER("make_adder"), LPAREN, IDENTIFIER("x"), COLON, INT, RPAREN, ARROW, LPAREN, INT, RPAREN, ARROW, INT, LCURLYBRACKET, FN, IDENTIFIER("adder"), LPAREN, IDENTIFIER("y"), COLON, INT, RPAREN, ARROW, INT, LCURLYBRACKET, IDENTIFIER("x"), ADD, IDENTIFIER("y"), RCURLYBRACKET, SEMICOLON, IDENTIFIER("adder"), RCURLYBRACKET, SEMICOLON, FN, IDENTIFIER("main"), LCURLYBRACKET, IDENTIFIER("print_int"), LPAREN, LPAREN, IDENTIFIER("make_adder"), LPAREN, NUMBER("3"), RPAREN, RPAREN, LPAREN, NUMBER("7"), RPAREN, RPAREN, RCURLYBRACKET, SEMICOLON, UNIT"))
  );
}
test "token" {
  let input = "sdf ret";
  let result = value.or(whitespace).or(identifier).many().parse(input);
  
  inspect!(result, content= 
    #|Some((, ""))
  );
}
test "operator" {
  let input = "54 545 ";
  let result = value.and(whitespace.many()).many().parse(input);  // 假设 `symbol1` 用于解析符号
  
  inspect!(result, content= 
    #|Some((, ""))
  );
}

test "keyword" {
  let input = "Int fib == 1";
  let result = tokens.parse(input);  // 假设 `keyword` 用于解析关键字
  
  inspect!(result, content= 
    #|Some(( ""))
  );
}
// test "comment" {
//   let input = "// this is a comment";
//   let result = tokens.parse(input);  // 假设 `comment` 用于解析注释
  
//   inspect!(result, content= 
//     #|Some((Token::COMMENT, "")) 
//   );
// }
test "combination" {
  let input = "Int t";
    let result = tokens.parse(input);  // 假设 `tokens` 用于解析多个 Token

    inspect!(result, content=
        #|Some(([INT], Identifier("x"), [EQ], NUMBER("1"), ""))
        );
}


test "combination2" {
    let input = "fn fib(n: Int) -> Int { if n < 2 { n } else { fib(n - 1) + fib(n - 2) } }";
    let result = tokens.parse(input);  // 假设 `tokens` 用于解析多个 Token

    inspect!(result, content=
        #|Some((Array[Token]::from([Token::FN, Token::IDENTIFIER("fib"), Token::LPAREN, Token::IDENTIFIER("n"), Token::COLON, Token::INT, Token::RPAREN, Token::ARROW, Token::INT, Token::LCURLYBRACKET, Token::IF, Token::IDENTIFIER("n"), Token::LT, Token::INT_LITERAL(2), Token::LCURLYBRACKET, Token::IDENTIFIER("n"), Token::RCURLYBRACKET, Token::ELSE, Token::LCURLYBRACKET, Token::IDENTIFIER("fib"), Token::LPAREN, Token::IDENTIFIER("n"), Token::SUB, Token::INT_LITERAL(1), Token::RPAREN, Token::ADD, Token::IDENTIFIER("fib"), Token::LPAREN, Token::IDENTIFIER("n"), Token::SUB, Token::INT_LITERAL(2), Token::RPAREN, Token::RCURLYBRACKET, Token::RCURLYBRACKET, Token::RCURLYBRACKET]), ""))
    );
}