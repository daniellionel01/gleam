pub const k_tag: Float = 0.5
pub const k_pi: Int = 1
pub const k_seed: String = "abc"

pub type V0 {
  Cv1
}

pub type V2 {
  Cv3(value: String, inner: List(Int))
}

pub type Map {
  Cv4(Int, List(Int))
}

fn f0(class: Float, value: Bool, v5: Int) -> List(Int) {
[]
}

fn f1(y: Int, z: Int) -> String {
{
    case Cv1 {
      Cv1 | Cv1 -> "b"
      a -> ""
    }
  } <> {
    fn(v6, v7) { "x" }("constructor", 2)
  }
}

pub fn main() {
  echo k_pi
}
