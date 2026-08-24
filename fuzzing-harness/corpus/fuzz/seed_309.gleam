pub const k_seed: Bool = True
pub const k_limit: Float = 0.5

fn yield(constructor: Float, acc: Int, self_: Int) -> String {
case <<7:4>> {
    <<_:16, 1:4>> -> case acc - 3, True {
      1, _ -> "data" <> "b"
      _, False -> "constructor"
      v0, _ -> "constructor"
    }
    _ -> "b"
  }
}

fn new(self_: Int) -> List(Int) {
case "constructor", {
      let pair = True
      "ab"
    } {
    l, "x" -> []
    v1, "bc" <> rest -> []
    _, _ -> fn(v2, v3) { [] }(0.0, 1.5)
  }
}

fn f2(v4: Float, self_: String) -> List(Int) {
[5, 100]
}

pub fn main() {
  echo True
  echo case "ab" {
    k_limit -> k_seed
    "abc" <> b -> True
    "x" -> case [7] {
      [] -> {
        let rest = [3]
        let this_ = 1
        k_seed
      }
      [] -> !k_seed
      _ -> k_seed && True
    }
  }
}
