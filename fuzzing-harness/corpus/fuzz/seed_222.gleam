pub const k_pi: Int = 1

pub type Promise {
  Cv0(value: String, inner: String)
  Cv1(value: Int, inner: Float)
}

fn extends(v2: Int, constructor: Float, v3: Int) -> String {
case False, "b" <> "b" {
    _, "abc" -> "bc"
    True, "ab" <> rest -> fn(v4) { {
      let this_ = v4
      let new = rest
      "constructor"
    } }("data")
    class, _ -> "constructor"
  }
}

pub fn main() {
  let k_pi = case "constructor", fn(v5) { k_pi }("") {
    "x" as whole, v6 -> [5, 5]
    _, 4 -> [5]
    "data" <> rest, 9 -> fn(v7) { [5, 42] }(7)
    _, v8 -> [0]
  }
  let k_pi = {
    let k_pi = fn(v9, v10) { k_pi }(True, 0)
    k_pi
  }
  echo {
    case 0.0, k_pi {
      100.0, [6, ..rest] -> "ab"
      _, [a, k_pi, ..] as whole -> "ab"
      v11, _ -> extends(10, v11, 2)
    }
  } != "bc"
  echo True
  echo 3.14
}
