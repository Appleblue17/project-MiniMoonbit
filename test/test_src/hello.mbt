fn f(x: Int) -> Int {
  x * x
};
fn g(tup: (Int, Int)) -> Int {
  let (x, y) = tup;
  f(x) + f(y)
};

fn main {
  let tup = (3, 4);
  print_int(g(tup))
};