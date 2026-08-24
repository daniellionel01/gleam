pub const k_e: Float = 0.0
pub const k_pi: Bool = False

pub type V0 {
  Cv1(value: List(Int), inner: Int)
}

pub type V2 {
  Some(Bool, List(Int))
}

fn f0(v3: Int) -> List(Int) {
[5, 7]
}

pub fn main() {
  echo fn(v4, v5) { 2 }(1.5, 10.0)
  echo k_pi
  echo fn(v6, v7) { case 10 {
    2 -> [0]
    6 -> []
    a -> a |> f0()
  } }("x", "x")
  echo "a"
}
