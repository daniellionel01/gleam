pub const k_golden: Int = 3
pub const k_e: Float = 1.5
pub const k_tag: Float = 3.14

pub type V0 {
  Record(value: String, inner: Int)
}

pub type V1 {
  Cv2
  Cv3
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Int) -> List(Int) {
[42, 1]
}

pub fn main() {
  echo case k_golden, {
      let k_e = "bc"
      "ab"
    } {
    9, _ -> True
    item, "res" -> case item, {
        let this_ = k_tag
        let constructor = True
        []
      } {
      v4, [k_e] as whole if v4 <= 1 && v4 % 2 == 0 -> False
      0, [4] as whole -> False
      v5, _ -> True
    }
    _, _ -> k_golden != {
      {
        let arguments = False
        let k_e = [4, 3]
        k_golden
      }
    }
  }
  echo "b"
  echo 3
  echo fn(v6, v7) { "b" }(False, "abc")
}
