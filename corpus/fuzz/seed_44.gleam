pub const k_golden: Float = 0.0

pub type Number {
  Record
  Cv0(value: String)
  Cv1(List(Int), value: List(Int))
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn arguments(v2: Int, class: String) -> List(Int) {
[]
}

pub fn main() {
  echo case "" {
    "a" <> _ as whole if whole == "" || whole == "constructor" -> {
      let k_golden = whole
      {
        0.25
      } +. {
        2.0
      }
    }
    "ab" <> inner -> {
      k_golden -. {
        10.0
      }
    } +. {
      0.0
    }
    _ -> case [2, 1] {
      [8, ..rest] -> k_golden
      [] -> 10.0
      _ -> fn(v3) { k_golden }(True)
    }
  }
  echo True
}
