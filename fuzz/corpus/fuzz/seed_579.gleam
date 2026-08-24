pub const k_seed: Int = 0
pub const k_e: String = "constructor"
pub const k_limit: String = "data"

pub type Record {
  Record
  Cv0(List(Int), List(Int))
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn extends(v1: Int, new: Int, n: List(Int)) -> String {
case fn(v2) { Cv0([0, 42], []) }(False), "x" {
    _, v3 -> case new {
      1 -> v3
      inner -> "constructor"
      b -> "constructor"
    }
    Record, "abc" <> _ -> {
      "constructor" <> "constructor"
    } <> "res"
    v4, "constructor" -> fn(v5, v6) { "" }(1.5, "constructor")
  }
}

pub fn main() {
  let class = {
    {
      let new = k_limit
      let rest = False
      "bc"
    }
  } <> {
    "b" <> "x"
  }
  echo case spin(k_seed, k_seed), "x" {
    3, _ -> [10, 7]
    1, "ab" as whole -> [100]
    v7, v8 -> fn(v9, v10) { [10] }(True, 1.0)
  }
  echo {
    case Cv0([1, 10], []) {
      inner -> 1.5
      b -> 3.14
      _ -> 1.5
    }
  } -. {
    2.0
  }
  echo case fn(v11) { False }("x") {
    item -> case {
        let k_e = 2.0
        [2]
      } {
      [] -> []
      [_, ..rest] as whole -> [100, 10]
      v12 -> []
    }
    False -> [4, 4]
  }
  echo "data"
}
