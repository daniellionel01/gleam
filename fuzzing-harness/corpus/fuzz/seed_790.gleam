pub const k_golden: Int = 4
pub const k_pi: Int = 0
pub const k_e: String = ""

pub type Object {
  Cv0(value: String, inner: Int)
}

pub type Map {
  Some(List(Int), List(Int))
  None(value: Int)
  Record
}

fn delete(v1: List(Int), m: Bool, v2: Float) -> Bool {
case 3, fn(v3) { Cv0("constructor", 42) }(10) {
    _, Cv0("x", 3 as whole) if whole <= 2 && whole > 3 -> case v1 {
      [3, 8, ..] -> 2 != whole
      [4, ..rest] as whole -> {
        let v1 = 1.0
        let m = whole
        True
      }
      _ -> fn(v4, v5) { v5 }(4, True)
    }
    s, Cv0("constructor" <> rest as whole, 4) -> case 4 % 3 {
      9 as whole if whole == 2 && whole <= 9 -> {
        0.5
      } >. v2
      _ -> {
        let x = True
        True
      }
      4 -> False
    }
    _, _ -> True || {
      !False
    }
  }
}

pub fn main() {
  echo case 2, {
      0.5
    } +. {
      0.25
    } {
    l, 0.5 -> {
      l + k_pi
    } + 42
    _, _ -> {
      fn(v6) { k_golden }(1)
    } - k_pi
  }
  echo case #(0.25, 10) {
    #(100.0, 6 as whole) -> case whole % 1 {
      item -> whole
      constructor -> k_golden * constructor
    }
    inner -> k_golden
    #(1.5, v7) -> k_pi
  }
}
