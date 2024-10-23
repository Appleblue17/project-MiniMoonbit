typealias Token = @types.TOKEN
typealias Syntax = @types.Syntax
typealias Kind = @types.Kind
typealias Op = @types.Op
typealias Fundef = @types.Fundef
typealias Type = @types.Type

type! ParseErr String

let max_Int: Int = 2147483647

type Parser[V] (ArrayView[Token]) -> (V, ArrayView[Token])?

fn parse[V](
  self : Parser[V],
  tokens : ArrayView[Token]
) -> (V, ArrayView[Token])? {
  (self._)(tokens)
}

// Begin: 基本组合子
fn ptoken(predicate : (Token) -> Bool) -> Parser[Token] {
  fn {
    [hd, .. as tl] => if predicate(hd) { Some((hd, tl)) } else { None }
    [] => None
  }
}

fn map[I, O](self : Parser[I], f : (I) -> O!ParseErr) -> Parser[O] {
  fn {
    input =>
      match self.parse(input) {
        Some((token, rest)) => {
          match f?(token){
            Ok(ret) => Some( (ret, rest) )
            Err(ParseErr(msg)) => {
              // println(msg)
              None
            }
          }
        }
        None => None
      }
  }
}

fn and[V1, V2](self : Parser[V1], parser2 : Parser[V2]) -> Parser[(V1, V2)] {
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

fn or[Value](self : Parser[Value], parser2 : Parser[Value]) -> Parser[Value] {
  fn {
    input =>
      match self.parse(input) {
        None => parser2.parse(input)
        Some(_) as result => result
      }
  }
}


fn optional[V](self : Parser[Array[V]]) -> Parser[Array[V]] {
  fn {
    input =>
      match self.parse(input) {
        None => Some( ([], input) )
        Some(_) as result => result
      }
  }
}

// 如果未指定类型，生成空类型标注替代
fn optional_type(self : Parser[Type]) -> Parser[Type] {
  fn {
    input =>
      match self.parse(input) {
        None => Some( (@types.new_tvar(), input) )
        Some(_) as result => result
      }
  }
}

fn many[Value: Show](self : Parser[Value]) -> Parser[Array[Value]] {
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

// End: 基本组合子
