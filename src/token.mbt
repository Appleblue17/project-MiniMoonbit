pub enum TOKEN{
  TRUE // 'true'
  FALSE // 'false'
  UNIT // 'Unit'
  BOOL // 'Bool'
  INT // 'Int'
  DOUBLE // 'Double'
  ARRAY // 'Array'
  NOT // 'not'
  IF // 'if'
  ELSE // 'else'
  FN // 'fn'
  LET // 'let'
  MAKE // 'make'
  NUMBER(String) // [0-9]+
  IDENTIFIER(String) // [a-zA-Z_][a-zA-Z0-9_]*
  DOT // '.'
  ADD // '+'
  SUB // '-'
  MUL // '*'
  DIV // '/'
  ASSIGN // '='
  EQ // '=='
  LE // '<='
  LPAREN // '('
  RPAREN // ')'
  LBRACKET // '['
  RBRACKET // ']'
  LCURLYBRACKET // '{'
  RCURLYBRACKET // '}'
  ARROW // '->'
  COLON // ':'
  SEMICOLON // ';'
  COMMA // ','
  WS // [ \t\r\n]+ -> skip
  COMMENT // '//' ~[\r\n]* -> skip
} derive(Show)
