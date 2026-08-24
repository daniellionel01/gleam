pub const k_golden: Int = 0
pub const k_pi: Int = 2

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Bool, l: Int, v0: #(Int, Bool)) -> Float {
case {
      let default = [42, 2]
      let class = [1, 3]
      False
    } {
    v1 -> {
      {
        100.0
      } -. {
        0.5
      }
    } +. {
      fn(v2, v3) { 0.1 }(False, "a")
    }
    v4 -> case {
        0.0
      } -. {
        2.0
      } {
      constructor -> constructor
      s -> 100.0
    }
  }
}

fn f1(v5: Bool, v6: Bool, l: String) -> String {
l
}

pub fn main() {
  let rest = {
    "x" <> "a"
  } <> {
    fn(v7) { "ab" }(10)
  }
  echo 3.14
  echo {
    case fn(v8) { rest }(42), spin(5, k_pi) {
      _, _ -> 3 |> spin(spin(k_pi, 3))
      k_pi, _ -> 100
      _, v9 -> fn(v10, v11) { k_pi }(True, "")
    }
  } - {
    case k_golden < 7 {
      b -> spin(k_golden, k_pi)
      inner -> k_pi % 2
      True | True -> spin(4, k_golden)
    }
  }
}
