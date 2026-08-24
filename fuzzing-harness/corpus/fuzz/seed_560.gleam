pub const k_seed: Int = 2
pub const k_pi: String = "abc"
pub const k_golden: Float = 100.0

pub type Map {
  Cv0(value: String, inner: List(Int))
  Record(value: Float, inner: List(Int))
  Cv1
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v2: Bool, v3: List(Int), this_: String) -> Float {
1.0
}

fn f1(v4: Int) -> Float {
{
    {
      3.14
    } +. {
      0.5
    }
  } +. {
    f0(True, [], "bc") *. {
      {
        let v4 = [10]
        let self_ = True
        0.25
      }
    }
  }
}

fn f2(default: #(Float, String), v5: Map) -> String {
"ab"
}

pub fn main() {
  echo fn(v6) { k_seed > walk([42, 0], 42) }(False)
  echo k_pi
  echo {
    case k_pi {
      a -> True
      "res" <> inner -> k_seed >= k_seed
    }
  } && True
  echo f2(case 3 % 2 {
    _ | 4 -> fn(v7, v8) { #(2.0, "b") }(True, 1.5)
    3 -> #(0.25, "constructor")
    inner -> #(1.5, "a")
  }, Cv1)
}
