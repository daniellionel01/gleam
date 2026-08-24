pub const k_seed: String = "abc"
pub const k_limit: Int = 4
pub const k_golden: Float = 3.14

pub type V0 {
  Error(value: String, inner: List(Int))
  Cv1
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn class(arguments: String, y: Int, v2: Int) -> String {
"ab"
}

fn f1(v3: Int, v4: Bool, new: Int) -> Float {
fn(v5, v6) { case class("b", new, v3), v4 {
    "res", _ -> {
      0.5
    } +. {
      10.0
    }
    _, _ -> 10.0
  } }(10, "res")
}

fn f2(v7: List(Int), x: Bool, class: List(Int)) -> Int {
case fn(v8) { "b" }(False) {
    "res" -> spin(2 % 3, 3)
    "abc" -> case 3 + 100, v7 {
      z, [1, 0, ..] -> 7 + 0
      _, [x] -> fn(v9, v10) { x }(False, 0)
      v11, _ -> spin(0, 5)
    }
    v12 -> {
      fn(v13, v14) { v13 }(100, 2.0)
    } + 1
  }
}

pub fn main() {
  echo case {
      0.5
    } -. {
      0.1
    } {
    _ | 0.0 -> k_seed <> {
      "data" <> "abc"
    }
    1.5 -> case 0.0 {
      100.0 -> fn(v15) { "b" }(100.0)
      _ -> class(k_seed, k_limit, k_limit)
    }
    inner -> k_seed <> class(k_seed, 1, 42)
  }
  echo {
    0.0
  } -. {
    case Error("abc", [4]) {
      _ -> 0.25
      Error(b, _) -> k_golden
    }
  }
  echo case {
      let rest = k_limit
      10
    } {
    inner -> [2, 0]
    0 -> fn(v16, v17) { [1] }(True, True)
    _ -> [7]
  }
  echo case k_limit * k_limit {
    constructor -> case "a" <> k_seed {
      "abc" -> 7
      "ab" | "x" -> fn(v18, v19) { v19 }(True, 1)
      v20 -> 100
    }
    _ | 9 -> 42
  }
}
