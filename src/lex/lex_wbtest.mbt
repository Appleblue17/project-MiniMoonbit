test "adder" {
  let input = "fn make_adder(x: Int) -> (Int) -> Int {fn adder(y: Int) -> Int {x + y};adder};fn main {print_int((make_adder(3))(7))};";
  let result = tokens.parse(input);  // 假设 `int_literal` 用于解析整数字面量
  
  inspect!(result, content= 
    #|Some(([FN, IDENTIFIER("make_adder"), LPAREN, IDENTIFIER("x"), COLON, INT, RPAREN, ARROW, LPAREN, INT, RPAREN, ARROW, INT, LCURLYBRACKET, FN, IDENTIFIER("adder"), LPAREN, IDENTIFIER("y"), COLON, INT, RPAREN, ARROW, INT, LCURLYBRACKET, IDENTIFIER("x"), ADD, IDENTIFIER("y"), RCURLYBRACKET, SEMICOLON, IDENTIFIER("adder"), RCURLYBRACKET, SEMICOLON, FN, IDENTIFIER("main"), LCURLYBRACKET, IDENTIFIER("print_int"), LPAREN, LPAREN, IDENTIFIER("make_adder"), LPAREN, NUMBER("3"), RPAREN, RPAREN, LPAREN, NUMBER("7"), RPAREN, RPAREN, RCURLYBRACKET, SEMICOLON, UNIT], ""))
  );
}