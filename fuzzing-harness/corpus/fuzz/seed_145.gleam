pub const k_e: Float = 3.14
pub const k_seed: Float = 0.0
pub const k_golden: Int = 10

pub type Map {
  Cv0(value: String, inner: Int)
  Cv1
  Record
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v2: String, v3: Bool, v4: Int) -> Float {
2.0
}

pub fn main() {
  let k_golden = spin(4, 10 - k_golden)
  let k_seed = True
  echo k_e
  echo "data"
}
