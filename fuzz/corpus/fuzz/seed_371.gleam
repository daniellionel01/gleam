pub const k_seed: Float = 3.14
pub const k_golden: String = "abc"

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(Float, List(Int))
  Ok(value: Bool, inner: Int)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(new: Bool) -> String {
{
    case 3.14, "" <> "abc" {
      v3, "" <> rest -> fn(v4, v5) { rest }("b", False)
      100.0 as whole, _ -> "abc" <> "ab"
      v6, _ -> "ab"
    }
  } <> {
    case 0 {
      9 as whole if whole <= 4 && whole <= 3 -> "constructor"
      _ -> "res"
    }
  }
}

fn constructor(x: Int, y: Bool, n: Bool) -> Int {
100
}

fn f2(v7: List(Int), v8: List(Int), v9: Int) -> Int {
{
    {
      let pair = 2 * v9
      pair |> spin(pair)
    }
  } + {
    case [] {
      [7] -> 4
      [a] -> a
      [v8, h, ..] -> 0 + v8
      _ -> v9 - v9
    }
  }
}

pub fn main() {
  echo case k_golden, 100.0 {
    _, _ -> {
      k_seed /. {
        10.0
      }
    } >. k_seed
    "a", rest -> case k_golden {
      v10 | "res" <> v10 -> True
      "res" <> _ as whole -> rest >. {
        1.5
      }
      "a" <> _ | "data" <> _ -> True
    }
    v11, 100.0 -> False
  }
  echo "data"
  echo f0(k_seed == k_seed)
}
