pub const k_tag: String = "ab"
pub const k_golden: String = ""
pub const k_seed: Float = 0.5

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(constructor: Float, acc: Float, v0: String) -> Float {
{
    {
      1.5
    } +. {
      2.0
    }
  } *. {
    case walk([], 5), #(True, 2.0) {
      6, #(_, 10.0) -> constructor
      8, #(True, 0.0) -> 0.5
      5, #(True, _) -> constructor
      _, _ -> fn(v1, v2) { constructor }(True, 0.25)
    }
  }
}

fn yield(pair: #(Bool, Float), v3: Int) -> Bool {
{
    case <<4:8>> {
      <<_:utf8, 5:16, "data":utf8>> -> 7 * v3
      _ -> 7
    }
  } < 3
}

fn f2(v4: Bool) -> List(Int) {
[]
}

pub fn main() {
  echo True
  echo case {
      let default = k_golden
      let n = k_seed
      "bc"
    }, k_golden <> k_tag {
    "x", "res" <> rest -> f2(True)
    "constructor", arguments -> case f2(True) {
      [] -> fn(v5) { [] }("res")
      [3] as whole -> whole
      [_] -> [5, 1]
      v6 -> v6
    }
    "res", "bc" as whole -> case {
        let whole = k_tag
        let prototype = 3
        whole
      } {
      "ab" <> rest | "bc" <> rest -> fn(v7) { [] }("abc")
      "data" <> rest -> [3, 4]
      v8 -> f2(False)
    }
    v9, _ -> []
  }
}
