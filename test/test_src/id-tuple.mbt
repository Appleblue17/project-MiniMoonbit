fn f(t: (Int, Int) ) -> Int {
  let (x, y) = t;
  x + y
};

fn main {
  let t = (1, 2);
  print_int(f(t))
};