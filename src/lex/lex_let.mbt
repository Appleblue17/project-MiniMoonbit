// 词法分析器
// 将源代码转换为 Token 流，Token 流是一个由 Token 组成的序列，每个 Token 代表一个词法单元。
// 有限状态自动机，每个状态对应一个函数，函数的输入是源代码字符串，输出是 Token 流。


let whitespace : Lexer[Token] = pchar(fn{
   ' ' | '\t' | '\r' | '\n' => true
    _ => false
   }).map(fn{ ' ' => Ok(Token::WS) 
    '\t' => Ok(Token::WS) 
    '\r' => Ok(Token::WS) 
    '\n' => Ok(Token::WS) 
    _ => Err(ParseErr::Message("Unknown whitespace"))})

let comment: Lexer[Token] = 
    pstring(fn { str => str.starts_with("//") })
    .map(fn { _ => Ok(Token::COMMENT) })



let symbol1: Lexer[Token] = pchar(fn{
 '+' | '-' | '*' | '/' | '(' | ')' | '=' | '[' | ']' | '{' | '}' | ',' | ';' | ':' | '.' => true
 _ => false
 }).map(fn{
 '+' => Ok(Token::ADD); '-' => Ok(Token::SUB); '*' => Ok(Token::MUL); '/' => Ok(Token::DIV);
 '=' => Ok(Token::ASSIGN); '(' => Ok(Token::LPAREN); ')' => Ok(Token::RPAREN);
 '[' => Ok(Token::LBRACKET); ']' => Ok(Token::RBRACKET); '{' => Ok(Token::LCURLYBRACKET);
  '}' => Ok(Token::RCURLYBRACKET); ',' => Ok(Token::COMMA); ';' => Ok(Token::SEMICOLON);
  ':' => Ok(Token::COLON); '.' => Ok(Token::DOT)
  _ => Err(ParseErr::Message("Unknown symbol"))
 })

let keyword: Lexer[Token] = 
    pstring(fn { ch => ch.to_string() == "true" ||
     ch.to_string() == "false" ||
     ch.to_string() == "Unit" ||
     ch.to_string() == "Bool" ||
     ch.to_string() == "Int" ||
     ch.to_string() == "Double" ||
     ch.to_string() == "Array" ||
     ch.to_string() == "if" ||
     ch.to_string() == "else" ||
     ch.to_string() == "fn" ||
     ch.to_string() == "let" ||
     ch.to_string() == "make" ||
     ch.to_string() == "not"
    }) // 添加所有关键字
    .map(fn { 
            "true" => Ok(Token::TRUE)
            "false" => Ok(Token::FALSE)
            "Unit" => Ok(Token::UNIT)
            "Bool" => Ok(Token::BOOL)
            "Int" => Ok(Token::INT)
            "Double" => Ok(Token::DOUBLE)
            "Array" => Ok(Token::ARRAY)
            "if" => Ok(Token::IF)
            "else" => Ok(Token::ELSE)
            "fn" => Ok(Token::FN)
            "let" => Ok(Token::LET)
            "make" => Ok(Token::MAKE)
            "not" => Ok(Token::NOT)
            _ => Err(ParseErr::Message("Unknown keyword"))
})

let symbol2: Lexer[Token] = pstring(fn{
  "==" | "<=" | "->" => true
  _ => false
}).map(fn{
  "==" => Ok(Token::EQ); "<=" => Ok(Token::LE); "->" => Ok(Token::ARROW)
  _ => Err(ParseErr::Message("Unknown symbol"))

})

// 数字
let zero: Lexer[Int] =
pchar(fn{ ch => ch == '0' }).map(fn{ _ => Ok(0) })
let one_to_nine: Lexer[Int] =
pchar(fn{ ch => ch.to_int() >= 0x31 && ch.to_int() <= 0x39 }).map(fn { ch => Ok(ch.to_int() - 0x30) })
let zero_to_nine: Lexer[Int] =
pchar(fn{ ch => ch.to_int() >= 0x30 && ch.to_int() <= 0x39 }).map(fn { ch => Ok(ch.to_int() - 0x30) })

// 转换成整数
let value: Lexer[Token] = 
    zero
    .or(one_to_nine.and(zero_to_nine.many())
    .map(fn{(i, ls) => fold_left_list(i, ls, fn{acc, j => acc * 10 + j })}))
    .map(fn{ value => Ok(Token::NUMBER(value.to_string())) })

fn fold_left_list(init: Int, list: Array[Int], f: (Int, Int) -> Int) -> Result[Int, ParseErr] {
  let mut result = init;
   for item in list {
        result = f(result, item); // 将当前结果和列表元素传入函数
    }
    // 返回成功的结果
    Ok(result)
}


// 处理标识符
let identifier: Lexer[Token] = pstring(fn { 
    (ch) => (is_letter(ch[0]) || ch[0] == '_') && 
             all(to_char(ch),fn(c) { is_letter(c) || is_digit(c) || c == '_' }) 
})
.map(fn { id => Ok(Token::IDENTIFIER(id)) });

fn all[Value](array: Array[Value], pred: (Value) -> Bool) -> Bool {
    for item in array {
        if not(pred(item)) {
            return false; // 如果有一个元素不满足条件，返回 false
        }
    }
    return true; // 如果所有元素都满足条件，返回 true
}
