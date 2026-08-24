pub const k_limit: Int = 42
pub const k_golden: String = "data"

pub type Object {
  Cv0(value: String, inner: Int)
  Error(value: List(Int))
  Cv1(String, Bool)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v2: Object, l: Int, v3: String) -> Float {
1.0
}

pub fn main() {
  let self_ = []
  let k_limit = 42
  echo 4
  echo {
    {
      let y = []
      let self_ = self_
      k_golden
    }
  } <> k_golden
}
