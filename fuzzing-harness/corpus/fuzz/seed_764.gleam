pub const k_pi: Float = 0.25
pub const k_e: Int = 0

pub type V0 {
  Cv1(value: List(Int))
  Cv2
}

pub type Symbol {
  None(value: List(Int))
  Cv3(String, value: Bool)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(class: Int) -> String {
{
    let pair = 100
    let pair = 2
    "res"
  }
}

pub fn main() {
  let x = case True {
    True -> [3, 0]
    False -> [100]
  }
  echo case k_e, k_e {
    3, _ -> case k_e - k_e {
      1 | 8 -> k_pi +. k_pi
      _ | 3 -> k_pi +. k_pi
      2 | 0 -> 100.0
    }
    6, x -> case {
        let x = k_e
        let k_pi = [3]
        2.0
      }, 42 {
      x, _ -> k_pi /. {
        2.0
      }
      v4, 6 as whole -> v4 -. k_pi
    }
    _, _ -> k_pi
  }
}
