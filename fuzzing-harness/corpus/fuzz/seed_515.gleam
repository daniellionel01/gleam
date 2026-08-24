pub const k_golden: String = "bc"
pub const k_limit: Int = 4

fn yield(constructor: #(Bool, List(Int)), v0: Int, length: #(Float, Bool)) -> Float {
3.14
}

fn f1(acc: Float, v1: Int) -> List(Int) {
[100]
}

pub fn main() {
  echo 5
  echo {
    case "b" <> k_golden, 1 {
      _, _ -> 42
      "bc", k_golden -> 5 - 5
    }
  } + {
    case "ab" {
      _ -> k_limit
      "res" | "res" <> _ -> {
        let length = 2.0
        let k_limit = k_limit
        1
      }
      "a" -> 7
    }
  }
  echo case k_limit + k_limit {
    inner -> {
      fn(v2) { 0 }(3.14)
    } * 7
    _ | 0 -> 3
  }
  echo #(False, []) |> yield({
    let prototype = 0.5
    let length = True
    k_limit
  }, #(1.0, True))
}
