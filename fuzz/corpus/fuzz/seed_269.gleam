pub const k_e: Float = 0.0
pub const k_limit: Bool = True

pub type Symbol {
  Cv0(value: String, inner: Float)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v1: List(Int), v2: Symbol, z: List(Int)) -> List(Int) {
fn(v3) { fn(v4) { v1 }(10.0) }(100.0)
}

pub fn main() {
  echo case fn(v5) { Cv0("bc", 0.25) }(2.0) {
    Cv0(v6, item) as whole if item <. 0.1 -> case [42, 42] |> walk(5) {
      constructor -> k_e +. {
        0.5
      }
      9 -> 1.0
      6 -> item +. k_e
    }
    inner -> {
      {
        0.5
      } /. {
        3.14
      }
    } -. {
      0.5
    }
    Cv0("res" as whole, 100.0) -> case whole {
      b -> {
        1.0
      } /. {
        2.0
      }
      "data" <> constructor | "" <> constructor -> 10.0
    }
  }
}
