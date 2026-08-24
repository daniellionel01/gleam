pub const k_e: Float = 10.0
pub const k_tag: Int = 100

pub type Promise {
  Cv0(value: String, inner: String)
  Cv1
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(rest: Int) -> Bool {
case [0, 100], True {
    [_, 9, ..], s -> True
    [4] as whole, True -> True
    [rest], True as whole -> whole
    v2, _ -> {
      rest * 3
    } >= walk([], 1)
  }
}

pub fn main() {
  let l = {
    fn(v3, v4) { 7 }(100, 0.0)
  } * {
    k_tag + k_tag
  }
  echo False
  echo "res" == {
    case {
        let self_ = k_e
        let arguments = False
        ""
      } {
      _ | "abc" -> "ab" <> "bc"
      "" <> rest -> "res"
      inner -> "constructor" <> "abc"
    }
  }
  echo case Cv1 {
    item -> case 42 {
      inner -> []
      inner -> {
        let delete = []
        [4, 2]
      }
    }
    Cv0("data", _) as whole -> {
      let constructor = 3 + 5
      [7, 3]
    }
    Cv1 -> [4]
  }
}
