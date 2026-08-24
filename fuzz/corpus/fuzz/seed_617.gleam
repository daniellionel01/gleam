pub const k_seed: Float = 0.1
pub const k_golden: Bool = False
pub const k_limit: Bool = True

pub type V0 {
  Cv1(value: List(Int), inner: Int)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn yield(arguments: Int, v2: V0, v3: Int) -> Float {
{
    1.0
  } -. {
    case v3 {
      2 as whole if whole > 9 -> fn(v4) { 1.5 }("a")
      _ -> 0.25
    }
  }
}

pub fn main() {
  let k_seed = case fn(v5, v6) { v6 }(True, 10) {
    v7 -> k_golden
    v8 -> True
  }
  let value = 0
  echo 1.0
  echo case "a" <> "", k_limit {
    "data" <> rest, True -> "ab"
    _, True -> "a"
    _, False -> fn(v9, v10) { "constructor" }(100, 1)
    _, v11 -> case <<"constructor":utf8, "bc":utf8>> {
      <<_:utf8, 1:1>> -> "bc" <> "ab"
      _ -> "b"
    }
  }
  echo case <<"":utf8, "":utf8, "bc":utf8>> {
    <<"b":utf8>> -> case value - value {
      _ -> []
      1 | 7 -> [2, 4]
    }
    _ -> case fn(v12, v13) { "abc" }(0.0, True) {
      "b" -> [1]
      "res" <> _ -> fn(v14, v15) { [] }(0.1, 42)
      "constructor" -> {
        let item = 100
        let k_limit = 3.14
        []
      }
      _ -> [42, 42]
    }
  }
}
