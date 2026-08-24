pub const k_limit: Int = 1
pub const k_e: String = "bc"
pub const k_seed: Int = 100

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(v: String) -> Bool {
fn(v0, v1) { v0 }(True, 1)
}

pub fn main() {
  echo True
  echo []
  echo case fn(v2) { k_e }(42), [4] {
    _, [] -> True
    _, [8, ..rest] as whole -> True
    "x", [] -> case 10.0, {
        let k_limit = 100.0
        let y = k_seed
        1.0
      } {
      k_e, 3.14 as whole -> {
        let s = False
        s
      }
      _, 100.0 -> True
      3.14, _ -> True
      v3, _ -> {
        0.1
      } <. {
        0.0
      }
    }
    v4, _ -> False
  }
  echo [0]
}
