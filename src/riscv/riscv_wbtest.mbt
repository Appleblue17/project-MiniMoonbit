test "even-odd" {
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[{"name":"odd.5","old_name":"odd.5","is_closure":true,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["x.6",["Int"]]],"formal_free_vars":[["even.3",["ClosureFunction",[["Int"]],["Int"]]],["t.1",["Int"]],["x.4",["Int"]],["f.2",["Int"]]],"body":["Let",["_7",["Bool"]],["Let",["_19",["Int"]],["Int",0],["Let",["_20",["Int"]],["Var","x.6"],["IfLe","_19","_20",["Bool",true],["Bool",false]]]],["Let",["_8",["Bool"]],["Bool",true],["IfEq","_7","_8",["Let",["_9",["Bool"]],["Let",["_14",["Int"]],["Var","x.6"],["Let",["_15",["Int"]],["Int",0],["IfEq","_14","_15",["Bool",true],["Bool",false]]]],["Let",["_10",["Bool"]],["Bool",true],["IfEq","_9","_10",["Var","f.2"],["Let",["_11",["Int"]],["Let",["_12",["Int"]],["Var","x.6"],["Let",["_13",["Int"]],["Int",1],["Sub","_12","_13"]]],["CallClosure","even.3",["_11"]]]]]],["Let",["_16",["Int"]],["Let",["_17",["Int"]],["Var","x.6"],["Let",["_18",["Int"]],["Int",1],["Add","_17","_18"]]],["CallClosure","even.3",["_16"]]]]]]},{"name":"even.3","old_name":"even.3","is_closure":true,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["x.4",["Int"]]],"formal_free_vars":[["t.1",["Int"]],["f.2",["Int"]]],"body":["MakeClosure",["odd.5",["ClosureFunction",[["Int"]],["Int"]]],{"name":"odd.5","actual_free_vars":["even.3","t.1","x.4","f.2"]},["Let",["_21",["Bool"]],["Let",["_33",["Int"]],["Int",0],["Let",["_34",["Int"]],["Var","x.4"],["IfLe","_33","_34",["Bool",true],["Bool",false]]]],["Let",["_22",["Bool"]],["Bool",true],["IfEq","_21","_22",["Let",["_23",["Bool"]],["Let",["_28",["Int"]],["Var","x.4"],["Let",["_29",["Int"]],["Int",0],["IfEq","_28","_29",["Bool",true],["Bool",false]]]],["Let",["_24",["Bool"]],["Bool",true],["IfEq","_23","_24",["Var","t.1"],["Let",["_25",["Int"]],["Let",["_26",["Int"]],["Var","x.4"],["Let",["_27",["Int"]],["Int",1],["Sub","_26","_27"]]],["CallClosure","odd.5",["_25"]]]]]],["Let",["_30",["Int"]],["Let",["_31",["Int"]],["Var","x.4"],["Let",["_32",["Int"]],["Int",1],["Add","_31","_32"]]],["CallClosure","odd.5",["_30"]]]]]]]}],"body":["Let",["t.1",["Int"]],["Int",123],["Let",["f.2",["Int"]],["Int",456],["MakeClosure",["even.3",["ClosureFunction",[["Int"]],["Int"]]],{"name":"even.3","actual_free_vars":["t.1","f.2"]},["Let",["_35",["Int"]],["Let",["_36",["Int"]],["Int",789],["CallClosure","even.3",["_36"]]],["CallDirect","minimbt_print_int",["_35"]]]]]]}
  
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
    #|{"fundefs":[{"name":"frac.1","old_name":"frac.1","is_closure":false,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["n.2",["Int"]]],"formal_free_vars":[],"body":["Let",["_3",["Bool"]],["Let",["_10",["Int"]],["Var","n.2"],["Let",["_11",["Int"]],["Int",1],["IfEq","_10","_11",["Bool",true],["Bool",false]]]],["Let",["_4",["Bool"]],["Bool",true],["IfEq","_3","_4",["Int",1],["Let",["_5",["Int"]],["Let",["_7",["Int"]],["Let",["_8",["Int"]],["Var","n.2"],["Let",["_9",["Int"]],["Int",1],["Sub","_8","_9"]]],["CallClosure","frac.1",["_7"]]],["Let",["_6",["Int"]],["Var","n.2"],["Mul","_5","_6"]]]]]]}],"body":["MakeClosure",["frac.1",["ClosureFunction",[["Int"]],["Int"]]],{"name":"frac.1","actual_free_vars":[]},["Let",["_12",["Int"]],["Let",["_13",["Int"]],["Int",6],["CallClosure","frac.1",["_13"]]],["CallDirect","minimbt_print_int",["_12"]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "adder3" {
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[{"name":"pow.3","old_name":"pow.3","is_closure":true,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["n.4",["Int"]]],"formal_free_vars":[["x.2",["Int"]]],"body":["Let",["_5",["Bool"]],["Let",["_12",["Int"]],["Var","n.4"],["Let",["_13",["Int"]],["Int",0],["IfEq","_12","_13",["Bool",true],["Bool",false]]]],["Let",["_6",["Bool"]],["Bool",true],["IfEq","_5","_6",["Int",1],["Let",["_7",["Int"]],["Let",["_9",["Int"]],["Let",["_10",["Int"]],["Var","n.4"],["Let",["_11",["Int"]],["Int",1],["Sub","_10","_11"]]],["CallClosure","pow.3",["_9"]]],["Let",["_8",["Int"]],["Var","x.2"],["Mul","_7","_8"]]]]]]},{"name":"make_pow.1","old_name":"make_pow.1","is_closure":false,"ty":["ClosureFunction",[["Int"]],["ClosureFunction",[["Int"]],["Int"]]],"args":[["x.2",["Int"]]],"formal_free_vars":[],"body":["MakeClosure",["pow.3",["ClosureFunction",[["Int"]],["Int"]]],{"name":"pow.3","actual_free_vars":["x.2"]},["Var","pow.3"]]}],"body":["MakeClosure",["make_pow.1",["ClosureFunction",[["Int"]],["ClosureFunction",[["Int"]],["Int"]]]],{"name":"make_pow.1","actual_free_vars":[]},["Let",["_14",["Int"]],["Let",["_15",["Int"]],["Int",4],["Let",["_16",["ClosureFunction",[["Int"]],["Int"]]],["Let",["_17",["Int"]],["Int",3],["CallClosure","make_pow.1",["_17"]]],["CallClosure","_16",["_15"]]]],["CallDirect","minimbt_print_int",["_14"]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "cls-reg-bug" {
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[{"name":"g.13","old_name":"g.13","is_closure":true,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["z.14",["Int"]]],"formal_free_vars":[["v7.9",["Int"]],["v1.3",["Int"]],["v2.4",["Int"]],["v4.6",["Int"]],["v6.8",["Int"]],["v3.5",["Int"]],["v9.11",["Int"]],["v10.12",["Int"]],["v5.7",["Int"]],["v8.10",["Int"]]],"body":["Let",["r.15",["Int"]],["Let",["_16",["Int"]],["Let",["_18",["Int"]],["Let",["_20",["Int"]],["Let",["_22",["Int"]],["Let",["_24",["Int"]],["Let",["_26",["Int"]],["Let",["_28",["Int"]],["Let",["_30",["Int"]],["Let",["_32",["Int"]],["Var","v1.3"],["Let",["_33",["Int"]],["Var","v2.4"],["Add","_32","_33"]]],["Let",["_31",["Int"]],["Var","v3.5"],["Add","_30","_31"]]],["Let",["_29",["Int"]],["Var","v4.6"],["Add","_28","_29"]]],["Let",["_27",["Int"]],["Var","v5.7"],["Add","_26","_27"]]],["Let",["_25",["Int"]],["Var","v6.8"],["Add","_24","_25"]]],["Let",["_23",["Int"]],["Var","v7.9"],["Add","_22","_23"]]],["Let",["_21",["Int"]],["Var","v8.10"],["Add","_20","_21"]]],["Let",["_19",["Int"]],["Var","v9.11"],["Add","_18","_19"]]],["Let",["_17",["Int"]],["Var","v10.12"],["Add","_16","_17"]]],["Let",["_34",["Bool"]],["Let",["_38",["Bool"]],["Let",["_39",["Int"]],["Var","z.14"],["Let",["_40",["Int"]],["Int",0],["IfLe","_39","_40",["Bool",true],["Bool",false]]]],["Not","_38"]],["Let",["_35",["Bool"]],["Bool",true],["IfEq","_34","_35",["Var","r.15"],["Let",["_36",["Int"]],["Let",["_37",["Int"]],["Var","z.14"],["Neg","_37"]],["CallClosure","g.13",["_36"]]]]]]]},{"name":"h.1","old_name":"h.1","is_closure":false,"ty":["ClosureFunction",[["Tuple",[["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"]]]],["Int"]],"args":[["p.2",["Tuple",[["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"]]]]],"formal_free_vars":[],"body":["LetTuple",[["v1.3",["Int"]],["v2.4",["Int"]],["v3.5",["Int"]],["v4.6",["Int"]],["v5.7",["Int"]],["v6.8",["Int"]],["v7.9",["Int"]],["v8.10",["Int"]],["v9.11",["Int"]],["v10.12",["Int"]]],["Var","p.2"],["MakeClosure",["g.13",["ClosureFunction",[["Int"]],["Int"]]],{"name":"g.13","actual_free_vars":["v7.9","v1.3","v2.4","v4.6","v6.8","v3.5","v9.11","v10.12","v5.7","v8.10"]},["Let",["_41",["Int"]],["Int",1],["CallClosure","g.13",["_41"]]]]]}],"body":["MakeClosure",["h.1",["ClosureFunction",[["Tuple",[["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"]]]],["Int"]]],{"name":"h.1","actual_free_vars":[]},["Let",["t1.42",["Unit"]],["Let",["_43",["Int"]],["Let",["_44",["Tuple",[["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"],["Int"]]]],["Let",["_54",["Int"]],["Int",10],["Let",["_53",["Int"]],["Int",9],["Let",["_52",["Int"]],["Int",8],["Let",["_51",["Int"]],["Int",7],["Let",["_50",["Int"]],["Int",6],["Let",["_49",["Int"]],["Int",5],["Let",["_48",["Int"]],["Int",4],["Let",["_47",["Int"]],["Int",3],["Let",["_46",["Int"]],["Int",2],["Let",["_45",["Int"]],["Int",1],["MakeTuple",["_45","_46","_47","_48","_49","_50","_51","_52","_53","_54"]]]]]]]]]]]],["CallClosure","h.1",["_44"]]],["CallDirect","minimbt_print_int",["_43"]]],["Unit"]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "closure2" {
// fn f(x: Int) -> Int {
//   x * x
// };
// fn g(tup: (Int, Int)) -> Int {
//   let (x, y) = tup;
//   f(x) + f(y)
// };

// fn main {
//   let tup = (3, 4);
//   print_int(g(tup))
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[{"name":"f.1","old_name":"f.1","is_closure":false,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["x.2",["Int"]]],"formal_free_vars":[],"body":["Let",["_3",["Int"]],["Var","x.2"],["Let",["_4",["Int"]],["Var","x.2"],["Mul","_3","_4"]]]},{"name":"g.5","old_name":"g.5","is_closure":true,"ty":["ClosureFunction",[["Tuple",[["Int"],["Int"]]]],["Int"]],"args":[["tup.6",["Tuple",[["Int"],["Int"]]]]],"formal_free_vars":[["f.1",["ClosureFunction",[["Int"]],["Int"]]]],"body":["LetTuple",[["x.7",["Int"]],["y.8",["Int"]]],["Var","tup.6"],["Let",["_9",["Int"]],["Let",["_11",["Int"]],["Var","x.7"],["CallClosure","f.1",["_11"]]],["Let",["_10",["Int"]],["Let",["_12",["Int"]],["Var","y.8"],["CallClosure","f.1",["_12"]]],["Add","_9","_10"]]]]}],"body":["MakeClosure",["f.1",["ClosureFunction",[["Int"]],["Int"]]],{"name":"f.1","actual_free_vars":[]},["MakeClosure",["g.5",["ClosureFunction",[["Tuple",[["Int"],["Int"]]]],["Int"]]],{"name":"g.5","actual_free_vars":["f.1"]},["Let",["tup.13",["Tuple",[["Int"],["Int"]]]],["Let",["_15",["Int"]],["Int",4],["Let",["_14",["Int"]],["Int",3],["MakeTuple",["_14","_15"]]]],["Let",["_16",["Int"]],["Let",["_17",["Tuple",[["Int"],["Int"]]]],["Var","tup.13"],["CallClosure","g.5",["_17"]]],["CallDirect","minimbt_print_int",["_16"]]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "adder" {
// fn func(x: Int) -> Int {
//   x
// };
// fn main {
//   print_int(func(5))
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[{"name":"adder.3","old_name":"adder.3","is_closure":true,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["y.4",["Int"]]],"formal_free_vars":[["x.2",["Int"]]],"body":["Let",["_5",["Int"]],["Var","x.2"],["Let",["_6",["Int"]],["Var","y.4"],["Add","_5","_6"]]]},{"name":"make_adder.1","old_name":"make_adder.1","is_closure":false,"ty":["ClosureFunction",[["Int"]],["ClosureFunction",[["Int"]],["Int"]]],"args":[["x.2",["Int"]]],"formal_free_vars":[],"body":["MakeClosure",["adder.3",["ClosureFunction",[["Int"]],["Int"]]],{"name":"adder.3","actual_free_vars":["x.2"]},["Var","adder.3"]]}],"body":["MakeClosure",["make_adder.1",["ClosureFunction",[["Int"]],["ClosureFunction",[["Int"]],["Int"]]]],{"name":"make_adder.1","actual_free_vars":[]},["Let",["_7",["Int"]],["Let",["_8",["Int"]],["Int",7],["Let",["_9",["ClosureFunction",[["Int"]],["Int"]]],["Let",["_10",["Int"]],["Int",3],["CallClosure","make_adder.1",["_10"]]],["CallClosure","_9",["_8"]]]],["CallDirect","minimbt_print_int",["_7"]]]]}
  
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "closure" {
// fn func(x: Int) -> Int {
//   x
// };
// fn main {
//   print_int(func(5))
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[{"name":"func.1","old_name":"func.1","is_closure":true,"ty":["ClosureFunction",[["Int"]],["Int"]],"args":[["x.2",["Int"]]],"formal_free_vars":[],"body":["Var","x.2"]}],"body":["MakeClosure",["func.1",["ClosureFunction",[["Int"]],["Int"]]],{"name":"func.1","actual_free_vars":[]},["Let",["_3",["Int"]],["Let",["_4",["Int"]],["Int",5],["CallClosure","func.1",["_4"]]],["CallDirect","minimbt_print_int",["_3"]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "array-bug" {
// fn main {
//   let ary = Array::make(1, 0);
//   let x = ary;
//   ary[0] = 1;
//   print_int(x[0])
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Int"]]],["Let",["_2",["Int"]],["Int",1],["Let",["_3",["Int"]],["Int",0],["MakeArray","_2","_3"]]],["Let",["x.4",["Array",["Int"]]],["Var","ary.1"],["Let",["_5",["Array",["Int"]]],["Var","ary.1"],["Let",["_6",["Int"]],["Int",0],["Let",["_7",["Int"]],["Int",1],["ArrayPut","_5","_6","_7",["Let",["_8",["Int"]],["Let",["_9",["Array",["Int"]]],["Var","x.4"],["Let",["_10",["Int"]],["Int",0],["ArrayGet","_9","_10"]]],["CallDirect","minimbt_print_int",["_8"]]]]]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "array-nested2" {
// fn main {
//   let ary = Array::make(2, (0, 1));
//   let arry = Array::make(2, ary);
//   let (x, y) = arry[0][1];
//   let _ = print_int(x);
//   let _ = print_endline();
//   let _ = print_int(y);
//   let _ = print_endline();
  
//   arry[1][0] = (3, 4);
//   let (a, b) = arry[1][0];
//   let _ = print_int(a);
//   let _ = print_endline();
//   print_int(b)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Tuple",[["Int"],["Int"]]]]],["Let",["_2",["Int"]],["Int",2],["Let",["_3",["Tuple",[["Int"],["Int"]]]],["Let",["_5",["Int"]],["Int",1],["Let",["_4",["Int"]],["Int",0],["MakeTuple",["_4","_5"]]]],["MakeArray","_2","_3"]]],["Let",["arry.6",["Array",["Array",["Tuple",[["Int"],["Int"]]]]]],["Let",["_7",["Int"]],["Int",2],["Let",["_8",["Array",["Tuple",[["Int"],["Int"]]]]],["Var","ary.1"],["MakeArray","_7","_8"]]],["LetTuple",[["x.13",["Int"]],["y.14",["Int"]]],["Let",["_9",["Array",["Tuple",[["Int"],["Int"]]]]],["Let",["_11",["Array",["Array",["Tuple",[["Int"],["Int"]]]]]],["Var","arry.6"],["Let",["_12",["Int"]],["Int",0],["ArrayGet","_11","_12"]]],["Let",["_10",["Int"]],["Int",1],["ArrayGet","_9","_10"]]],["Let",["_.15",["Unit"]],["Let",["_16",["Int"]],["Var","x.13"],["CallDirect","minimbt_print_int",["_16"]]],["Let",["_.17",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_.18",["Unit"]],["Let",["_19",["Int"]],["Var","y.14"],["CallDirect","minimbt_print_int",["_19"]]],["Let",["_.20",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_21",["Array",["Tuple",[["Int"],["Int"]]]]],["Let",["_24",["Array",["Array",["Tuple",[["Int"],["Int"]]]]]],["Var","arry.6"],["Let",["_25",["Int"]],["Int",1],["ArrayGet","_24","_25"]]],["Let",["_22",["Int"]],["Int",0],["Let",["_23",["Tuple",[["Int"],["Int"]]]],["Let",["_27",["Int"]],["Int",4],["Let",["_26",["Int"]],["Int",3],["MakeTuple",["_26","_27"]]]],["ArrayPut","_21","_22","_23",["LetTuple",[["a.32",["Int"]],["b.33",["Int"]]],["Let",["_28",["Array",["Tuple",[["Int"],["Int"]]]]],["Let",["_30",["Array",["Array",["Tuple",[["Int"],["Int"]]]]]],["Var","arry.6"],["Let",["_31",["Int"]],["Int",1],["ArrayGet","_30","_31"]]],["Let",["_29",["Int"]],["Int",0],["ArrayGet","_28","_29"]]],["Let",["_.34",["Unit"]],["Let",["_35",["Int"]],["Var","a.32"],["CallDirect","minimbt_print_int",["_35"]]],["Let",["_.36",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_37",["Int"]],["Var","b.33"],["CallDirect","minimbt_print_int",["_37"]]]]]]]]]]]]]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "array-nested" {
// fn main {
//   let ary = Array::make(1, 0);
//   let arry = Array::make(1, ary);
//   arry[0][0] = 1;
//   print_int(arry[0][0])
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Int"]]],["Let",["_2",["Int"]],["Int",1],["Let",["_3",["Int"]],["Int",0],["MakeArray","_2","_3"]]],["Let",["arry.4",["Array",["Array",["Int"]]]],["Let",["_5",["Int"]],["Int",1],["Let",["_6",["Array",["Int"]]],["Var","ary.1"],["MakeArray","_5","_6"]]],["Let",["_7",["Array",["Int"]]],["Let",["_10",["Array",["Array",["Int"]]]],["Var","arry.4"],["Let",["_11",["Int"]],["Int",0],["ArrayGet","_10","_11"]]],["Let",["_8",["Int"]],["Int",0],["Let",["_9",["Int"]],["Int",1],["ArrayPut","_7","_8","_9",["Let",["_12",["Int"]],["Let",["_13",["Array",["Int"]]],["Let",["_15",["Array",["Array",["Int"]]]],["Var","arry.4"],["Let",["_16",["Int"]],["Int",0],["ArrayGet","_15","_16"]]],["Let",["_14",["Int"]],["Int",0],["ArrayGet","_13","_14"]]],["CallDirect","minimbt_print_int",["_12"]]]]]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "tuple-array-put" {
// fn main {
//   let ary = Array::make(2, (3, 4));
//   let (x, y) = ary[1];
//   let _ = print_int(x);
//   let _ = print_endline();
//   let _ = print_int(y);
//   let _ = print_endline();
//   ary[0] = (5, 2);
  
//   let (a, b) = ary[0];
//   let _ = print_int(a);
//   let _ = print_endline();
//   print_int(b)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Tuple",[["Int"],["Int"]]]]],["Let",["_2",["Int"]],["Int",2],["Let",["_3",["Tuple",[["Int"],["Int"]]]],["Let",["_5",["Int"]],["Int",4],["Let",["_4",["Int"]],["Int",3],["MakeTuple",["_4","_5"]]]],["MakeArray","_2","_3"]]],["LetTuple",[["x.8",["Int"]],["y.9",["Int"]]],["Let",["_6",["Array",["Tuple",[["Int"],["Int"]]]]],["Var","ary.1"],["Let",["_7",["Int"]],["Int",1],["ArrayGet","_6","_7"]]],["Let",["_.10",["Unit"]],["Let",["_11",["Int"]],["Var","x.8"],["CallDirect","minimbt_print_int",["_11"]]],["Let",["_.12",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_.13",["Unit"]],["Let",["_14",["Int"]],["Var","y.9"],["CallDirect","minimbt_print_int",["_14"]]],["Let",["_.15",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_16",["Array",["Tuple",[["Int"],["Int"]]]]],["Var","ary.1"],["Let",["_17",["Int"]],["Int",0],["Let",["_18",["Tuple",[["Int"],["Int"]]]],["Let",["_20",["Int"]],["Int",2],["Let",["_19",["Int"]],["Int",5],["MakeTuple",["_19","_20"]]]],["ArrayPut","_16","_17","_18",["LetTuple",[["a.23",["Int"]],["b.24",["Int"]]],["Let",["_21",["Array",["Tuple",[["Int"],["Int"]]]]],["Var","ary.1"],["Let",["_22",["Int"]],["Int",0],["ArrayGet","_21","_22"]]],["Let",["_.25",["Unit"]],["Let",["_26",["Int"]],["Var","a.23"],["CallDirect","minimbt_print_int",["_26"]]],["Let",["_.27",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_28",["Int"]],["Var","b.24"],["CallDirect","minimbt_print_int",["_28"]]]]]]]]]]]]]]]]}
  
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}


test "array-put" {
// fn main {
//   let ary = Array::make(3, 0);
//   let _ = print_int(ary[1]);
//   let _ = print_endline();
//   ary[1] = 1;
//   let _ = print_int(ary[1]);
//   let _ = print_endline();
//   ary[2] = 2;
//   print_int(ary[2])
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Int"]]],["Let",["_2",["Int"]],["Int",3],["Let",["_3",["Int"]],["Int",0],["MakeArray","_2","_3"]]],["Let",["_.4",["Unit"]],["Let",["_5",["Int"]],["Let",["_6",["Array",["Int"]]],["Var","ary.1"],["Let",["_7",["Int"]],["Int",1],["ArrayGet","_6","_7"]]],["CallDirect","minimbt_print_int",["_5"]]],["Let",["_.8",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_9",["Array",["Int"]]],["Var","ary.1"],["Let",["_10",["Int"]],["Int",1],["Let",["_11",["Int"]],["Int",1],["ArrayPut","_9","_10","_11",["Let",["_.12",["Unit"]],["Let",["_13",["Int"]],["Let",["_14",["Array",["Int"]]],["Var","ary.1"],["Let",["_15",["Int"]],["Int",1],["ArrayGet","_14","_15"]]],["CallDirect","minimbt_print_int",["_13"]]],["Let",["_.16",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_17",["Array",["Int"]]],["Var","ary.1"],["Let",["_18",["Int"]],["Int",2],["Let",["_19",["Int"]],["Int",2],["ArrayPut","_17","_18","_19",["Let",["_20",["Int"]],["Let",["_21",["Array",["Int"]]],["Var","ary.1"],["Let",["_22",["Int"]],["Int",2],["ArrayGet","_21","_22"]]],["CallDirect","minimbt_print_int",["_20"]]]]]]]]]]]]]]]]}
  
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "array-put0" {
// fn main {
//   let ary = Array::make(3, 0);
//   let _ = print_int(ary[1]);
//   let _ = print_endline();
//   ary[1] = 1;
//   let _ = print_int(ary[1]);
//   let _ = print_endline();
//   ary[2] = 2;
//   print_int(ary[2])
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Int"]]],["Let",["_2",["Int"]],["Int",1],["Let",["_3",["Int"]],["Int",0],["MakeArray","_2","_3"]]],["Let",["_4",["Array",["Int"]]],["Var","ary.1"],["Let",["_5",["Int"]],["Int",0],["Let",["_6",["Int"]],["Int",1],["ArrayPut","_4","_5","_6",["Let",["_7",["Int"]],["Let",["_8",["Array",["Int"]]],["Var","ary.1"],["Let",["_9",["Int"]],["Int",0],["ArrayGet","_8","_9"]]],["CallDirect","minimbt_print_int",["_7"]]]]]]]]}
  ))
  println(input.to_pretty_print())
  println("")
  
  let asms = emit(input)
  for asm in asms {
    println(asm)
  }
}

test "tuple-array" {
// fn main {
//   let ary = Array::make(2, (3, 4));
//   let (x, y) = ary[1];
//   let _ = print_int(x);
//   let _ = print_endline();
//   print_int(y)
// };
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["ary.1",["Array",["Tuple",[["Int"],["Int"]]]]],["Let",["_2",["Int"]],["Int",2],["Let",["_3",["Tuple",[["Int"],["Int"]]]],["Let",["_5",["Int"]],["Int",4],["Let",["_4",["Int"]],["Int",3],["MakeTuple",["_4","_5"]]]],["MakeArray","_2","_3"]]],["LetTuple",[["x.8",["Int"]],["y.9",["Int"]]],["Let",["_6",["Array",["Tuple",[["Int"],["Int"]]]]],["Var","ary.1"],["Let",["_7",["Int"]],["Int",1],["ArrayGet","_6","_7"]]],["Let",["_.10",["Unit"]],["Let",["_11",["Int"]],["Var","x.8"],["CallDirect","minimbt_print_int",["_11"]]],["Let",["_.12",["Unit"]],["CallDirect","minimbt_print_endline",[]],["Let",["_13",["Int"]],["Var","y.9"],["CallDirect","minimbt_print_int",["_13"]]]]]]]}
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

test "hello" {
  let input = @closure.Program::from_json!(@json.parse!(
    #|{"fundefs":[],"body":["Let",["x.1",["Int"]],["Int",5],["Let",["y.2",["Int"]],["Int",6],["Let",["_3",["Int"]],["Let",["_4",["Int"]],["Var","x.1"],["Let",["_5",["Int"]],["Let",["_6",["Int"]],["Var","y.2"],["Let",["_7",["Int"]],["Int",3],["Mul","_6","_7"]]],["Add","_4","_5"]]],["CallDirect","minimbt_print_int",["_3"]]]]]}
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
