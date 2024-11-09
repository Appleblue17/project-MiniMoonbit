test "ex_frac" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  let var_name = env.new_str_name("main")
  let new_env = {..env,
      externals: env.externals.add("print_int", Unit) }
  
  // let tmp= @json.parse!(
  //   #|["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["LetRec",{"name":["frac",["Fun",[["Var",["Some","Int"]]],["Var",["Some","Int"]]]],"args":[["n",["Var",["Some","Int"]]]],"body":["If",["Eq",["Var","n"],["Int",1]],["Int",1],["Mul",["App",["Var","frac"],[["Sub",["Var","n"],["Int",1]]]],["Var","n"]]]},["App",["Var","print_int"],[["App",["Var","frac"],[["Int",6]]]]]]},"Unit"] 
  // )
  // println(tmp)
  
  let input = @types.Syntax::from_json!(@json.parse!(
    #|["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["LetRec",{"name":["frac",["Fun",[["Var",["Some","Int"]]],["Var",["Some","Int"]]]],"args":[["n",["Var",["Some","Int"]]]],"body":["If",["Eq",["Var","n"],["Int",1]],["Int",1],["Mul",["App",["Var","frac"],[["Sub",["Var","n"],["Int",1]]]],["Var","n"]]]},["App",["Var","print_int"],[["App",["Var","frac"],[["Int",6]]]]]]},"Unit"] 
  ))
  // println(new_env.to_knf(input).to_pretty_print())
}
test "non-tail-if2" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  let var_name = env.new_str_name("main")
  let new_env = {..env,
      externals: env.externals.add("print_int", Unit) }
  
  let input = @types.Syntax::from_json!(@json.parse!(
    #|["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["LetRec",{"name":["f",["Fun",[],["Var",["Some","Int"]]]],"args":[],"body":["Int",12345]},["Let",["y",["Var",["Some",["Array","Int"]]]],["Array",["Int",10],["Int",3]],["Let",["x",["Var",["Some","Int"]]],["Int",67890],["App",["Var","print_int"],[["If",["Eq",["Get",["Var","y"],["Int",0]],["Int",3]],["Add",["Add",["App",["Var","f"],[]],["Get",["Var","y"],["Int",1]]],["Var","x"]],["Int",7]]]]]]]},"Unit"] 
  ))
  println(new_env.to_knf(input).to_pretty_print())
}

test "cls-reg-bug" {
  let env = KnfEnv::new(@immut/hashmap.T::new())
  let var_name = env.new_str_name("main")
  let new_env = {..env,
      externals: env.externals.add("print_int", Unit) }
  
  let input = @types.Syntax::from_json!(@json.parse!(
    #|["LetRec",{"name":["h",["Fun",[["Tuple",["Int","Int","Int","Int","Int","Int","Int","Int","Int","Int"]]],"Int"]],"args":[["p",["Tuple",["Int","Int","Int","Int","Int","Int","Int","Int","Int","Int"]]]],"body":["LetTuple",[["v1",["Var",["Some","Int"]]],["v2",["Var",["Some","Int"]]],["v3",["Var",["Some","Int"]]],["v4",["Var",["Some","Int"]]],["v5",["Var",["Some","Int"]]],["v6",["Var",["Some","Int"]]],["v7",["Var",["Some","Int"]]],["v8",["Var",["Some","Int"]]],["v9",["Var",["Some","Int"]]],["v10",["Var",["Some","Int"]]]],["Var","p"],["LetRec",{"name":["g",["Fun",["Int"],"Int"]],"args":[["z","Int"]],"body":["Let",["r",["Var",["Some","Int"]]],["Add",["Add",["Add",["Add",["Add",["Add",["Add",["Add",["Add",["Var","v1"],["Var","v2"]],["Var","v3"]],["Var","v4"]],["Var","v5"]],["Var","v6"]],["Var","v7"]],["Var","v8"]],["Var","v9"]],["Var","v10"]],["If",["Not",["LE",["Var","z"],["Int",0]]],["Var","r"],["App",["Var","g"],[["Neg",["Var","z"]]]]]]},["App",["Var","g"],[["Int",1]]]]]},["LetRec",{"name":["main",["Fun",[],"Unit"]],"args":[],"body":["Let",["t1",["Var",["Some","Unit"]]],["App",["Var","print_int"],[["App",["Var","h"],[["Tuple",[["Int",1],["Int",2],["Int",3],["Int",4],["Int",5],["Int",6],["Int",7],["Int",8],["Int",9],["Int",10]]]]]]],"Unit"]},"Unit"]]
  ))
  println(new_env.to_knf(input).to_pretty_print())
}