pub const k_limit: String = "constructor"
pub const k_seed: Bool = True

pub type V0 {
  Cv1
  Cv2
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn arguments(v3: Int, acc: V0) -> List(Int) {
case fn(v4) { Cv2 }(True) {
    Cv2 -> fn(v5) { {
      let l = 0.25
      let l = 1
      [4]
    } }(3)
    Cv2 -> case [] {
      [3] -> fn(v6) { [3] }(True)
      [9, ..rest] -> fn(v7) { rest }(False)
      [6] -> [10, 5]
      _ -> []
    }
    _ -> case "abc" {
      item -> [42]
      v8 -> [1, 4]
    }
  }
}

pub fn main() {
  echo case "res" <> k_limit {
    b -> {
      {
        1.5
      } -. {
        100.0
      }
    } -. {
      0.25
    }
    "b" | "res" <> _ -> {
      let k_limit = fn(v9, v10) { [] }(42, 0.5)
      let s = "abc"
      {
        let delete = 0.5
        let rest = s
        delete
      }
    }
  }
  echo {
    {
      {
        let k_limit = 1
        let self_ = "data"
        self_
      }
    } <> {
      "b" <> k_limit
    }
  } <> {
    case fn(v11) { True }(100.0) {
      item -> k_limit <> k_limit
      True | True -> fn(v12, v13) { "" }(2, 5)
    }
  }
}
