pub const k_e: String = "a"
pub const k_limit: String = "ab"
pub const k_seed: Float = 10.0

fn f0(m: String, rest: List(Int)) -> String {
case 3 {
    _ -> m
    3 | 7 -> fn(v0) { m }("a")
  }
}

fn f1(item: String, m: String, v1: String) -> Bool {
True
}

pub fn main() {
  let k_e = k_limit
  let n = case k_e {
    constructor | "b" <> constructor -> f1("x", "x", k_e)
    "x" <> a -> f1(k_limit, k_limit, k_e)
  }
  echo case [0] {
    [] -> case k_seed {
      k_e -> {
        let k_e = [2, 3]
        let delete = False
        k_e
      }
      0.0 -> [100]
      _ -> [2]
    }
    [2] as whole -> case 3 % 2, 42 {
      7, _ -> whole
      2 as whole, 8 -> fn(v2, v3) { [42, 5] }("b", True)
      _, v4 -> {
        let item = v4
        let self_ = k_seed
        whole
      }
    }
    [] -> []
    _ -> [2, 2]
  }
  echo fn(v5) { [7, 1] }(0.0)
  echo k_seed
  echo n
}
