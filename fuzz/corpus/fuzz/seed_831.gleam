pub const k_e: String = "abc"
pub const k_pi: Int = 1

pub type Number {
  Record
  Cv0
}

pub type V1 {
  Cv2
  Cv3
  Cv4
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(l: Int) -> Bool {
True
}

pub fn main() {
  let prototype = k_e
  echo {
    let prototype = {
      prototype <> prototype
    } <> k_e
    "abc"
  }
  echo f0(k_pi)
  echo []
  echo True
}
