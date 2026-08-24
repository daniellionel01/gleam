pub const k_pi: Int = 7

pub type V0 {
  Record(value: String, inner: Int)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(y: Int, n: Float, x: #(Bool, String)) -> Float {
{
    0.25
  } +. {
    0.25
  }
}

pub fn main() {
  let this_ = spin(5, k_pi) + k_pi
  echo "a"
  echo {
    case Record("bc", 100) {
      _ -> {
        let k_pi = False
        "constructor"
      }
      Record(b, _) -> "a" <> b
    }
  } <> {
    fn(v1, v2) { "" <> "bc" }(10.0, True)
  }
  echo {
    "data" <> ""
  } <> {
    "bc" <> {
      {
        let k_pi = this_
        let this_ = True
        ""
      }
    }
  }
  echo k_pi
}
