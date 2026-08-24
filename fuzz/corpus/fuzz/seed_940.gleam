pub const k_seed: Bool = False
pub const k_golden: Int = 42
pub const k_tag: Int = 4

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Int, prototype: Bool, v0: Int) -> String {
case "bc" {
    _ -> "x"
    "data" -> {
      "b" <> "constructor"
    } <> "abc"
  }
}

fn f1(constructor: Float, prototype: Bool, delete: String) -> String {
"bc" <> "res"
}

fn f2(v1: Bool) -> List(Int) {
case [7] {
    [b] as whole -> []
    [] -> [42, 3]
    _ -> [0, 100]
  }
}

pub fn main() {
  let k_seed = fn(v2) { {
    let s = "b"
    let x = False
    5
  } }(True)
  let prototype = 100.0
  echo 2
  echo fn(v3) { True }("bc")
  echo False
}
