pub const k_tag: Bool = True
pub const k_pi: Int = 10
pub const k_limit: Bool = True

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(value: Int, inner: String)
  Cv3(value: Bool)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn export(y: Int, v4: Int) -> Int {
walk([0, 4], {
    fn(v5) { v4 }(1.5)
  } * {
    v4 - v4
  })
}

pub fn main() {
  let k_pi = 3.14
  echo [0, 4]
  echo k_tag
  echo {
    0.1
  } != {
    0.25
  }
}
