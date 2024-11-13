test "tuple-array" {
// fn main {
//   let ary = Array::make(3, 1);
//   let x = ary[2];
//   print_int(x)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Tuple",[["Int"],["Int"]]]]],["Let",["_2",["Int"]],["Int",5],["Let",["_3",["Int"]],["Let",["_5",["Int"]],["Int",4],["Let",["_4",["Int"]],["Int",3],["MakeTuple",["_4","_5"]]]],["MakeArray","_2","_3"]]],["LetTuple",[["x.8",["Int"]],["y.9",["Int"]]],["Let",["_6",["Array",["Tuple",[["Int"],["Int"]]]]],["Var","ary.1"],["Let",["_7",["Int"]],["Int",2],["ArrayGet","_6","_7"]]],["Let",["_.10",["Unit"]],["Let",["_11",["Int"]],["Var","x.8"],["CallDirect","minimbt_print_int",["_11"]]],["Let",["_.12",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_13",["Int"]],["Var","y.9"],["CallDirect","minimbt_print_int",["_13"]]]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "array" {
// fn main {
//   let ary = Array::make(3, 1);
//   let x = ary[2];
//   print_int(x)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Int"]]],["Let",["_2",["Int"]],["Int",3],["Let",["_3",["Int"]],["Int",1],["MakeArray","_2","_3"]]],["Let",["x.4",["Int"]],["Let",["_5",["Array",["Int"]]],["Var","ary.1"],["Let",["_6",["Int"]],["Int",2],["ArrayGet","_5","_6"]]],["Let",["_7",["Int"]],["Var","x.4"],["CallDirect","minimbt_print_int",["_7"]]]]]}
  
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "tuple" {
// fn main {
//   let tup = (1, 2, 3);
//   let (x, y, z) = tup;
//   let _ = print_int(x);
//   let _ = print_endline();
//   let _ = print_int(y);
//   let _ = print_endline();
//   print_int(z)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["tup.1",["Tuple",[["Int"],["Int"],["Int"]]]],["Let",["_4",["Int"]],["Int",3],["Let",["_3",["Int"]],["Int",2],["Let",["_2",["Int"]],["Int",1],["MakeTuple",["_2","_3","_4"]]]]],["LetTuple",[["x.5",["Int"]],["y.6",["Int"]],["z.7",["Int"]]],["Var","tup.1"],["Let",["_.8",["Unit"]],["Let",["_9",["Int"]],["Var","x.5"],["CallDirect","minimbt_print_int",["_9"]]],["Let",["_.10",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_.11",["Unit"]],["Let",["_12",["Int"]],["Var","y.6"],["CallDirect","minimbt_print_int",["_12"]]],["Let",["_.13",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_14",["Int"]],["Var","z.7"],["CallDirect","minimbt_print_int",["_14"]]]]]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "if-else-not" {
// fn main {
//   let x = 4;
//   let y = {
//     if not(x <= 3) {
//       x+2
//     } else {
//       x-3
//     }
//   };
//   print_int(y)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["x.1",["Int"]],["Int",4],["Let",["y.2",["Int"]],["Let",["_3",["Bool"]],["Let",["_9",["Bool"]],["Let",["_10",["Int"]],["Var","x.1"],["Let",["_11",["Int"]],["Int",3],["IfLe","_10","_11",["Bool",true],["Bool",false]]]],["Not","_9"]],["Let",["_4",["Bool"]],["Bool",true],["IfEq","_3","_4",["Let",["_5",["Int"]],["Var","x.1"],["Let",["_6",["Int"]],["Int",2],["Add","_5","_6"]]],["Let",["_7",["Int"]],["Var","x.1"],["Let",["_8",["Int"]],["Int",3],["Sub","_7","_8"]]]]]],["Let",["_12",["Int"]],["Var","y.2"],["CallDirect","minimbt_print_int",["_12"]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "if-else" {
// fn main {
//   let x = 4;
//   let y = {
//     if x <= 3 {
//       x+2
//     } else {
//       x-3
//     }
//   };
//   print_int(y)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["x.1",["Int"]],["Int",4],["Let",["y.2",["Int"]],["Let",["_3",["Bool"]],["Let",["_9",["Int"]],["Var","x.1"],["Let",["_10",["Int"]],["Int",3],["IfLe","_9","_10",["Bool",true],["Bool",false]]]],["Let",["_4",["Bool"]],["Bool",true],["IfEq","_3","_4",["Let",["_5",["Int"]],["Var","x.1"],["Let",["_6",["Int"]],["Int",2],["Add","_5","_6"]]],["Let",["_7",["Int"]],["Var","x.1"],["Let",["_8",["Int"]],["Int",3],["Sub","_7","_8"]]]]]],["Let",["_11",["Int"]],["Var","y.2"],["CallDirect","minimbt_print_int",["_11"]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}


test "ex_frac" {
  
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[{"name":"frac.1","old_name":"frac.1","is_closure":true,"ty":["DirectFunction",[["Int"]],["Int"]],"args":[["n.2",["Int"]]],"formal_free_vars":[],"body":["Let",["_3",["Bool"]],["Let",["_10",["Int"]],["Var","n.2"],["Let",["_11",["Int"]],["Int",1],["IfEq","_10","_11",["Bool",true],["Bool",false]]]],["Let",["_4",["Bool"]],["Bool",true],["IfEq","_3","_4",["Int",1],["Let",["_5",["Int"]],["Let",["_7",["Int"]],["Let",["_8",["Int"]],["Var","n.2"],["Let",["_9",["Int"]],["Int",1],["Sub","_8","_9"]]],["CallClosure","frac.1",["_7"]]],["Let",["_6",["Int"]],["Var","n.2"],["Mul","_5","_6"]]]]]]}],"body":["MakeClosure",["frac.1",["DirectFunction",[["Int"]],["Int"]]],{"name":"frac.1","actual_free_vars":[]},["Let",["_12",["Int"]],["Let",["_13",["Int"]],["Int",6],["CallClosure","frac.1",["_13"]]],["CallDirect","minimbt_print_int",["_12"]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}
