
// package moonbitlang/minimbt/lex


// Types and methods
// 定义跳过空白符和注释的解析器
let skip_whitespace_and_comments: Lexer[Unit] =
    whitespace.many()
    .or(comment.many())
    .map(fn { (_) => Ok(()) });  // 跳过空白符和注释，Unit 类型表示没有返回值

pub let tokens: Lexer[Array[Token]] =
 value
 .or(symbol1).or(keyword).or(symbol2).or(comment).or(identifier).and(skip_whitespace_and_comments)
.map(fn { (symbols, _) => 
Ok(symbols) }) // 忽略空格
.many()

// pub fn (tokens: ArrayView[Token]) -> Syntax {
//   let result = top_level(tokens)
// Type aliases

// Traits

// Extension Methods

test "identifier" {
  let input = "fib";
  let result = tokens.parse(input);
  
  inspect!(result, content= 
    #|Some((Token::IDENTIFIER("fib"), "")) 
  );
}
test "operator" {
  let input = "+";
  let result = tokens.parse(input);  // 假设 `symbol1` 用于解析符号
  
  inspect!(result, content= 
    #|Some((Token::ADD, "")) 
  );
}
test "operator" {
  let input = "+";
  let result = tokens.parse(input);  // 假设 `symbol1` 用于解析符号
  
  inspect!(result, content= 
    #|Some((Token::ADD, "")) 
  );
}
test "keyword" {
  let input = "if";
  let result = tokens.parse(input);  // 假设 `keyword` 用于解析关键字
  
  inspect!(result, content= 
    #|Some((Token::IF, "")) 
  );
}
test "comment" {
  let input = "// this is a comment";
  let result = tokens.parse(input);  // 假设 `comment` 用于解析注释
  
  inspect!(result, content= 
    #|Some((Token::COMMENT, "")) 
  );
}
test "combination" {
  let input = "INT fib = 1";
    let result = tokens.parse(input);  // 假设 `tokens` 用于解析多个 Token

    inspect!(result, content=
        #|Some((Array[Token]::from([Token::INT, Token::IDENTIFIER("fib"), Token::ASSIGN, Token::INT_LITERAL(1)]), ""))
        );
}

test "combination2" {
    let input = "fn fib(n: Int) -> Int { if n < 2 { n } else { fib(n - 1) + fib(n - 2) } }";
    let result = tokens.parse(input);  // 假设 `tokens` 用于解析多个 Token

    inspect!(result, content=
        #|Some((Array[Token]::from([Token::FN, Token::IDENTIFIER("fib"), Token::LPAREN, Token::IDENTIFIER("n"), Token::COLON, Token::INT, Token::RPAREN, Token::ARROW, Token::INT, Token::LCURLYBRACKET, Token::IF, Token::IDENTIFIER("n"), Token::LT, Token::INT_LITERAL(2), Token::LCURLYBRACKET, Token::IDENTIFIER("n"), Token::RCURLYBRACKET, Token::ELSE, Token::LCURLYBRACKET, Token::IDENTIFIER("fib"), Token::LPAREN, Token::IDENTIFIER("n"), Token::SUB, Token::INT_LITERAL(1), Token::RPAREN, Token::ADD, Token::IDENTIFIER("fib"), Token::LPAREN, Token::IDENTIFIER("n"), Token::SUB, Token::INT_LITERAL(2), Token::RPAREN, Token::RCURLYBRACKET, Token::RCURLYBRACKET, Token::RCURLYBRACKET]), ""))
    );
}