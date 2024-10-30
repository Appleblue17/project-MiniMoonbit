test "ex_frac" {
  let dummy_env = Map::new()
  
  let input = Knf::from_json!(@json.parse!(
  //  #|["LetRec",{"name":"frac.1","ty":["Fun",[["Var",["Some","Int"]]],["Var",["Some","Int"]]],"args":[["n.2",["Var",["Some","Int"]]]],"body":["Let",["_3","Bool"],["Let",["_5",["Var","None"]],["Var","n.2"],["Let",["_6",["Var","None"]],["Int",1],["IfEq","_5","_6",["Bool",true],["Bool",false]]]],["Let",["_4","Bool"],["Bool",true],["IfEq","_3","_4",["Int",1],["Let",["_7",["Var","None"]],["Let",["_9",["Var","None"]],["Let",["_10",["Var","None"]],["Var","n.2"],["Let",["_11",["Var","None"]],["Int",1],["Sub","_10","_11"]]],["Apply","frac.1",["_9"]]],["Let",["_8",["Var","None"]],["Var","n.2"],["Mul","_7","_8"]]]]]]},["Let",["_12",["Var","None"]],["Let",["_13",["Var","None"]],["Int",6],["Apply","frac.1",["_13"]]],["ExternalFunctionApplication","minimbt_print_int",["_12"]]]]
   #|["LetRec",{"name":"frac.1","ty":["Fun",[["Var",["Some","Int"]]],["Var",["Some","Int"]]],"args":[["n.2",["Var",["Some","Int"]]]],"body":["Let",["_3","Bool"],["Let",["_5",["Var","None"]],["Var","n.2"],["Let",["_6",["Var","None"]],["Int",1],["IfEq","_5","_6",["Bool",true],["Bool",false]]]],["Let",["_4","Bool"],["Bool",true],["IfEq","_3","_4",["Int",1],["Let",["_7",["Var","None"]],["Let",["_9",["Var","None"]],["Let",["_10",["Var","None"]],["Var","n.2"],["Let",["_11",["Var","None"]],["Int",1],["Sub","_10","_11"]]],["Apply","frac.1",["_9"]]],["Let",["_8",["Var","None"]],["Var","n.2"],["Mul","_7","_8"]]]]]]},["Let",["_12",["Var","None"]],["Let",["_13",["Var","None"]],["Int",6],["Apply","frac.1",["_13"]]],["ExternalFunctionApplication","minimbt_print_int",["_12"]]]]
  ))
  // println(input.to_pretty_print())
  // println("")
  
  let ret = knf_program_to_closure(input, dummy_env)
  // println(ret.to_json())
  println(ret.to_pretty_print())
}
test "non-tail-if2" {
  let dummy_env = Map::new()
  
  let input = Knf::from_json!(@json.parse!(
    #|["LetRec",{"name":"f.1","ty":["Fun",[],["Var",["Some","Int"]]],"args":[],"body":["Int",12345]},["Let",["y.2",["Var",["Some",["Array","Int"]]]],["Let",["_3",["Var","None"]],["Int",10],["Let",["_4","Int"],["Int",3],["Array","_3","_4"]]],["Let",["x.5",["Var",["Some","Int"]]],["Int",67890],["Let",["_6",["Var","None"]],["Let",["_7","Bool"],["Let",["_9",["Var","None"]],["Let",["_11",["Var","None"]],["Var","y.2"],["Let",["_12","Int"],["Int",0],["Get","_11","_12"]]],["Let",["_10",["Var","None"]],["Int",3],["IfEq","_9","_10",["Bool",true],["Bool",false]]]],["Let",["_8","Bool"],["Bool",true],["IfEq","_7","_8",["Let",["_13",["Var","None"]],["Let",["_15",["Var","None"]],["Apply","f.1",[]],["Let",["_16",["Var","None"]],["Let",["_17",["Var","None"]],["Var","y.2"],["Let",["_18","Int"],["Int",1],["Get","_17","_18"]]],["Add","_15","_16"]]],["Let",["_14",["Var","None"]],["Var","x.5"],["Add","_13","_14"]]],["Int",7]]]],["ExternalFunctionApplication","minimbt_print_int",["_6"]]]]]]
  ))
  // println(input.to_pretty_print())
  // println("")
  
  let ret = knf_program_to_closure(input, dummy_env)
  println(ret.to_pretty_print())
}


test "adder" {
  let dummy_env = Map::new()
  
  let input = Knf::from_json!(@json.parse!(
    #|["LetRec",{"name":"make_adder.1","ty":["Fun",["Int"],["Fun",["Int"],"Int"]],"args":[["x.2","Int"]],"body":["LetRec",{"name":"adder.3","ty":["Fun",["Int"],"Int"],"args":[["y.4","Int"]],"body":["Let",["_5",["Var","None"]],["Var","x.2"],["Let",["_6",["Var","None"]],["Var","y.4"],["Add","_5","_6"]]]},["Var","adder.3"]]},["Let",["_5",["Var","None"]],["Let",["_6",["Var","None"]],["Int",7],["Apply","_7",["_6"]]],["ExternalFunctionApplication","minimbt_print_int",["_5"]]]]
  ))
  println(input.to_pretty_print())
  println("\n\n")
  
  let ret = knf_program_to_closure(input, dummy_env)
  println(ret.to_pretty_print())
}