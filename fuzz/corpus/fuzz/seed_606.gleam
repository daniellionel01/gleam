pub const k_pi: Float = 100.0
pub const k_e: Int = 4

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: String, v0: List(Int), v1: Float) -> String {
constructor
}

fn f1(length: Int, delete: Bool, l: List(Int)) -> Bool {
False
}

pub fn main() {
  echo f0("bc", [5], {
    fn(v2, v3) { 10.0 }(0, "b")
  } +. k_pi)
  echo "a"
  echo {
    "a" <> {
      "x" <> "res"
    }
  } <> {
    {
      let k_e = 10 - k_e
      "res" <> "res"
    }
  }
}
