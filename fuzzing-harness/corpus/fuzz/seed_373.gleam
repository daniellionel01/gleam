pub const k_limit: String = "res"
pub const k_golden: Bool = False
pub const k_e: Bool = False

pub type Map {
  Cv0(value: String, inner: Float)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn class(v1: Int, v2: Map, v3: Int) -> Int {
case v3 {
    7 -> case fn(v4) { v2 }(3.14) {
      Cv0("a", v5) -> {
        let s = [4, 0]
        v3
      }
      Cv0("x", 1.0) | Cv0(_, _) -> v3 + v1
      _ -> 0
    }
    inner -> v3
  }
}

fn f1(v6: Int) -> Float {
10.0
}

fn f2(value: List(Int), v7: Int, class: List(Int)) -> List(Int) {
[]
}

pub fn main() {
  let k_golden = case 2, fn(v8) { "ab" }(2.0) {
    7, "res" -> {
      1.5
    } *. {
      0.0
    }
    1, "bc" <> _ -> f1(4)
    v9, "bc" <> rest -> 100.0
    _, _ -> {
      let default = k_limit
      let arguments = "res"
      3.14
    }
  }
  echo 1.5
  echo []
  echo case [42] |> f2(3, [0]) {
    [constructor, ..rest] if constructor <= 7 -> k_e
    [_, ..rest] -> {
      True && k_e
    } && True
    v10 -> case k_limit <> k_limit {
      b -> 5 < 3
      "b" <> constructor -> {
        let constructor = k_golden
        k_e
      }
      "a" | "" <> _ -> "ab" == k_limit
    }
  }
}
