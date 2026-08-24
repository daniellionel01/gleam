pub const k_limit: String = "bc"
pub const k_golden: Float = 3.14

pub type V0 {
  Cv1(value: List(Int))
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn arguments(l: Int, new: List(Int)) -> Int {
case fn(v2) { True }("b") {
    True -> 3
    a -> 10 + {
      3 - l
    }
  }
}

pub fn main() {
  echo case True || False {
    a -> {
      let n = k_golden
      [5]
    }
    False -> [5, 100]
    constructor -> case True, k_limit <> k_limit {
      _, v3 -> {
        let class = constructor
        [10]
      }
      True, "b" <> rest -> fn(v4, v5) { [] }(0.0, "constructor")
    }
  }
  echo case True, k_limit <> k_limit {
    False, "data" -> case arguments(10, [3]) {
      3 -> "abc"
      _ -> k_limit
    }
    True, "constructor" -> "a" <> {
      k_limit <> k_limit
    }
    v6, "a" -> "x"
    _, _ -> {
      "ab" <> "data"
    } <> ""
  }
  echo {
    case #(3, [10]), "x" {
      #(_, [_, ..rest]), _ -> k_limit <> k_limit
      #(6 as whole, [_] as it), "data" if whole % 2 == 0 -> {
        let length = [7, 2]
        k_limit
      }
      #(9, [x]), _ -> k_limit
      v7, _ -> fn(v8) { "res" }(5)
    }
  } <> {
    fn(v9, v10) { k_limit }(0.5, 1.5)
  }
  echo k_golden
}
