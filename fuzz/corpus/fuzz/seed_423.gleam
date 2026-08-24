pub const k_tag: Int = 0
pub const k_golden: Float = 0.0

fn constructor(constructor: Int, z: Int, prototype: Bool) -> Int {
case <<1:8>> {
    <<"a":utf8, new:4, _:big-unsigned-8>> if new > 4 || new <= 6 -> 1
    _ -> case "constructor", fn(v0) { "abc" }(False) {
      "x", "res" -> z % 1
      "bc", _ -> constructor - z
      _, _ -> {
        let s = 1.0
        let z = s
        42
      }
    }
  }
}

pub fn main() {
  let k_golden = {
    let default = 0.1
    let z = 10.0
    k_golden
  }
  echo case "x" <> "" {
    "" <> rest | "a" <> rest -> "abc"
    item | "constructor" <> item -> {
      "" <> item
    } <> {
      fn(v1, v2) { item }(7, 1.5)
    }
    "data" | "constructor" <> _ -> {
      "ab" <> ""
    } <> "a"
  }
  echo True
  echo case k_tag - k_tag, fn(v3) { [] }(True) {
    1, [4, constructor, ..] as whole if constructor == 5 -> {
      let prototype = True
      let x = k_golden
      "ab" <> "abc"
    }
    v4, [k_tag] -> "b" <> {
      fn(v5, v6) { "ab" }(True, "b")
    }
    _, [] -> "constructor" <> "b"
    v7, v8 -> "abc" <> {
      {
        let rest = ""
        let l = 2
        "x"
      }
    }
  }
  echo {
    let default = case {
        let v = []
        let arguments = "a"
        "data"
      }, 5 {
      _, 4 as whole if whole % 2 == 0 -> fn(v9, v10) { [10, 0] }(2, "b")
      "abc", 3 -> []
      "bc", 1 -> [2]
      _, _ -> [4, 7]
    }
    let m = k_golden
    case k_tag % 7 {
      v11 -> {
        let s = "res"
        let constructor = default
        "constructor"
      }
      a -> "bc" <> "constructor"
      inner -> fn(v12, v13) { "data" }(100.0, 10.0)
    }
  }
}
