pub const k_pi: Bool = True
pub const k_tag: String = "a"

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(class: String) -> Bool {
True || {
    fn(v0) { fn(v1, v2) { False }("b", 10) }(True)
  }
}

pub fn main() {
  let class = case [5, 10] {
    [a, ..rest] as whole -> True
    [b] -> True
    _ -> constructor(k_tag)
  }
  echo fn(v3) { case 5 {
    6 -> k_pi || k_pi
    v4 -> v3
  } }(False)
  echo k_tag
  echo case spin(10, 4) {
    8 as whole if whole > 2 -> {
      {
        let x = k_tag
        let class = 2.0
        whole
      }
    } - spin(whole, 42)
    v5 -> 2
    inner -> inner
  }
}
