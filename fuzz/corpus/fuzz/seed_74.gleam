pub const k_golden: String = ""
pub const k_e: Float = 2.0
pub const k_pi: Float = 3.14

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Bool, v0: Int, l: String) -> Float {
1.5
}

pub fn main() {
  let prototype = case False, {
      let delete = k_golden
      k_golden
    } {
    True, _ -> 1 |> spin(fn(v1, v2) { v2 }(0.25, 42))
    _, _ -> 42
  }
  echo {
    case True {
      _ -> {
        let this_ = []
        7
      }
      True | False -> fn(v3) { 7 }(1.0)
    }
  } % 3
  echo case fn(v4, v5) { k_golden }(42, True), k_golden {
    "res", "abc" <> _ as whole if whole == "data" || whole != "" -> {
      let new = {
        let l = True
        let length = k_pi
        k_pi
      }
      fn(v6) { "ab" }(1.0)
    }
    "b" as whole, "x" as it -> whole
    _, v7 -> case <<"x":utf8, "a":utf8>> {
      <<"a":utf8>> -> v7 <> v7
      <<_:utf8>> -> "res"
      _ -> v7
    }
  }
}
