pub const k_seed: String = "res"
pub const k_limit: Int = 10

pub type V0 {
  Number(value: String, inner: Bool)
  Cv1(value: String)
}

fn arguments(this_: Int, class: Int) -> List(Int) {
[]
}

fn f1(arguments: String, v2: Int, v3: Bool) -> List(Int) {
case "x", Cv1("abc") {
    _, _ -> case v2 < v2 {
      item -> fn(v4) { [5, 7] }("")
      item -> fn(v5, v6) { [3] }(3.14, False)
    }
    "a" <> rest, Number("a" <> tail as whole, _) if rest != "abc" || whole != "constructor" -> []
    "ab" <> rest, Cv1(_) -> []
  }
}

pub fn main() {
  let k_limit = case k_limit < 100, <<"b":utf8>> {
    _, <<100:16, _:16>> -> 100
    True, <<"b":utf8, "res":utf8, _:utf8>> -> k_limit + k_limit
    True, _ -> 3
    _, v7 -> k_limit % 5
  }
  let arguments = [7, 0]
  echo {
    let constructor = [3, 100]
    let length = arguments
    True
  }
  echo case k_limit + 10 {
    _ | 8 -> case 0 - 5 {
      constructor -> {
        let constructor = k_seed
        let prototype = 0
        []
      }
      8 -> k_seed |> f1(fn(v8, v9) { k_limit }(True, 1.5), False)
    }
    b -> f1("" <> "ab", b + k_limit, False)
  }
  echo case k_limit {
    3 | 4 -> case k_limit * k_limit {
      _ | 6 -> 0.1
      3 | 8 -> 0.1
      inner -> 100.0
    }
    6 -> 0.1
    v10 -> case fn(v11) { True }(False) {
      False -> fn(v12) { 2.0 }(42)
      a -> {
        let v10 = 5
        let length = 0.25
        0.5
      }
    }
  }
  echo {
    {
      0.5
    } /. {
      2.0
    }
  } +. {
    case {
        let length = [7]
        Number("b", False)
      } {
      Number("bc", True) -> 3.14
      inner -> {
        let z = k_seed
        let default = z
        1.0
      }
    }
  }
}
