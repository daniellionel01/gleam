pub const k_limit: Int = 42
pub const k_pi: Bool = True
pub const k_golden: Bool = True

pub type V0 {
  Cv1(value: List(Int))
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn delete(length: Int) -> Int {
0 - {
    {
      10 + length
    } - 0
  }
}

pub fn main() {
  let k_limit = [0]
  echo case <<"b":utf8, "a":utf8>> {
    <<_:16>> as whole -> True
    _ -> {
      {
        1.0
      } +. {
        0.0
      }
    } >. {
      0.1
    }
  }
  echo case {
      let item = 7
      "a"
    } {
    "a" <> a -> "a"
    "constructor" -> "x"
    v2 -> case 42, 5 > 5 {
      3, _ -> {
        let k_limit = k_golden
        "data"
      }
      5, _ -> "constructor" <> "b"
      6, True -> ""
      _, v3 -> v2 <> v2
    }
  }
}
