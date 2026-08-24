pub const k_e: Float = 1.0
pub const k_golden: Bool = True
pub const k_seed: Int = 3

pub type Symbol {
  Record
  Cv0(Int)
}

pub type V1 {
  Cv2
  Cv3(Int, value: Int)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(value: String, v4: String) -> String {
value <> value
}

pub fn main() {
  let k_seed = "b"
  let k_golden = [2]
  echo k_golden
  echo walk(fn(v5, v6) { k_golden }(0.0, 4), 4)
  echo {
    {
      k_seed <> k_seed
    } <> "bc"
  } <> {
    case 1, Cv2 {
      y, rest -> f0(k_seed, "abc")
      3, Cv3(6, v7) if v7 % 2 == 0 -> fn(v8, v9) { k_seed }(True, True)
      2, _ -> fn(v10, v11) { "b" }(0, 1)
    }
  }
}
