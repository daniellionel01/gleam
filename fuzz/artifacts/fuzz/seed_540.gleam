pub const k_e: Bool = True
pub const k_pi: Bool = True
pub const k_limit: Float = 3.14

pub type Promise {
  Cv0(value: String, inner: Int)
  Error(List(Int))
}

pub type V1 {
  Cv2(Int, value: Float)
  Cv3(value: Int)
  Cv4
}

fn static(delete: #(String, String)) -> Float {
case <<"x":utf8>> {
    <<_:utf8, "res":utf8>> -> case 10 * 42 {
      3 -> {
        1.5
      } +. {
        1.0
      }
      item -> {
        0.25
      } -. {
        0.5
      }
      rest -> 0.1
    }
    <<_:utf8>> as whole -> 1.0
    _ -> 3.14
  }
}

fn default(v5: Int, z: String) -> Bool {
True
}

pub fn main() {
  echo static(case k_pi, {
      let k_pi = []
      let n = k_limit
      #(True, 2.0)
    } {
    False, #(_, _) -> #("bc", "a")
    _, #(_, 100.0) -> #("abc", "x")
    _, v6 -> fn(v7, v8) { #("", "abc") }(True, "b")
  })
  echo 0
}
