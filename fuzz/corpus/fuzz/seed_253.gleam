pub const k_e: String = "a"
pub const k_limit: Float = 1.0

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Bool, v0: Int, this_: Int) -> String {
""
}

fn f1(v1: Float) -> Bool {
{
    0.1
  } <. v1
}

pub fn main() {
  let k_e = k_e
  let z = case True |> f0(4 - 42, fn(v2) { 5 }(100.0)) {
    item -> item <> "a"
    "b" | "res" -> k_e <> k_e
  }
  echo case {
      let s = 0
      let k_limit = [2]
      True
    }, True {
    False, False as whole if whole -> {
      {
        let k_e = whole
        let this_ = k_limit
        this_
      }
    } /. {
      2.0
    }
    True, True as whole -> {
      fn(v3) { 0.0 }(0)
    } *. k_limit
    v4, True -> {
      {
        1.5
      } /. {
        2.0
      }
    } -. {
      100.0
    }
    v5, v6 -> case 4, 5 * 4 {
      v, 6 as whole -> {
        let prototype = [10, 1]
        let rest = k_limit
        rest
      }
      _, 9 -> k_limit
      _, v7 -> {
        let l = 4
        let prototype = "res"
        0.25
      }
    }
  }
}
