fn main {
  fn gen_arr(m: Int, n: Int) -> Array[Int] {
    let mat = Array::make(m, 0);
    fn init_arr(i: Int) -> Unit {
      mat[i] = n;
      ()
    };
    let _ = init_arr(0);
    mat
  };
  
  let c = gen_arr(2, 2);
  let _ = print_int(c[0]);
  ()
};
