pub const k_seed: Int = 2
pub const k_pi: Bool = False
pub const k_e: Bool = False

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(self_: Int) -> Float {
{
    fn(v0, v1) { fn(v2) { v2 }(3.14) }(1, 0.1)
  } *. {
    {
      {
        10.0
      } /. {
        0.5
      }
    } /. {
      0.5
    }
  }
}

fn f1(value: Float) -> Bool {
True
}

pub fn main() {
  let value = 0.1
  let k_pi = case 10 + 5 {
    constructor -> False
    inner -> f1(0.1)
  }
  echo {
    0.1
  } /. {
    10.0
  }
  echo [42]
  echo case "bc" <> "ab", 3 {
    k_pi, 9 if k_pi != "" -> case False {
      b -> [5]
      item -> {
        let item = "a"
        []
      }
      True -> [2, 5]
    }
    "res", 1 -> []
    "ab" as whole, 5 -> [0, 4]
    _, v3 -> []
  }
  echo [100]
}
