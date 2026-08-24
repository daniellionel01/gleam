pub const k_e: Float = 2.0
pub const k_seed: Float = 3.14
pub const k_pi: Int = 4

pub type V0 {
  Cv1(value: List(Int))
  Cv2
}

pub type Record {
  Cv3(Int)
  None
  Ok(Int, Float)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn static(l: #(Float, List(Int)), v4: Int, acc: Int) -> List(Int) {
[3]
}

pub fn main() {
  let length = {
    fn(v5) { k_e }("bc")
  } +. {
    {
      10.0
    } *. k_seed
  }
  echo {
    fn(v6) { 3 }(False)
  } - {
    k_pi % 6
  }
}
