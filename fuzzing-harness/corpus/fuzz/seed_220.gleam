pub const k_pi: Int = 5
pub const k_tag: String = "b"
pub const k_golden: String = "abc"

fn default(constructor: String, v0: Int, v1: Int) -> String {
"abc"
}

fn export(v2: Int) -> List(Int) {
case True, [3] {
    _, [5, ..rest] -> [4]
    True, [_, ..rest] -> {
      let prototype = "" |> default(10 + v2, v2)
      let v2 = "data"
      [5]
    }
    False, [9, ..rest] -> rest
    _, v3 -> v3
  }
}

pub fn main() {
  echo {
    0.1
  } *. {
    2.0
  }
  echo case k_golden <> k_golden {
    "a" <> rest | "data" <> rest -> k_pi + k_pi
    b -> 2 + {
      2 + k_pi
    }
    "res" | "constructor" -> k_pi
  }
}
