fn main {
  fn frac(n) {
    if n == 1 {
      1
    } else {
      frac(n - 1) * n
    }
  };
  print_int(frac(6))
};
