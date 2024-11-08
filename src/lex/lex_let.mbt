// 词法分析器
// 将源代码转换为 Token 流，Token 流是一个由 Token 组成的序列，每个 Token 代表一个词法单元。
// 有限状态自动机，每个状态对应一个函数，函数的输入是源代码字符串，输出是 Token 流。


// 解析空白符
let whitespace : Lexer[Token] = pchar(fn{
   ' ' | '\t' | '\r' | '\n' => true
    _ => false
   }).map(fn{ ' ' => Ok(Token::WS) 
    '\t' => Ok(Token::WS) 
    '\r' => Ok(Token::WS) 
    '\n' => Ok(Token::WS) 
    _ => Err(ParseErr::Message("Unknown whitespace"))})

// let icc: Lexer[String] = pstring(2,fn{ 
//     ch => ch.starts_with("//") 
//     }) // 匹配注释
//     .map(fn{ _ => Ok(ch) })

// 解析注释
// let comment: Lexer[Token] = 
//     icc.and(icc.many()) // 获取多个标识符
//     .map(fn {
//          (i, ls) => adding_string( to_string_char_mini(i) , to_string_char(ls), fn{ acc, item => acc + item }) 
//          })
//     .map(fn { ids => Ok(Token::IDENTIFIER(ids)) })

// 组合出的跳过空白和注释的解析器
// let skip_whitespace_and_comments: Lexer[Unit] =
//     whitespace.many()
//     .map(fn { (_) => Ok(()) });  // 跳过空白符和注释，Unit 类型表示没有返回值

// 解析符号
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


// 解析其他符号
let symbol2: Lexer[Token] = 
    pstring2(2,fn{ ch =>
    ch.starts_with("==") ||
    ch.starts_with("<=") ||
    ch.starts_with("->")
}).map(fn{
  "==" => Ok(Token::EQ); "<=" => Ok(Token::LE); "->" => Ok(Token::ARROW)
  _ => Err(ParseErr::Message(""))

})


// 解析关键字
let keyword2: Lexer[Token] = 
    pstring(2,fn { ch => 
    ch.starts_with("fn") ||
    ch.starts_with("if")
    }) // 添加所有关键字
    .map(fn { 
            "if" => Ok(Token::IF)
            "fn" => Ok(Token::FN)
            _ => Err(ParseErr::Message(""))
})

let keyword3: Lexer[Token] = 
    pstring(3,fn { ch => 
    ch.starts_with("Int") ||
    ch.starts_with("let") ||
    ch.starts_with("not")
    }) // 添加所有关键字
    .map(fn { 
            "Int" => Ok(Token::INT)
            "let" => Ok(Token::LET)
            "not" => Ok(Token::NOT)
            _ => Err(ParseErr::Message(""))
})

let keyword4: Lexer[Token] = 
    pstring(4,fn { ch => 
    ch.starts_with("true") ||
    ch.starts_with("Unit") ||
    ch.starts_with("Bool") ||
    ch.starts_with("else") ||
    ch.starts_with("make")
    }) // 添加所有关键字
    .map(fn { 
            "true" => Ok(Token::TRUE)
            "Unit" => Ok(Token::UNIT)
            "Bool" => Ok(Token::BOOL)
            "else" => Ok(Token::ELSE)
            "make" => Ok(Token::MAKE)
            _ => Err(ParseErr::Message(""))
})

let keyword5: Lexer[Token] = 
    pstring(5,fn { ch => 
    ch.starts_with("false") ||
    ch.starts_with("Array")
    }) // 添加所有关键字
    .map(fn { 
            "false" => Ok(Token::FALSE)
            "Array" => Ok(Token::ARRAY)
            _ => Err(ParseErr::Message(""))
})

let keyword6: Lexer[Token] = 
    pstring(6,fn { ch => 
    ch.starts_with("Double")
    }) // 添加所有关键字
    .map(fn { 
            "Double" => Ok(Token::DOUBLE)
            _ => Err(ParseErr::Message(""))
})

// 解析数字
let zero: Lexer[Int] =
pchar(fn{ ch => ch == '0' }).map(fn{ _ => Ok(0) })
let one_to_nine: Lexer[Int] =
pchar(fn{ ch => ch >= '1' && ch <= '9' }).map(fn { ch => Ok(ch.to_int() - '0'.to_int()) })
let zero_to_nine: Lexer[Int] =
pchar(fn{ ch => ch >= '0' && ch <= '9' }).map(fn { ch => Ok(ch.to_int() - '0'.to_int()) })

// 转换成整数
let value: Lexer[Token] = 
    zero.or(one_to_nine.and(zero_to_nine.many())
    .map(fn{(i, ls) => fold_left_list(i, ls, fn{acc, j => acc * 10 + j })
    }))
    .map(fn{ value => Ok(Token::NUMBER(value.to_string())) })

let idd: Lexer[Char] =
    pchar(fn { ch => is_letter(ch) || ch == '_' })
    .map(fn { ch => Ok(ch)
    // _ => Err(ParseErr::Message("Unknown identifier"))
     })


let idd2: Lexer[Char] =
    pchar(fn { ch => is_letter(ch) || ch == '_' || is_digit(ch) })
    .map(fn { ch => Ok(ch)
    // _ => Err(ParseErr::Message("Unknown identifier"))
     })

// 解析含_的解析器
let identifier: Lexer[Token] =
    idd.and(idd2.many()) // 获取多个标识符
    .map(fn {
         (i, ls) => adding_string( to_string_char_mini(i) , to_string_char(ls), fn{ acc, item => acc + item }) 
         })
    .map(fn { ids => Ok(Token::IDENTIFIER(ids)) })  // 确保这里直接使用 ids
// let identifier: Lexer[]

let keyword: Lexer[Token] = 
    keyword6.or(keyword5).or(keyword4).or(keyword3).or(keyword2)
    .map(fn { token => Ok(token) })
