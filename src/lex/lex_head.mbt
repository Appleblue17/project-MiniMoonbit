typealias Token = @types.TOKEN
pub fn parse[V](self : Lexer[V], str : String) -> Option[(V, String)] {
  (self._)(str)
}

fn map[I, O](self : Lexer[I], f : (I) -> Result[O, ParseErr]) -> Lexer[O] {
  fn {
    input =>
      match self.parse(input) {
        Some((token, rest)) => {
          match f(token) {
            Ok(ret) => Some((ret, rest))
            Err(_) => {
              // 处理解析错误，比如打印错误消息
              None // 返回 None 以表示解析失败
            }
          }
        }
        None => None
      }
  }
}




fn and[V1, V2](self : Lexer[V1], parser2 : Lexer[V2]) -> Lexer[(V1, V2)] {
  fn {
    input =>
      self
      .parse(input)
      .bind(
        fn {
          (value, rest) =>
            parser2
            .parse(rest)
            .map(fn { (value2, rest2) => ((value, value2), rest2) })
        },
      )
  }
}


fn or[Value](self : Lexer[Value], parser2 : Lexer[Value]) -> Lexer[Value] {
  Lexer(fn (input) {
  match self.parse(input) {
  None => parser2.parse(input)
  Some(_) as result => result
  } }) }

fn many[Value: Show](self : Lexer[Value]) -> Lexer[Array[Value]] {
  fn(input) {
    let cumul
 = []
    let mut rest = input
    loop self.parse(input) {
      None => Some((cumul, rest))
      Some((v, rest_)) => {
        cumul.push(v)
        rest = rest_
        continue self.parse(rest_)
      }
    }
  }
}

fn optional[V](self : Lexer[V]) -> Lexer[Array[V]] {
  fn {
    input =>
      match self.parse(input) {
        None => Some( ([], input) )
        Some((v, rest)) => Some( ([v], rest) )
      }
  }
}

// 初始化词法分析器
fn pchar(predicate: (Char) -> Bool) -> Lexer[Char] {
  Lexer(fn(input) {
    if input.length() > 0 && predicate(input[0]) {
      // 返回匹配的字符和剩余的字符串
      let remaining = input.to_bytes().sub_string(1, input.length()); // 获取剩余部分
      Some((input[0], remaining))
    } else {
      None
    }
  })
}



fn pstring(predicate: (String) -> Bool) -> Lexer[String] {
  Lexer(fn(input) {
    if input.length() > 0 && predicate(input.to_string()) {
      // 返回匹配的字符和剩余的字符串
      let remaining = input.to_bytes().sub_string(1, input.length()); // 获取剩余部分
      Some((input.to_string(), remaining))
    } else {
      None
    }
  })
}
fn is_letter(ch: Char) -> Bool {
    ch >= 'a' && ch <= 'z' || ch >= 'A' && ch <= 'Z'
}

fn is_digit(ch: Char) -> Bool {
    ch >= '0' && ch <= '9'
}

// fn is_valid_identifier_chars(chars: Array[Char]) -> Bool {
//     for ch in chars {
//         if not(is_letter(ch) || is_digit(ch) || ch == '_') {
//             return false // 如果有不符合的字符，返回 false
//         }
//     }
//     return true // 所有字符都符合条件，返回 true
// }

fn to_char(ch: String) -> Array[Char] {
  return ch.to_array()
}