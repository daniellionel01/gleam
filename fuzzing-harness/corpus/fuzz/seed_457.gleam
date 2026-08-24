pub const k_seed: String = "bc"
pub const k_pi: Float = 3.14

pub type V0 {
  Number(value: String, inner: List(Int))
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn export(z: List(Int), v1: Int) -> List(Int) {
z
}

fn f1(x: Int, v2: Float) -> Int {
case Number("bc", []) {
    Number(_, [5, ..rest] as whole) -> case Number("a", [4, 42]) {
      v3 -> 4 + x
      _ -> {
        let constructor = False
        let new = "x"
        x
      }
      Number(constructor, _) -> x * 1
    }
    _ | Number(_, _) -> 4 |> spin(x % 2)
    _ -> x + 42
  }
}

pub fn main() {
  let value = case {
      0.25
    } *. {
      0.5
    } {
    item -> item +. item
    0.0 -> k_pi -. k_pi
    constructor -> fn(v4, v5) { 0.25 }("b", True)
  }
  let arguments = 0.0
  echo {
    5 % 2
  } + {
    case k_seed <> k_seed {
      a -> 4 - 4
      v6 -> 4 + 2
    }
  }
  echo case {
      let value = [3]
      k_seed
    } {
    "b" <> rest -> "data"
    "" <> inner if inner == "bc" -> case value -. k_pi {
      item -> fn(v7) { "abc" }(False)
      b -> k_seed
    }
    b | "bc" <> b -> {
      {
        let delete = True
        k_seed
      }
    } <> b
  }
}
