pub const k_seed: Int = 1
pub const k_limit: String = "data"
pub const k_pi: String = "bc"

pub type Symbol {
  Cv0(value: String, inner: Float)
  Cv1(value: Int, inner: Int)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn delete(v2: Bool) -> List(Int) {
[42, 0]
}

pub fn main() {
  let k_pi = {
    let k_limit = [100, 0]
    True
  }
  let rest = !True
  echo {
    100.0
  } /. {
    1.0
  }
  echo case Cv1(2, 7) {
    k_limit -> [7]
    Cv0(x, 2.0) as whole -> {
      let whole = x
      rest |> delete()
    }
  }
}
