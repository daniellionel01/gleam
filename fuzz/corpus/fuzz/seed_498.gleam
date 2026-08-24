pub const k_limit: Int = 4
pub const k_golden: String = "a"
pub const k_pi: Float = 100.0

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(prototype: Bool) -> String {
case "res" {
    item -> item
    "x" -> "bc"
    "data" | "abc" <> _ -> "b"
  }
}

fn f1(l: Int) -> List(Int) {
[100]
}

fn arguments(v: Float, s: List(Int), acc: #(Bool, Int)) -> String {
{
    {
      let rest = 4 - 5
      let constructor = "b" != "a"
      {
        let acc = ""
        let l = True
        "bc"
      }
    }
  } <> {
    "abc" <> "b"
  }
}

pub fn main() {
  echo case {
      let k_pi = k_golden
      0
    } {
    a -> k_golden
    b -> k_golden
  }
}
