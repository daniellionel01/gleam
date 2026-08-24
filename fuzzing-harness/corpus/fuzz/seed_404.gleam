pub const k_tag: Int = 1

pub type Map {
  Cv0(value: String, inner: String)
  Cv1(List(Int), String)
  Cv2(String)
}

fn f0(v3: Int, x: Int, delete: Float) -> Int {
v3 + 3
}

pub fn main() {
  echo case k_tag {
    _ -> case Cv2("b"), k_tag {
      _, 8 -> {
        100.0
      } *. {
        0.1
      }
      _, k_tag -> {
        3.14
      } +. {
        10.0
      }
    }
    9 -> 0.0
  }
  echo case "b" {
    b -> case Cv2("ab") {
      Cv0(_, "ab") -> fn(v4, v5) { "bc" }(1.0, True)
      Cv2("data") | Cv2(_) -> b
      _ -> ""
    }
    item -> item
  }
  echo "constructor"
}
