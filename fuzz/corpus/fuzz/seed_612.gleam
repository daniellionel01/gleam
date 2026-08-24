pub const k_tag: String = "constructor"

fn f0(m: String) -> String {
"x"
}

fn f1(constructor: #(List(Int), Bool), m: Int, v0: List(Int)) -> String {
case True {
    item -> "abc"
    True -> "bc"
    _ -> "ab"
  }
}

pub fn main() {
  let new = {
    fn(v1, v2) { v2 }(2.0, 100)
  } <= 2
  let k_tag = {
    10.0
  } +. {
    1.5
  }
  echo case [0, 3] {
    [constructor, ..rest] -> False
    [k_tag, ..rest] as whole -> new
    _ -> case f1(#([0], False), 4, [10]) {
      _ -> new
      item | "b" <> item -> new
      _ -> True
    }
  }
  echo {
    let new = 0.0
    []
  }
}
