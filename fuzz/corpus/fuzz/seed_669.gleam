pub const k_golden: Float = 3.14
pub const k_e: Int = 0

fn arguments(constructor: List(Int), y: #(Bool, Int), v0: #(Bool, Int)) -> Bool {
3 != {
    case {
        let y = 7
        let default = []
        default
      }, "x" {
      [0], rest if rest == "b" || rest == "" -> 2 + 100
      [_], "res" -> 2
      v1, _ -> {
        let acc = 2
        let z = 10
        z
      }
    }
  }
}

fn constructor(v2: Int, v3: Float, value: Float) -> List(Int) {
case [3] {
    [] -> case <<0:8, "abc":utf8>> {
      <<"res":utf8>> as whole -> {
        let v3 = "abc"
        let prototype = 100.0
        [7]
      }
      <<_:utf8>> -> []
      _ -> [1, 7]
    }
    [2] -> case 1, <<"abc":utf8, 2:8, "abc":utf8>> {
      _, <<_:utf8, "b":utf8>> -> [3, 10]
      v4, _ -> [100, 1]
    }
    v5 -> case "data", "" {
      "bc", "a" -> fn(v6, v7) { [5] }(0, False)
      _, "a" <> rest -> {
        let value = []
        let this_ = v2
        v5
      }
      v8, v9 -> [42]
    }
  }
}

pub fn main() {
  let k_e = "data"
  let k_e = case "x" <> k_e, fn(v10) { #("x", [0]) }(0.5) {
    l, #(prototype, [constructor, 1, ..]) if l == "data" && prototype == "b" -> 4 + constructor
    "constructor", #(_, [_]) -> 100
    _, _ -> {
      let k_e = k_e
      let value = k_golden
      10
    }
  }
  echo fn(v11, v12) { [] }(1, 4)
  echo arguments([7], {
    let m = {
      1.0
    } /. {
      0.5
    }
    let length = "abc"
    #(False, 3)
  }, case {
      let new = [1]
      "x"
    }, "constructor" {
    "abc", "b" <> rest if rest == "abc" -> #(True, 100)
    "bc" <> rest, "x" -> #(True, 0)
    "res", "ab" <> rest -> #(True, 100)
    _, _ -> {
      let v = 2
      #(False, 100)
    }
  })
  echo fn(v13, v14) { case fn(v15) { v14 }("") {
    True as whole if !whole -> 7 - k_e
    v14 -> 5
  } }("", False)
}
