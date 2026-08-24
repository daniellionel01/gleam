pub const k_e: Int = 1
pub const k_tag: Bool = False

pub type Promise {
  Cv0(value: String, inner: Float)
}

fn f0(pair: Float, item: Int) -> Bool {
{
    case pair +. {
        0.0
      } {
      b -> b
      item -> item
    }
  } == pair
}

pub fn main() {
  let k_e = case fn(v1, v2) { "a" }("bc", 100) {
    "abc" | "b" <> _ -> True
    v3 -> True
    "constructor" <> _ -> f0(0.0, k_e)
  }
  echo 0.5
  echo {
    1 % 7
  } - 3
  echo 42 * {
    7 % 7
  }
}
