// 最终组合的词法分析器
let tokens: Lexer[Array[Token]] =
  keyword6.or(keyword5).or(keyword4).or(keyword3).or(keyword2).or(symbol2).or(symbol1)
  .or(identifier)  // 确保 identifier 在最后，以便它不会与关键字冲突
  .or(value)
  .and(whitespace.many())
  .map(fn { (symbols, _) => Ok(symbols) })
  .many();

// let tokens: Lexer[Array[Token]] =
//     value.or(symbol1).and(whitespace.many())
//     .map(fn { (symbols, _) => Ok(symbols) }) // 忽略空格
//     .many()
// pub fn (tokens: ArrayView[Token]) -> Syntax {
//   let result = top_level(tokens)
// Type aliases

// Traits

// Extension Methods
