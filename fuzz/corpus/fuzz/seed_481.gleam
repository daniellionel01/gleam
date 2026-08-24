pub const k_pi: Float = 0.1
pub const k_limit: Bool = True
pub const k_golden: Int = 100

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(y: String) -> String {
case y {
    "data" -> "bc"
    inner -> "res" <> y
  }
}

fn extends(v0: Bool, x: Int, v1: Int) -> String {
{
    case True {
      b -> {
        let v0 = 3.14
        ""
      }
      True -> constructor("res")
      False | True -> constructor("x")
    }
  } <> {
    "a" <> "data"
  }
}

pub fn main() {
  let z = k_golden
  let v = case True {
    True -> [42, 42]
    True | True -> [10, 7]
    False -> [3]
  }
  echo "res" <> {
    "constructor" <> {
      k_limit |> extends(0, {
        let z = [5]
        let z = "constructor"
        4
      })
    }
  }
  echo case "res", #("", True) {
    constructor, #("bc" <> rest as whole, _) -> k_pi /. {
      1.0
    }
    "data", #(item, _) -> k_pi
    "constructor", #(_, False) -> case fn(v2) { #(False, True) }(2.0) {
      #(True, False) -> k_pi
      constructor -> k_pi
      #(True, v) -> k_pi
    }
    v3, _ -> {
      let v3 = "data"
      let constructor = k_limit && k_limit
      k_pi
    }
  }
}
