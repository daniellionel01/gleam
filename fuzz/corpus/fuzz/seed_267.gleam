pub const k_golden: Bool = True
pub const k_tag: Float = 10.0
pub const k_limit: Bool = False

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Int, v: Int, item: #(String, String)) -> Int {
1
}

fn yield(v0: Int) -> List(Int) {
[3, 5]
}

pub fn main() {
  let self_ = case 0 - 0, "a" != "res" {
    5, True as whole if !whole || whole -> !True
    6, True -> 1 > 0
    _, True as whole -> True
    _, v1 -> k_golden
  }
  let self_ = case "ab" <> "x" {
    "ab" <> _ | "constructor" -> ""
    "data" <> b if b == "res" -> "data"
    "" <> _ -> "bc"
    _ -> {
      let length = 0.25
      "ab"
    }
  }
  echo False
  echo case self_, {
      let pair = []
      False
    } {
    _, _ -> self_
    "abc", l if !l && l -> self_
    k_golden, True -> case 3.14 {
      inner -> "x"
      0.0 | 10.0 -> fn(v2) { "abc" }("ab")
    }
  }
  echo [100, 1]
  echo f0(1, {
    {
      let z = True
      100
    }
  } - 100, {
    let l = fn(v3) { k_limit }(42)
    let acc = f0(100, 42, #("a", "b"))
    #("abc", "data")
  })
}
