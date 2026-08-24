pub const k_seed: Int = 42

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(new: Int) -> Int {
10
}

pub fn main() {
  let value = {
    1 * 5
  } - 100
  echo !{
    case "x", 100 {
      _, _ -> True || True
      "res", _ -> {
        let value = True
        let pair = k_seed
        True
      }
    }
  }
  echo k_seed |> constructor()
  echo case "abc", True {
    _, True -> 0 - {
      {
        let k_seed = [7, 10]
        0
      }
    }
    "" <> _, True -> k_seed
    "constructor", _ -> case "b" <> "a", #(7, "") {
      _, #(8, v0) -> [] |> walk(value)
      "ab" <> rest, #(9, "b") -> k_seed * k_seed
      _, _ -> 1
    }
    v1, _ -> case 10 % 1, fn(v2, v3) { #(2.0, False) }(0.0, 0.0) {
      n, #(2.0, True) as whole if n > 7 && n == 3 -> n
      6, #(2.0, True) -> 5
      4, #(0.0, False as whole) -> 4
      v4, v5 -> value * 42
    }
  }
}
