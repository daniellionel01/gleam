pub const k_tag: String = "x"
pub const k_seed: Bool = True

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(item: Bool) -> Bool {
case [] {
    [] -> case "bc", {
        let constructor = 1
        #(False, "abc")
      } {
      "abc" <> rest, #(_, "bc") as whole -> True
      _, #(_, "ab") -> !True
      _, v0 -> item
    }
    [item, b, ..] -> True
    _ -> 100 >= walk([], 2)
  }
}

pub fn main() {
  let prototype = fn(v1) { v1 <> k_tag }("data")
  let prototype = {
    let y = 0.5
    let this_ = fn(v2) { True }(3)
    y *. y
  }
  echo 0.0
  echo case {
      let y = k_seed
      let k_tag = 10
      ""
    } {
    "abc" -> "res"
    "x" <> rest | "abc" <> rest -> rest
    "x" | "constructor" -> k_tag
    _ -> case "x" <> k_tag, [] {
      "bc", [4, ..rest] -> k_tag
      "data", [b, 8, ..] as whole -> fn(v3) { k_tag }(4)
      "bc" <> rest, [a, ..tail] -> "b"
      _, _ -> fn(v4) { k_tag }(0)
    }
  }
  echo 7 + {
    10 + {
      2 + 4
    }
  }
  echo case fn(v5) { k_tag }(0.0) {
    a | "ab" <> a -> fn(v6) { 42 }("res")
    "b" -> case 0.0 {
      _ -> 1
      0.0 -> 4
      0.25 -> 10
    }
  }
}
