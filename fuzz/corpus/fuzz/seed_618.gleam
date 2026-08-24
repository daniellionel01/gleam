pub const k_seed: Int = 0
pub const k_limit: String = "abc"
pub const k_pi: Bool = False

pub type V0 {
  Record(value: String, inner: List(Int))
  Error(value: String, inner: Float)
  Number(value: List(Int), inner: Int)
}

pub type Object {
  Cv1
  Cv2
  Cv3(value: Float)
}

fn f0(prototype: Int) -> Bool {
True
}

fn f1(v4: Float, default: List(Int)) -> Int {
1
}

pub fn main() {
  echo {
    {
      fn(v5) { k_limit }("abc")
    } <> {
      fn(v6) { k_limit }(7)
    }
  } <> {
    case {
        let m = k_limit
        let m = 10.0
        [1]
      } {
      [6, ..rest] -> k_limit
      [a, ..rest] -> {
        let a = k_pi
        let length = rest
        k_limit
      }
      v7 -> k_limit
    }
  }
  echo case Cv2, Cv1 {
    Cv2 as whole, Cv2 -> {
      let k_seed = 1 - k_seed
      let n = k_limit
      False
    }
    Cv3(_), Cv1 -> {
      "x" == k_limit
    } && {
      k_seed > k_seed
    }
    v8, v9 -> k_pi
  }
  echo {
    1.5
  } |> f1([7])
}
