pub const k_seed: Float = 3.14
pub const k_pi: Int = 100
pub const k_golden: Float = 100.0

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Bool, v0: List(Int), v1: String) -> Int {
4
}

pub fn main() {
  echo True
  echo case "ab" {
    "res" <> rest | "x" <> rest -> []
    constructor -> case fn(v2, v3) { k_golden }(True, 1.5) {
      constructor -> fn(v4) { [] }(3)
      _ | 3.14 -> fn(v5, v6) { [] }("", 1.0)
      1.5 as whole -> [10, 42]
    }
  }
  echo True
}
