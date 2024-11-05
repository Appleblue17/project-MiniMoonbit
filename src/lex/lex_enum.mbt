// Imports
type Lexer[V] (String) -> Option[(V, String)]

// Types
// struct TokenType {
//   token_type: Token
//   token_value: String
// }



enum ParseErr {
  Message(String) // 可以包含错误消息
}
