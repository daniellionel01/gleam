pub const k_pi: Bool = True
pub const k_limit: Float = 3.14
pub const k_tag: Float = 0.5

pub type V0 {
  Cv1(value: List(Int))
  Cv2(value: List(Int))
}

pub type V3 {
  Cv4(value: Bool)
  Some(Bool)
  Cv5
}

pub type V6 {
  Cv7(Int, String)
  Cv8(value: String, inner: String)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn new(value: String) -> Int {
case value <> "res" {
    "bc" -> 42 - {
      2 |> spin(10)
    }
    "data" as whole -> 100
    "constructor" | "data" <> _ -> 1 |> spin(7)
    _ -> case Cv8("x", "") {
      Cv8(inner, _) -> 10
      Cv8("abc" <> _, "a") -> 100
      v9 -> spin(7, 42)
    }
  }
}

pub fn main() {
  let l = [7]
  echo 10.0
  echo case <<"":utf8, "data":utf8>> {
    <<y:16, _:big-signed-16>> if y <= 7 -> case {
        let k_limit = 100
        l
      } {
      [6] as whole -> k_tag
      [4, 3, ..] -> k_limit
      [] -> fn(v10, v11) { 3.14 }(False, False)
      v12 -> {
        let v12 = [5, 3]
        let delete = 10.0
        k_tag
      }
    }
    <<_:16, 42:16>> -> k_tag
    <<"b":utf8>> -> k_tag
    _ -> case 3.14 {
      10.0 -> 0.25
      item -> 10.0
    }
  }
}
