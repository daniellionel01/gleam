pub const k_limit: String = "constructor"
pub const k_pi: Bool = False

pub type Record {
  Record
  Cv0(List(Int))
}

fn f0(z: Bool, value: Bool, v1: String) -> Int {
10
}

fn f1(y: Float, v2: Int) -> String {
{
    let pair = case <<"bc":utf8, "b":utf8>> {
      <<1:16, _:utf8>> as whole -> fn(v3, v4) { [5] }(3, True)
      <<_:utf8>> as whole -> {
        let n = 1.5
        let this_ = 0.1
        [100]
      }
      <<_:utf8>> -> []
      v5 -> []
    }
    let length = 0.25
    case Cv0([4, 42]) {
      inner -> "a" <> "constructor"
      constructor -> {
        let x = ""
        let y = 0.25
        x
      }
      Record | Record -> "a"
    }
  }
}

fn arguments(default: String, prototype: Int, v6: Int) -> Float {
{
    {
      1.5
    } -. {
      100.0
    }
  } +. {
    {
      {
        100.0
      } *. {
        0.1
      }
    } +. {
      fn(v7) { 2.0 }(True)
    }
  }
}

pub fn main() {
  let v = case Cv0([2]) {
    Cv0([5, ..rest]) -> 10 + 2
    constructor -> 2 - 100
    Cv0([k_pi, h, ..]) -> f0(False, False, "res")
  }
  let v = arguments("bc", fn(v8) { 5 }(2.0), fn(v9) { v }(False))
  echo {
    0 * f0(k_pi, False, k_limit)
  } + {
    case fn(v10, v11) { Record }("data", 2.0) {
      Record as whole -> f0(False, k_pi, "a")
      Record | Cv0(_) -> fn(v12, v13) { 1 }(100.0, 0.5)
      Cv0([]) -> True |> f0(k_pi, "bc")
      _ -> 5 % 1
    }
  }
  echo {
    let default = f0(False, k_pi, k_limit <> "ab")
    let v = {
      fn(v14) { default }("b")
    } + 1
    {
      k_limit <> k_limit
    } <> {
      "" <> k_limit
    }
  }
  echo []
}
