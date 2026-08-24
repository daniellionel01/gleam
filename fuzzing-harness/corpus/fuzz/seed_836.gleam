pub const k_pi: String = "res"

pub type V0 {
  Ok(value: String, inner: Float)
  Cv1(String)
}

fn f0(m: #(Bool, Float), v2: V0) -> Float {
{
    let this_ = "ab"
    let y = {
      {
        let class = []
        let x = this_
        0.0
      }
    } <=. {
      1.5
    }
    {
      {
        let y = 2
        0.0
      }
    } -. {
      0.1
    }
  }
}

pub fn main() {
  echo f0(#(True, 3.14), Ok("res", 100.0)) *. {
    {
      {
        2.0
      } +. {
        0.5
      }
    } -. f0(#(True, 0.0), Ok("ab", 100.0))
  }
  echo {
    case k_pi <> k_pi {
      "constructor" <> rest | "a" <> rest -> "data" <> rest
      _ -> "b"
      "b" | "data" <> _ -> k_pi <> k_pi
    }
  } <> {
    case f0(#(False, 0.25), Cv1("x")) {
      b -> {
        let y = True
        let n = []
        "a"
      }
      0.5 | 0.25 -> k_pi
    }
  }
}
