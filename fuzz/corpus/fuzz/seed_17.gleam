pub const k_e: String = "b"
pub const k_golden: String = "x"

pub type V0 {
  Some(value: String, inner: String)
  Cv1(value: Float, inner: Float)
  Cv2(value: Bool, inner: Float)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v3: V0, this_: String, l: Float) -> Int {
42
}

pub fn main() {
  echo case <<"b":utf8>> {
    <<item:16, _:utf8>> -> case {
        let k_golden = [1]
        let prototype = False
        k_e
      } {
      b -> [4]
      "constructor" | "x" <> _ -> [42, 4]
      "x" | "res" -> fn(v4, v5) { [10] }(False, 5)
    }
    <<100:4, _:little-unsigned-8>> -> [7, 3]
    _ -> [10]
  }
  echo case <<5:4, "data":utf8, 4:1>> {
    <<0:16>> -> 7
    _ -> spin({
      let k_golden = "abc"
      let new = 2
      100
    }, 10)
  }
  echo False
}
