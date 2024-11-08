// 最终组合的词法分析器
let tokens: Lexer[Array[Token]] =
   keyword
  .or(symbol2).or(symbol1)// 确保 identifier 在最后，以便它不会与关键字冲突
  .or(value)
  .or(identifier)  
  .and(whitespace.many())
  .map(fn { (symbols, _) => Ok(symbols) })
  .many().map(fn { tokens => Ok(add_unit(tokens)) }) // 忽略空格

pub fn lex(src: String) -> Array[Token] {
  let ret = tokens.parse(src)
  match ret {
    Some( (ary, "") ) => ary
    _ => @util.die("Lexing failed")
  }
}

// let tokens: Lexer[Array[Token]] =
//     value.or(symbol1).and(whitespace.many())
//     .map(fn { (symbols, _) => Ok(symbols) }) // 忽略空格
//     .many()
// pub fn (tokens: ArrayView[Token]) -> Syntax {
//   let result = top_level(tokens)
// Type aliases

// Traits

// Extension Methods
