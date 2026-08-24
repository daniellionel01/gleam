pub const k_limit: Bool = False

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(class: String) -> List(Int) {
case 2.0 {
    0.25 | 1.0 -> [3]
    item -> []
  }
}

pub fn main() {
  echo fn(v0, v1) { case "res" {
    _ -> k_limit && k_limit
    item | "x" <> item -> k_limit
  } }(False, True)
}
