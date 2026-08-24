pub const k_limit: Bool = True
pub const k_e: String = "res"
pub const k_tag: String = "ab"

fn constructor(constructor: Int, v0: #(Bool, Int), n: String) -> Int {
5
}

pub fn main() {
  let k_tag = {
    5 + 3
  } |> constructor(#(False, 3), {
    let length = k_e
    let length = [10, 100]
    "abc"
  })
  let prototype = case "bc", 100 |> constructor(#(True, 4), fn(v1, v2) { k_e }(3, 10.0)) {
    "a" as whole, _ -> k_e <> "constructor"
    "x" <> _, 1 -> "data" <> "b"
    "res" <> _, 8 as whole -> k_e <> ""
    v3, _ -> k_e
  }
  echo case fn(v4, v5) { [42, 42] }(True, 42), k_tag {
    [], 7 -> False
    [b, ..rest], 2 -> False
    [1], 9 -> k_limit
    _, _ -> {
      !k_limit
    } || {
      {
        let z = k_limit
        let acc = 0.1
        z
      }
    }
  }
  echo k_limit
}
