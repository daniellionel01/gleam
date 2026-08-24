pub const k_golden: Int = 10
pub const k_pi: Float = 100.0
pub const k_limit: Int = 100

pub type V0 {
  Some(value: String, inner: Float)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v1: Int) -> String {
"data" <> {
    case True, {
        let v = 3.14
        let rest = False
        "constructor"
      } {
      False, "constructor" <> _ -> "" <> "a"
      _, "data" -> "b"
      _, "a" <> rest -> rest
      _, v2 -> v2
    }
  }
}

pub fn main() {
  let k_golden = case walk([], k_golden) {
    b -> "b"
    b -> "ab" <> "res"
  }
  let v = case [5], Some("constructor", 100.0) {
    [x], Some("data", 2.0) -> True
    [constructor, ..rest], Some("res", 0.0 as whole) -> True
    [h, 9, ..], Some(_, 100.0) -> True
    _, _ -> True
  }
  echo case [1] {
    [] -> {
      k_pi *. {
        0.0
      }
    } +. {
      fn(v3, v4) { k_pi }(1.0, "")
    }
    [] -> fn(v5) { fn(v6, v7) { k_pi }("constructor", True) }("res")
    [1, 0, ..] as whole -> {
      k_pi -. k_pi
    } +. k_pi
    _ -> case {
        let k_golden = v
        1.5
      } {
      2.0 as whole -> {
        let self_ = k_pi
        self_
      }
      _ -> {
        let rest = "data"
        1.0
      }
    }
  }
  echo []
}
