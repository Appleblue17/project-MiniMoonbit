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