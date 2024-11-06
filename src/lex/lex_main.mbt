// 最终组合的词法分析器
let tokens: Lexer[Array[Token]] =
 value
 .or(symbol1).or(keyword).or(symbol2).or(comment).or(identifier).and(skip_whitespace_and_comments)
.map(fn { (symbols, _) => 
Ok(symbols) }) // 忽略空格
.many()

// let tokens: Lexer[Array[Token]] =
//     value.or(symbol1).and(whitespace.many())
//     .map(fn { (symbols, _) => Ok(symbols) }) // 忽略空格
//     .many()
// pub fn (tokens: ArrayView[Token]) -> Syntax {
//   let result = top_level(tokens)
// Type aliases

// Traits

// Extension Methods
