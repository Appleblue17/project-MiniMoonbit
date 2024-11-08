// 最终组合的词法分析器
let tokens: Lexer[Array[Token]] =
   keyword
  .or(symbol2).or(symbol1)// 确保 identifier 在最后，以便它不会与关键字冲突
  .or(value)
  .or(identifier)  
  .and(whitespace.many()) // 忽略空格和注释
  .map(fn { (symbols, _) => Ok(symbols) })
  .many().map(fn { tokens => Ok(add_unit(tokens)) }) // 在最后添加Token::Unit


// Type aliases

// Traits

// Extension Methods
