pub const k_limit: Int = 3
pub const k_pi: Bool = False

pub type Promise {
  Cv0(value: String, inner: List(Int))
}

pub type V1 {
  Cv2(String, value: String)
  Cv3(value: Float)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn arguments(arguments: List(Int), l: Float, pair: Promise) -> Bool {
False
}

fn f1(l: List(Int), n: String) -> Int {
{
    fn(v4) { 0 }(100)
  } - {
    l |> walk(3 + 3)
  }
}

pub fn main() {
  let acc = k_pi
  let k_pi = 10.0
  echo [100]
}
