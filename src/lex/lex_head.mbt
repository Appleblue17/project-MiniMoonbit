typealias Token = @types.TOKEN
fn parse[V](self : Lexer[V], str : String) -> Option[(V, String)] {
  (self._)(str)
}

// map 函数，将解析结果映射为另一个类型
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

// and 函数，将两个解析器组合为一个
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

// or 函数，将两个解析器组合为一个
fn or[Value](self : Lexer[Value], parser2 : Lexer[Value]) -> Lexer[Value] {
  Lexer(fn (input) {
  match self.parse(input) {
  None => parser2.parse(input)
  Some(_) as result => result
  } }) }


// many 函数，将解析器重复多次
fn many[Value: Show](self : Lexer[Value]) -> Lexer[Array[Value]] {
  fn(input) {
    let cumul = []
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

// optional 函数，将解析器变为可选的
// fn optional[V](self : Lexer[V]) -> Lexer[Array[V]] {
//   fn {
//     input =>
//       match self.parse(input) {
//         None => Some( ([], input) )
//         Some((v, rest)) => Some( ([v], rest) )
//       }
//   }
// }

// pchar 函数，解析单个字符
fn pchar(predicate: (Char) -> Bool) -> Lexer[Char] {
  Lexer(fn(input) {
    if input.length() > 0 && predicate(input[0]) {
      // 返回匹配的字符和剩余的字符串
      let remaining = input.to_bytes().sub_string(2, 2*(input.length()-1)); // 获取剩余部分
      Some((input[0], remaining))
    } else {
      None
    }
  })
}

// pstring 函数，解析字符串
fn pstring(len:Int, predicate: (String) -> Bool) -> Lexer[String] {
  Lexer(fn(input) {
    if input.length() > 0 && predicate(input.to_string()) && next_non_identifier(input) == len {
      // 返回匹配的字符和剩余的字符串
      let remaining = input.to_bytes().sub_string(2*len, (input.length()-len)*2); // 获取剩余部分
      let input_in = input.to_bytes().sub_string(0, 2*len)
      Some((input_in.to_string(), remaining))
    } else {
      None
    }
  })
}
fn pstring2(len:Int, predicate: (String) -> Bool) -> Lexer[String] {
  Lexer(fn(input) {
    if input.length() > 0 && predicate(input.to_string()) {
      // 返回匹配的字符和剩余的字符串
      let remaining = input.to_bytes().sub_string(2*len, (input.length()-len)*2); // 获取剩余部分
      let input_in = input.to_bytes().sub_string(0, 2*len)
      Some((input_in.to_string(), remaining))
    } else {
      None
    }
  })
}

// fn rest(ch: String, id: String) -> String {
//   let result = ch.to_bytes().sub_string(2*id.length(), 2*(ch.length()-1));
//   result
// }

// is_letter 函数，判断是否是字母
fn is_letter(ch: Char) -> Bool {
    ch >= 'a' && ch <= 'z' || ch >= 'A' && ch <= 'Z'
}

// is_digit 函数，判断是否是数字
fn is_digit(ch: Char) -> Bool {
    ch >= '0' && ch <= '9'
}

// all 函数，判断数组中的所有元素是否满足条件
fn all[Value](array: Array[Value], pred: (Value) -> Bool) -> Bool {
    for item in array {
        if not(pred(item)) {
            return false; // 如果有一个元素不满足条件，返回 false
        }
    }
    return true; // 如果所有元素都满足条件，返回 true
}

fn fold_left_list(init: Int, list: Array[Int], f: (Int, Int) -> Int) -> Result[Int, ParseErr] {
  let mut result = init;
   for item in list {
        result = f(result, item); // 将当前结果和列表元素传入函数
    }
    // 返回成功的结果
    Ok(result)
}

fn to_string_char(ch: Array[Char]) -> Array[String] {
  let result = []
  for item in ch {
    result.push(item.to_string())
  }
  result
}

fn to_string_char_mini(ch: Char) -> String {
  ch.to_string()
}
fn adding_string(init: String, list: Array[String], f: (String, String) -> String) -> Result[String, ParseErr] {
  let mut result = init;
  for item in list {
        result = f(result, item);  // 将当前结果和列表元素传入函数
  }
  Ok(result)  // 返回连接后的结果
}

// 在Lexer[Array[Token]]的最后添加Token::Unit
fn add_unit(tokens: Array[Token]) -> Array[Token] {
  let result = tokens;
  result.push(Token::UNIT);
  result
}

// 获取下一个非identifier的长度
fn next_non_identifier(input: String) -> Int {
  let mut i = 0;
  while i < input.length() {
    if input[i] == '_' || is_letter(input[i]) || is_digit(input[i]) {
      i = i + 1
    } else {
      break;
    }
  }
  return i;
}

// 发现换行符，注释结束
// fn find_newline(input: String) -> Int {
//   let mut i = 0;
//   while i < input.length() {
//     if input[i] == '\n' {
//       break;
//     } else {
//       i = i + 1;
//     }
//   }
//   return i;
// }