// Begin: Token 识别组合子

// return Token

let bool_true : Parser[Token] = ptoken(
  fn {
    TRUE => true
    _ => false
  },
)

let bool_false : Parser[Token] = ptoken(
  fn {
    FALSE => true
    _ => false
  },
)

let unit : Parser[Token] = ptoken(
  fn {
    UNIT => true
    _ => false
  },
)

let bool : Parser[Token] = ptoken(
  fn {
    BOOL => true
    _ => false
  },
)

let int : Parser[Token] = ptoken(
  fn {
    INT => true
    _ => false
  },
)

let double : Parser[Token] = ptoken(
  fn {
    DOUBLE => true
    _ => false
  },
)

let array : Parser[Token] = ptoken(
  fn {
    ARRAY => true
    _ => false
  },
)

let bool_not : Parser[Token] = ptoken(
  fn {
    NOT => true
    _ => false
  },
)

let ctrl_if : Parser[Token] = ptoken(
  fn {
    IF => true
    _ => false
  },
)

let ctrl_else : Parser[Token] = ptoken(
  fn {
    ELSE => true
    _ => false
  },
)

let ctrl_fn : Parser[Token] = ptoken(
  fn {
    FN => true
    _ => false
  },
)

let ctrl_let : Parser[Token] = ptoken(
  fn {
    LET => true
    _ => false
  },
)

let ctrl_make : Parser[Token] = ptoken(
  fn {
    MAKE => true
    _ => false
  },
)

let number : Parser[Token] = ptoken(
  fn {
    NUMBER(_) => true
    _ => false
  },
)


let identifier : Parser[Token] = ptoken(
  fn {
    IDENTIFIER(_) => true
    _ => false
  },
)

let identifier_main : Parser[Token] = ptoken(
  fn {
    IDENTIFIER("main") => true
    _ => false
  },
)

let identifier_init : Parser[Token] = ptoken(
  fn {
    IDENTIFIER("init") => true
    _ => false
  },
)

let dot : Parser[Token] = ptoken(
  fn {
    DOT => true
    _ => false
  }
)

// let add : Parser[Token] = ptoken(
//   fn {
//     ADD => true
//     _ => false
//   }
// )

let sub : Parser[Token] = ptoken(
  fn {
    SUB => true
    _ => false
  }
)

// let mul : Parser[Token] = ptoken(
//   fn {
//     MUL => true
//     _ => false
//   }
// )

// let div : Parser[Token] = ptoken(
//   fn {
//     DIV => true
//     _ => false
//   }
// )

let assign : Parser[Token] = ptoken(
  fn {
    ASSIGN => true
    _ => false
  }
)

let eq : Parser[Token] = ptoken(
  fn {
    EQ => true
    _ => false
  }
)

let le : Parser[Token] = ptoken(
  fn {
    LE => true
    _ => false
  }
)

let lparen : Parser[Token] = ptoken(
  fn {
    LPAREN => true
    _ => false
  }
)

let rparen : Parser[Token] = ptoken(
  fn {
    RPAREN => true
    _ => false
  }
)

let lbracket : Parser[Token] = ptoken(
  fn {
    LBRACKET => true
    _ => false
  }
)

let rbracket : Parser[Token] = ptoken(
  fn {
    RBRACKET => true
    _ => false
  }
)

let lcurlybracket : Parser[Token] = ptoken(
  fn {
    LCURLYBRACKET => true
    _ => false
  }
)

let rcurlybracket : Parser[Token] = ptoken(
  fn {
    RCURLYBRACKET => true
    _ => false
  }
)

let arrow : Parser[Token] = ptoken(
  fn {
    ARROW => true
    _ => false
  }
)

let colon : Parser[Token] = ptoken(
  fn {
    COLON => true
    _ => false
  }
)

let semicolon : Parser[Token] = ptoken(
  fn {
    SEMICOLON => true
    _ => false
  }
)

let comma : Parser[Token] = ptoken(
  fn {
    COMMA => true
    _ => false
  }
)

// End: Token 识别组合子
