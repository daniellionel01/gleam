pub const k_e: Bool = True
pub const k_seed: String = "a"

pub type V0 {
  Error(value: String, inner: String)
}

pub type Symbol {
  Cv1
  Cv2
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn class(item: #(String, Int), v3: Bool) -> Int {
0
}

fn f1(rest: Float) -> Float {
rest
}

pub fn main() {
  let v = [7, 3]
  let n = case 10 {
    b -> 2
    v4 -> 0 * v4
  }
  echo {
    case {
        let delete = ""
        let default = 1.5
        #(True, False)
      } {
      b -> "a"
      constructor -> "a" <> k_seed
    }
  } <> {
    case n {
      7 -> k_seed <> k_seed
      _ -> k_seed
      b -> "abc" <> k_seed
    }
  }
  echo k_e
  echo "x" <> {
    k_seed <> {
      k_seed <> k_seed
    }
  }
  echo class(#("a", 10), True)
}
