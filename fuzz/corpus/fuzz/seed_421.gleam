pub const k_limit: Int = 1
pub const k_tag: Float = 0.25
pub const k_seed: String = "a"

pub type V0 {
  Cv1(value: List(Int))
  Cv2
  None(Float)
}

pub type V3 {
  Cv4
  Error(value: Int)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v5: String, item: Float) -> List(Int) {
fn(v6, v7) { case v5, [] |> walk([2] |> walk(5)) {
    "constructor", _ -> {
      let prototype = v7
      []
    }
    _, 5 -> [3, 1]
    "bc" <> rest as whole, 3 -> []
    _, _ -> {
      let v5 = 10
      let x = True
      [4]
    }
  } }(2, "data")
}

fn constructor(default: Int, v8: Int, v9: String) -> List(Int) {
[]
}

fn f2(v10: Int, m: List(Int), class: V3) -> Int {
3
}

pub fn main() {
  echo {
    let k_limit = case k_tag >. {
        1.5
      } {
      False as whole -> [4, 100]
      a -> [5]
      b -> [10]
    }
    case Error(3) {
      b -> [5]
      Error(_) -> fn(v11) { [100] }(0.0)
    }
  }
  echo {
    let k_seed = k_limit
    let k_seed = case "res" <> "ab" {
      constructor -> walk([], 100)
      item -> 0 - 0
      _ | "data" -> f2(k_limit, [1, 0], Error(0))
    }
    {
      "data" <> "abc"
    } |> f0({
      0.1
    } *. {
      1.5
    })
  }
  echo case "ab" <> k_seed {
    "data" -> 100 % 2
    item | "a" <> item -> 10
  }
  echo fn(v12, v13) { k_tag }(True, True)
}
