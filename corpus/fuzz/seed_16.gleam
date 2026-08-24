pub const k_tag: Float = 0.1
pub const k_pi: Float = 0.0
pub const k_e: Bool = True

pub type Map {
  Record
}

pub type V0 {
  Cv1
  Error(value: List(Int), inner: Float)
  Cv2(String, value: String)
}

pub type V3 {
  Ok(value: Int)
  Cv4
  Cv5(value: Float, inner: List(Int))
}

fn f0(v6: Int, v7: Int, arguments: Bool) -> List(Int) {
[10, 4]
}

fn f1(n: Int, self_: Float, v8: Int) -> Float {
0.0
}

fn f2(v9: Bool, delete: Int) -> String {
case Record {
    Record | Record -> "bc"
    Record -> {
      "" <> "constructor"
    } <> "constructor"
    _ -> case fn(v10) { #(False, 100.0) }("constructor") {
      #(True, _) -> "a"
      inner -> "b" <> "bc"
      item -> "ab" <> "res"
    }
  }
}

pub fn main() {
  let y = 100 |> f0(fn(v11) { 1 }(True), {
    let k_tag = "b"
    let k_pi = []
    True
  })
  echo {
    case f2(k_e, 100), 0 {
      _, 9 -> fn(v12, v13) { 4 }("data", 0.25)
      "ab", 8 -> 4
      _, _ -> fn(v14, v15) { 1 }(2, "bc")
    }
  } - 2
  echo {
    case "data" {
      "data" -> k_pi
      "res" <> b | "b" <> b -> k_pi +. {
        0.0
      }
      _ -> k_pi +. k_tag
    }
  } +. {
    0.1
  }
  echo case Record {
    Record -> [4]
    _ -> f0(0, 100, True)
  }
  echo case 5 {
    4 | 1 -> {
      k_e || True
    } && False
    inner -> f2(k_e, 3) == ""
  }
}
