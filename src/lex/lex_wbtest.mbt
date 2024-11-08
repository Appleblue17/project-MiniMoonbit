test "adder" {
  let input = "fn make_adder(x: Int) -> (Int) -> Int {fn adder(y: Int) -> Int {x + y};adder};fn main {print_int((make_adder(3))(7))};";
  let result = tokens.parse(input);  // 假设 `int_literal` 用于解析整数字面量
  
  inspect!(result, content= 
    #|Some(([FN, IDENTIFIER("make_adder"), LPAREN, IDENTIFIER("x"), COLON, INT, RPAREN, ARROW, LPAREN, INT, RPAREN, ARROW, INT, LCURLYBRACKET, FN, IDENTIFIER("adder"), LPAREN, IDENTIFIER("y"), COLON, INT, RPAREN, ARROW, INT, LCURLYBRACKET, IDENTIFIER("x"), ADD, IDENTIFIER("y"), RCURLYBRACKET, SEMICOLON, IDENTIFIER("adder"), RCURLYBRACKET, SEMICOLON, FN, IDENTIFIER("main"), LCURLYBRACKET, IDENTIFIER("print_int"), LPAREN, LPAREN, IDENTIFIER("make_adder"), LPAREN, NUMBER("3"), RPAREN, RPAREN, LPAREN, NUMBER("7"), RPAREN, RPAREN, RCURLYBRACKET, SEMICOLON, UNIT], ""))
  );
}

test "fib" {
  let input = "fn fib(n: Int) -> Int { if n <= 1 { n } else { fib(n - 1) + fib(n - 2) } }; fn main { print_int(fib(30)) };"
  let result = tokens.parse(input);  // 假设 `int_literal` 用于解析整数字面量

  inspect!(result, content= 
    #|Some(([FN, IDENTIFIER("fib"), LPAREN, IDENTIFIER("n"), COLON, INT, RPAREN, ARROW, INT, LCURLYBRACKET, IF, IDENTIFIER("n"), LE, NUMBER("1"), LCURLYBRACKET, IDENTIFIER("n"), RCURLYBRACKET, ELSE, LCURLYBRACKET, IDENTIFIER("fib"), LPAREN, IDENTIFIER("n"), SUB, NUMBER("1"), RPAREN, ADD, IDENTIFIER("fib"), LPAREN, IDENTIFIER("n"), SUB, NUMBER("2"), RPAREN, RCURLYBRACKET, RCURLYBRACKET, SEMICOLON, FN, IDENTIFIER("main"), LCURLYBRACKET, IDENTIFIER("print_int"), LPAREN, IDENTIFIER("fib"), LPAREN, NUMBER("30"), RPAREN, RPAREN, RCURLYBRACKET, SEMICOLON, UNIT], ""))
  );
}

test "non-tail-if2"{
  let input = "2add2;";
  let result = tokens.parse(input);  // 假设 `int_literal` 用于解析整数字面量

  inspect!(result, content= 
    #|Some(([NUMBER("2"), IDENTIFIER("add2"), SEMICOLON, UNIT], ""))
  );
}