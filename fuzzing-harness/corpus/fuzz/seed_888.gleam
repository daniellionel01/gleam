pub const k_limit: String = "b"
pub const k_pi: Float = 3.14
pub const k_e: Int = 1

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(m: Int) -> Bool {
False
}

pub fn main() {
  let y = False
  let y = {
    fn(v0, v1) { "ab" }(1, 0.0)
  } == "res"
  echo case k_e + k_e {
    _ -> [4]
    a -> fn(v2, v3) { {
      let default = k_limit
      let v2 = [5]
      v2
    } }(0.25, 0.0)
  }
  echo k_limit
  echo y
}
