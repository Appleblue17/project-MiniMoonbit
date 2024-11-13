fn make_pow(x: Int) -> (Int) -> Int {
  fn pow(n) {
    if n == 0 {
      1
    } else {
      pow(n - 1) * x
    }
  };
  pow
};

fn main {
  print_int(make_pow(3)(4))
};