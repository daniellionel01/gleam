pub const k_seed: Float = 2.0
pub const k_golden: Bool = True
pub const k_e: Float = 3.14

pub type Record {
  Cv0(value: String, inner: Float)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn arguments(prototype: String) -> Bool {
{
    let default = {
      {
        10.0
      } -. {
        2.0
      }
    } +. {
      {
        let prototype = "b"
        0.25
      }
    }
    let this_ = [10, 3] |> walk(5 % 4)
    True
  }
}

pub fn main() {
  let k_golden = case fn(v1) { "abc" }("res") {
    constructor -> [1, 42]
    "bc" | "a" -> {
      let s = k_golden
      let pair = "data"
      [3, 7]
    }
  }
  let l = {
    let k_e = {
      let y = 7
      let new = k_seed
      "abc"
    }
    let k_seed = k_seed
    k_e <> k_e
  }
  echo 7
}
