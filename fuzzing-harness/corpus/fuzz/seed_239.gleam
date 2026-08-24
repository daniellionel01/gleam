pub const k_tag: Bool = True
pub const k_pi: Float = 2.0
pub const k_limit: Int = 10

pub type V0 {
  Record(value: String, inner: Int)
  Cv1
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn arguments(n: Bool, v2: V0) -> Int {
fn(v3, v4) { 4 }(0.1, "bc")
}

pub fn main() {
  let y = case {
      let pair = k_tag
      let self_ = "a"
      k_tag
    } {
    inner -> [0]
    item -> fn(v5) { [2, 4] }(True)
    item -> fn(v6, v7) { [100, 42] }("a", 4)
  }
  let k_tag = case Cv1, {
      let acc = k_tag
      let self_ = 2.0
      True
    } {
    Cv1, value -> k_limit - 10
    Record("bc", 6) as whole, False -> arguments(k_tag, Cv1)
    _, v8 -> k_limit
  }
  echo {
    let k_limit = {
      k_tag - k_tag
    } >= 10
    {
      let constructor = "x" <> "bc"
      let constructor = []
      k_pi
    }
  }
  echo case {
      let prototype = k_pi
      "res"
    }, "" {
    "constructor", "ab" <> rest as whole if rest != "constructor" -> fn(v9) { [] }("ab")
    _, _ -> [5]
  }
  echo "abc"
}
