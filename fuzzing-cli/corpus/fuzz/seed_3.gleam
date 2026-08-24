pub const k_seed: Bool = True
pub const k_tag: Float = 1.5

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(constructor: #(String, Float), delete: String, prototype: Int) -> String {
"res"
}

fn f1(default: Float) -> List(Int) {
[0]
}

pub fn main() {
  let k_seed = 1
  echo case "data" {
    inner | "constructor" <> inner -> case "ab" <> "x" {
      _ | "x" <> _ -> False
      "a" | "bc" -> !True
    }
    "constructor" <> constructor -> case fn(v0) { constructor }(True) {
      constructor -> True
      item -> False
      "data" <> _ -> False
    }
    "ab" -> True
  }
  echo case {
      let value = False
      let s = 1
      "abc"
    }, False {
    "res", _ -> {
      fn(v1) { 0 }(True)
    } - {
      0 + k_seed
    }
    "constructor" as whole, False if whole == "constructor" && whole == "abc" -> case walk([3, 42], 4) {
      8 | 9 -> 0
      7 -> k_seed + k_seed
      item -> fn(v2) { 42 }(False)
    }
    "data", _ -> fn(v3) { k_seed - k_seed }("a")
    _, _ -> k_seed
  }
  echo case k_tag {
    0.5 -> case f0(#("", 2.0), "bc", 5), {
        let length = 1
        ""
      } {
      acc, v -> {
        let z = acc
        0
      }
      "bc" <> _, v -> walk([4, 5], 2)
    }
    inner -> k_seed
  }
  echo k_tag
}
