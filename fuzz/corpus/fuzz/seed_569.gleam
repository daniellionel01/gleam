pub const k_tag: Int = 42
pub const k_e: String = "ab"
pub const k_seed: Int = 42

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Int, rest: Int, self_: Float) -> List(Int) {
{
    let arguments = case "abc" <> "b" {
      _ -> []
      a | "a" <> a -> [0, 10]
      a | "abc" <> a -> []
    }
    case "ab" <> "a" {
      self_ | "b" <> self_ -> fn(v0, v1) { arguments }(42, False)
      "data" | "ab" <> _ -> [0]
      "ab" -> arguments
    }
  }
}

fn f1(prototype: Bool) -> Bool {
case {
      1.0
    } <=. {
      0.25
    } {
    v2 -> case fn(v3) { "bc" }(5) {
      b -> {
        1.0
      } <=. {
        3.14
      }
      "x" <> rest -> {
        let item = 0.1
        prototype
      }
    }
    _ | True -> prototype
    _ -> False
  }
}

fn f2(v4: String, v5: String, v: Float) -> String {
case v5 {
    "bc" <> constructor -> v4
    constructor -> {
      v5 <> v4
    } <> {
      fn(v6) { "a" }(0.25)
    }
    "res" -> case 4, [1] {
      7, [9, ..rest] as whole -> fn(v7, v8) { v4 }(3.14, 100.0)
      3, [2, 7, ..] -> "res"
      _, _ -> {
        let x = []
        "constructor"
      }
    }
  }
}

pub fn main() {
  echo case "bc" {
    v9 | "a" <> v9 -> f2(f2("bc", "", 2.0), "ab", {
      10.0
    } -. {
      2.0
    })
    b -> "data"
  }
  echo case k_e |> f2("constructor", {
      10.0
    } -. {
      0.0
    }), 0.1 {
    "bc", n -> "bc"
    "data", v10 -> {
      let default = 10.0
      k_e
    }
    k_tag, 0.25 -> k_tag
    _, _ -> {
      fn(v11, v12) { k_e }("ab", True)
    } |> f2("", {
      let this_ = 100.0
      1.0
    })
  }
  echo [1, 0]
}
