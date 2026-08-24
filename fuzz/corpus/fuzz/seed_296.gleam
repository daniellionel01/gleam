pub const k_e: Float = 0.0
pub const k_pi: Int = 4

pub type V0 {
  Cv1
  Cv2
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn class(v3: List(Int), rest: String) -> Float {
{
    case {
        let m = rest
        Cv1
      } {
      Cv2 -> 0.0
      a -> {
        10.0
      } +. {
        1.0
      }
    }
  } +. {
    3.14
  }
}

fn f1(m: Float, v4: Bool) -> String {
case Cv2, 7 {
    Cv1, 5 -> "ab"
    Cv2, 2 -> "abc"
    v5, _ -> "constructor" <> "bc"
  }
}

pub fn main() {
  echo fn(v6) { fn(v7, v8) { {
    let self_ = [5]
    v8
  } }(42, "bc") }(3)
  echo k_pi
  echo case "b" {
    "res" <> a -> {
      7 - 100
    } - 2
    "abc" -> k_pi
    _ -> k_pi
  }
  echo {
    case [10, 3] {
      [] as whole -> whole |> class("x")
      [_] -> k_e
      _ -> class([0], "abc")
    }
  } |> f1(True)
}
