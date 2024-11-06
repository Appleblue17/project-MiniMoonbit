// 最终组合的词法分析器
let tokens: Lexer[Array[Token]] =
 value
 .or(symbol1).or(keyword2).or(keyword3).or(keyword4).or(keyword5).or(keyword6).or(symbol2).or(identifier).and(whitespace.many())
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
