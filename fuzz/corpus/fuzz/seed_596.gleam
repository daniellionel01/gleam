pub const k_e: Float = 2.0
pub const k_limit: Float = 0.5

pub type Record {
  Cv0(value: String, inner: Bool)
  Cv1(Int, value: List(Int))
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(prototype: Float) -> List(Int) {
case 100 {
    3 | 8 -> [4]
    prototype -> []
  }
}

pub fn main() {
  echo {
    case {
        let k_e = 4
        let y = [1, 42]
        "ab"
      } {
      a -> 5
      item -> 7 - 0
      constructor | "bc" <> constructor -> {
        let x = True
        100
      }
    }
  } + 4
  echo case Cv0("x", False) {
    Cv1(5, [7, b, ..]) if b <= 2 -> {
      {
        let k_e = False
        k_limit
      }
    } -. k_e
    Cv0("b" <> _, prototype) if prototype && prototype -> {
      k_e *. k_e
    } -. {
      0.1
    }
    Cv0("abc" <> rest, False) -> 10.0
    _ -> 1.5
  }
  echo k_e
}
