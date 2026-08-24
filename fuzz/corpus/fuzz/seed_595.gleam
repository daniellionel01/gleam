pub const k_pi: Float = 1.5
pub const k_tag: Bool = False
pub const k_e: Int = 3

pub type Record {
  Cv0(value: String, inner: List(Int))
  Cv1
  Cv2(value: Float)
}

fn f0(rest: Int, delete: #(List(Int), Bool)) -> Int {
0 - {
    {
      rest + rest
    } % 7
  }
}

pub fn main() {
  echo case f0(k_e, #([10], True)) {
    1 -> case fn(v3, v4) { "bc" }(42, True) {
      item | "" <> item -> {
        let m = k_tag
        let k_pi = k_tag
        ""
      }
      item -> item
      _ -> ""
    }
    8 | 0 -> "a" <> {
      {
        let l = 1.5
        let value = 0.1
        "res"
      }
    }
    inner -> ""
  }
}
