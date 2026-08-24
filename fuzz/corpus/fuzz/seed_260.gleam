pub const k_seed: Bool = False
pub const k_pi: Bool = False
pub const k_limit: Int = 7

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(value: Float, inner: Int)
}

pub type V3 {
  Cv4
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn extends(prototype: Bool, n: V0) -> Int {
fn(v5, v6) { case v6 +. v6 {
    a -> 42
    1.0 | 1.0 -> 100
  } }("x", 0.1)
}

fn f1(v7: Int, v8: String) -> List(Int) {
[42]
}

fn f2(m: Float) -> Float {
3.14
}

pub fn main() {
  let prototype = case "x", k_seed {
    "constructor" <> rest, True as whole if rest == "ab" && !whole -> fn(v9, v10) { [] }(0, 100.0)
    "bc" <> _, default -> [10, 7]
    _, _ -> f1(5, "ab")
  }
  let prototype = {
    k_limit |> spin(3 - k_limit)
  } < {
    k_limit * k_limit
  }
  echo k_limit
  echo case {
      let prototype = "res"
      Cv1([100], 0)
    } {
    Cv1([k_pi], _) -> {
      let m = "constructor"
      let rest = k_pi + k_limit
      {
        let k_seed = "bc"
        let l = 0.0
        prototype
      }
    }
    Cv1([_, ..rest], _) -> {
      let constructor = k_limit
      let prototype = 2.0
      k_pi
    }
    v11 -> False
  }
}
