pub const k_seed: String = "abc"
pub const k_pi: String = "res"
pub const k_tag: Bool = False

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(Float)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(self_: Float) -> List(Int) {
[3, 1]
}

pub fn main() {
  echo case 7 {
    _ -> 0.5
    4 -> case Cv2(3.14), [5] {
      Cv1([9], 6), [] as whole -> 3.14
      Cv1([1], 0), [h] -> 100.0
      v3, v4 -> {
        0.25
      } -. {
        0.25
      }
    }
  }
  echo case {
      let self_ = [5]
      Cv2(0.0)
    } {
    inner -> False && {
      {
        let inner = "constructor"
        let k_pi = k_tag
        k_tag
      }
    }
    Cv1(_, a) -> k_tag || True
  }
  echo {
    {
      {
        10.0
      } -. {
        1.5
      }
    } *. {
      {
        0.1
      } -. {
        2.0
      }
    }
  } -. {
    case [] {
      [b, 1, ..] -> {
        3.14
      } -. {
        1.5
      }
      [_, k_tag, ..] if k_tag <= 0 -> {
        1.5
      } /. {
        2.0
      }
      [2, ..rest] -> 0.0
      _ -> fn(v5, v6) { 0.1 }(4, 42)
    }
  }
  echo {
    1.5
  } -. {
    {
      {
        let this_ = k_tag
        100.0
      }
    } -. {
      {
        0.1
      } +. {
        0.1
      }
    }
  }
}
