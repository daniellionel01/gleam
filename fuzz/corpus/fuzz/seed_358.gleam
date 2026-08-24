pub const k_e: Bool = False
pub const k_seed: Int = 100
pub const k_limit: Int = 5

pub type V0 {
  Cv1(value: List(Int))
  Cv2(value: Float)
  Error(value: List(Int))
}

pub type V3 {
  Cv4(value: String, inner: Bool)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v5: String) -> Float {
{
    1.5
  } *. {
    0.25
  }
}

fn f1(l: String) -> Bool {
True
}

pub fn main() {
  let pair = case "bc", 0.0 {
    _, k_e -> []
    "ab", 100.0 -> {
      let l = k_limit
      let y = 0.5
      [0, 100]
    }
  }
  let k_seed = fn(v6) { {
    let value = k_e
    let v6 = 10.0
    "a"
  } }(True)
  echo case Cv2(0.25), k_limit |> spin(k_limit) {
    Error([_, ..rest]), _ -> case k_limit {
      constructor -> k_seed
      9 -> k_seed <> k_seed
    }
    Error([]), _ -> k_seed <> {
      {
        let k_seed = k_seed
        let delete = 1.5
        k_seed
      }
    }
    _, v7 -> k_seed
  }
}
