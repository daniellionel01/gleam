pub const k_e: Int = 3
pub const k_seed: String = ""
pub const k_limit: String = "bc"

pub type V0 {
  Number(value: String, inner: List(Int))
  Some
  Error(Int, value: List(Int))
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v1: List(Int), m: String) -> Bool {
{
    let this_ = {
      {
        let v1 = True
        4
      }
    } + {
      0 - 0
    }
    let z = case Number("b", [100]) {
      Some | Error(_, _) -> fn(v2, v3) { v1 }(0.25, 42)
      item -> v1
      Error(4, []) -> [7, 7]
    }
    False
  }
}

fn default(s: Int) -> List(Int) {
case "b", 3.14 {
    "x" <> _ as whole, 1.5 -> [5]
    "ab", _ -> case 10, <<"b":utf8>> {
      _, <<1:8>> -> fn(v4, v5) { [0, 5] }(0.0, 42)
      m, <<100:1>> if m > 4 || m <= 2 -> fn(v6, v7) { [4, 42] }(0.25, True)
      2, <<10:16>> -> {
        let self_ = 0.0
        [100, 3]
      }
      _, v8 -> [4]
    }
    _, _ -> case Number("b", []), "b" {
      Some, _ -> [7]
      Error(8, [0, _, ..]), _ -> [2]
      Error(7, [] as whole), _ -> []
      _, _ -> []
    }
  }
}

fn f2(this_: Float) -> Int {
3 - 5
}

pub fn main() {
  let default = 0.25
  let k_limit = {
    {
      let class = 0.5
      let default = 1.5
      0.1
    }
  } /. {
    0.5
  }
  echo case Error(2, []) {
    Number(b, _) if b != "" -> case k_seed <> k_seed {
      constructor | "b" <> constructor -> []
      inner -> [2, 2]
      "x" | "b" -> {
        let prototype = k_e
        let default = b
        [3]
      }
    }
    Number("a" <> rest, [k_e]) -> []
    v9 -> case True, [] {
      True, [9, ..rest] as whole -> {
        let acc = True
        let class = 3
        whole
      }
      _, [5] -> []
      False, [2] -> []
      _, _ -> {
        let y = [7, 7]
        [3]
      }
    }
  }
  echo 100
  echo "res"
}
