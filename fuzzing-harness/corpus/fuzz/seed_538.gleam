pub const k_golden: String = "data"
pub const k_seed: Int = 1
pub const k_tag: Int = 100

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(List(Int), value: String)
  Cv3(Float)
}

fn f0(constructor: Bool, v4: Bool) -> List(Int) {
[]
}

fn f1(this_: Bool, constructor: Int) -> Bool {
False
}

pub fn main() {
  let y = {
    let prototype = !True
    fn(v5) { "abc" }("data")
  }
  let default = case k_golden <> k_golden, Cv3(1.5) {
    "x", Cv2([7, ..rest], "data" <> tail) -> 1
    "data", Cv3(_) -> 1
    _, v6 -> 7 * k_seed
  }
  echo {
    case y <> k_golden {
      b -> {
        2.0
      } +. {
        2.0
      }
      _ -> {
        100.0
      } +. {
        10.0
      }
      "bc" <> constructor | "res" <> constructor -> 3.14
    }
  } <. {
    0.1
  }
}
