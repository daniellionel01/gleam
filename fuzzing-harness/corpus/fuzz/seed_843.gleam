pub const k_limit: String = "b"
pub const k_golden: Float = 1.0

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(Int, value: String)
  Cv3(Float, String)
}

fn export(v4: Bool) -> String {
case 0, v4 {
    4, False -> "a"
    3, True -> ""
    _, _ -> "res"
  }
}

pub fn main() {
  let k_golden = export(False)
  let k_golden = case [], 10 {
    [2], 8 as whole -> ""
    [1, 3, ..] as whole, _ -> k_golden <> k_limit
    [x] as whole, _ -> k_limit <> "abc"
    _, v5 -> k_limit <> k_golden
  }
  echo case {
      let pair = False
      k_limit
    } {
    _ -> False
    _ -> {
      let s = k_limit <> k_limit
      let m = {
        let x = "bc"
        let constructor = 0.1
        True
      }
      100 >= 100
    }
  }
}
