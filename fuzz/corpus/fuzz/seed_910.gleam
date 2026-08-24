pub const k_golden: Bool = True
pub const k_e: String = "abc"
pub const k_pi: Bool = True

pub type V0 {
  Number(value: String, inner: String)
}

pub type Promise {
  Cv1(value: List(Int), inner: String)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v2: Int, z: V0) -> Float {
3.14
}

fn f1(m: String) -> Int {
0
}

fn class(v3: Int) -> Float {
{
    0.25
  } *. {
    100.0
  }
}

pub fn main() {
  echo 3
}
