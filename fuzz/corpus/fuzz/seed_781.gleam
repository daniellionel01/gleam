pub const k_limit: String = ""
pub const k_pi: Bool = False
pub const k_seed: Float = 100.0

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

fn f0(v3: Bool, v4: List(Int), v5: Float) -> Int {
{
    case #([2, 5], False) {
      #([v3], True) as whole -> 3
      #([], False) | #([], True) -> 100
      v6 -> walk([2], 7)
    }
  } + {
    case "res" <> "abc" {
      a | "x" <> a -> 10
      _ -> 7 + 5
    }
  }
}

pub fn main() {
  let rest = case "abc" {
    "x" | "ab" -> True
    "data" -> False
    v7 -> {
      10.0
    } == k_seed
  }
  echo case k_limit <> k_limit, fn(v8) { Cv1 }("bc") {
    "data", Cv1 -> {
      let n = k_seed +. {
        0.5
      }
      let rest = 42 - 42
      n +. {
        0.0
      }
    }
    "bc", Cv2 -> {
      let rest = {
        let x = 2.0
        "x"
      }
      let pair = "" <> "data"
      0.0
    }
    v9, _ -> 100.0
  }
}
