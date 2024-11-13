fn main {
  let ary = Array::make(5, (3, 4));
  let (x, y) = ary[2];
  let _ = print_int(x);
  let _ = print_endline();
  print_int(y)
};