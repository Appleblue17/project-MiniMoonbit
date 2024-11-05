
// package moonbitlang/minimbt/lex


// Types and methods
// 定义跳过空白符和注释的解析器
let skip_whitespace_and_comments: Lexer[Unit] =
    whitespace.many()
    .or(comment.many())
    .map(fn { (_) => Ok(()) });  // 跳过空白符和注释，Unit 类型表示没有返回值

pub let tokens: Lexer[Array[Token]] =
 value
 .or(symbol1).or(keyword).or(symbol2).or(comment).or(identifier).and(skip_whitespace_and_comments)
.map(fn { (symbols, _) => 
Ok(symbols) }) // 忽略空格
.many()

// pub fn (tokens: ArrayView[Token]) -> Syntax {
//   let result = top_level(tokens)
// Type aliases

// Traits

// Extension Methods
