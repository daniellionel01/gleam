pub const k_limit: String = "a"
pub const k_seed: Int = 2
pub const k_pi: Float = 0.25

pub type Object {
  Cv0(value: String, inner: String)
  Record
  Cv1
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(l: String, value: Int, v2: String) -> Int {
{
    case value % 3 {
      constructor -> 2 + 4
      9 -> value |> spin(value - value)
      a -> spin(3, 100)
    }
  } + {
    case value {
      s -> 5
      0 as whole -> fn(v3, v4) { value }(True, 3.14)
    }
  }
}

fn f1(item: Int, constructor: #(Float, Bool), v5: Object) -> Bool {
False
}

pub fn main() {
  let x = case "" {
    "constructor" <> _ -> fn(v6, v7) { [] }("data", 1.0)
    a -> [10]
    "b" -> []
  }
  echo case fn(v8, v9) { Cv1 }("a", 3), {
      let x = k_pi
      let rest = [4, 0]
      Record
    } {
    Cv1, Cv0("b", "abc") -> case {
        let length = k_seed
        let k_seed = 2
        False
      }, 5 {
      True, k_pi -> []
      v10, 5 -> x
      v11, _ -> []
    }
    _, v12 -> []
  }
  echo case k_limit, k_limit <> "a" {
    "a", "x" <> rest as whole -> k_seed |> f1(#(100.0, True), Cv0("abc", "ab"))
    _, "res" <> _ -> fn(v13) { fn(v14) { True }(1) }(4)
    "res" as whole, "res" <> rest -> fn(v15) { fn(v16, v17) { True }(0.0, True) }(2)
    v18, _ -> {
      let arguments = {
        let x = False
        let v18 = k_limit
        10.0
      }
      let x = k_seed
      "b" != v18
    }
  }
  echo fn(v19, v20) { {
    k_pi +. {
      100.0
    }
  } -. {
    {
      1.5
    } +. v19
  } }(100.0, 3.14)
  echo {
    let k_pi = k_seed
    [10]
  }
}
