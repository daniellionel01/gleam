pub const k_limit: Int = 0
pub const k_e: Bool = True
pub const k_golden: Float = 1.5

pub type Promise {
  Cv0(value: String, inner: Bool)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v1: #(Int, Float)) -> String {
"constructor"
}

pub fn main() {
  echo case fn(v2) { Cv0("", True) }("ab") {
    _ -> 1 - {
      fn(v3, v4) { 2 }(0.0, 4)
    }
    Cv0("res", True) -> spin(5, k_limit)
    _ | Cv0(_, _) -> spin(k_limit, k_limit) - {
      100 + k_limit
    }
  }
  echo case Cv0("a", False) {
    Cv0(b, _) if b != "x" -> k_golden -. {
      {
        2.0
      } /. {
        10.0
      }
    }
    Cv0("bc", False) -> 2.0
    _ -> k_golden
  }
  echo case "x" <> "ab", "constructor" <> "a" {
    v5, "data" if v5 != "" && v5 != "a" -> spin(fn(v6) { 3 }("constructor"), 10 - k_limit)
    "b", "x" -> 1
    "constructor", _ -> 42
    v7, v8 -> {
      fn(v9, v10) { 4 }(10.0, 42)
    } + k_limit
  }
}
