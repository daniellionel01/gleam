pub const k_tag: Bool = True
pub const k_seed: Bool = False

pub type V0 {
  Some(value: String, inner: String)
}

pub type V1 {
  Cv2(List(Int))
  None(Int)
  Cv3(Float, value: Bool)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(v4: String, item: V1, v5: Int) -> List(Int) {
case "b", [4] {
    "abc", [b, ..rest] -> {
      let delete = v4
      let arguments = 0.0
      [3, 100]
    }
    "bc" <> _, [2] -> {
      let s = v4 <> v4
      []
    }
    _, _ -> [10]
  }
}

pub fn main() {
  echo case spin(5, 42) {
    v6 -> case "a" {
      item -> False
      "x" -> {
        let s = v6
        let prototype = False
        k_tag
      }
    }
    1 -> k_seed
  }
  echo case Some("x", "") {
    Some(length, _) if length != "abc" -> case 2 + 2, None(5) {
      2, Cv3(100.0, False) -> True
      1, _ -> {
        let k_tag = 0
        let new = 0.1
        k_seed
      }
      _, _ -> k_tag
    }
    Some(_, "a") -> 5 <= {
      {
        let k_tag = k_tag
        let k_tag = k_tag
        5
      }
    }
    Some(_, "" <> rest as whole) -> k_tag
    _ -> case fn(v7) { "a" }(True), "x" {
      "constructor", "b" as whole -> k_tag
      "data" <> rest as whole, v8 -> False
      "bc", "b" <> _ -> {
        100.0
      } >. {
        0.0
      }
      _, _ -> fn(v9, v10) { True }("bc", 0.0)
    }
  }
  echo 3
}
