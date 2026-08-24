pub const k_pi: Int = 0
pub const k_tag: Bool = False
pub const k_golden: String = "a"

pub type Record {
  Cv0(value: String, inner: String)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(prototype: Int) -> String {
{
    case <<"a":utf8>> {
      <<"constructor":utf8>> -> "x"
      _ -> "ab"
    }
  } <> {
    "ab" <> {
      fn(v1, v2) { v2 }(10.0, "")
    }
  }
}

fn default(default: List(Int), new: Int) -> String {
"data"
}

pub fn main() {
  let k_pi = 42
  let new = case "x" {
    "ab" | "" <> _ -> []
    "bc" <> constructor -> {
      let length = [10, 7]
      let k_pi = k_tag
      length
    }
    _ -> [10, 5]
  }
  echo case k_golden {
    "data" -> {
      fn(v3, v4) { 42 }(1.5, "a")
    } - k_pi
    _ | "ab" -> 2
  }
}
