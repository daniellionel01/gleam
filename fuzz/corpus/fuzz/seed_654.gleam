pub const k_golden: Float = 1.0
pub const k_tag: Int = 42
pub const k_limit: Float = 1.5

pub type V0 {
  Cv1
}

pub type V2 {
  Cv3(Bool)
}

fn default(self_: List(Int)) -> Int {
10 - {
    case {
        let rest = 0.25
        let class = rest
        Cv1
      } {
      _ -> {
        let delete = self_
        let v = 1.0
        42
      }
      Cv1 | Cv1 -> 4 % 6
    }
  }
}

fn f1(new: #(String, Int), v4: Bool) -> Bool {
case 4 {
    5 -> case "x" {
      "ab" as whole if whole != "a" -> False
      b -> fn(v5) { v4 }(42)
    }
    6 -> case "data", Cv3(False) {
      "abc", Cv3(v6) -> {
        let s = [5]
        v4
      }
      "bc" as whole, Cv3(False) -> False
      _, _ -> "b" == "abc"
    }
    4 | 9 -> {
      let new = "ab"
      v4
    }
    _ -> {
      {
        let new = []
        "a"
      }
    } != {
      {
        let new = 2.0
        let class = [10]
        "ab"
      }
    }
  }
}

pub fn main() {
  let k_golden = True
  let constructor = case k_golden || True, {
      let default = k_golden
      let n = ""
      Cv3(True)
    } {
    _, delete -> k_limit
    m, Cv3(False) -> k_limit +. k_limit
  }
  echo case {
      let n = [42, 42]
      let constructor = 100
      n
    } {
    [] as whole -> "constructor"
    [x, 0, ..] as whole -> case Cv3(True) {
      a -> "ab"
      Cv3(True) -> "data" <> "bc"
    }
    _ -> "data"
  }
  echo {
    constructor *. constructor
  } *. {
    1.0
  }
  echo {
    {
      k_tag - 7
    } + k_tag
  } + {
    case k_tag, Cv3(False) {
      0, Cv3(_) -> k_tag - 7
      prototype, Cv3(False as whole) -> prototype + prototype
      8, v7 -> [] |> default()
      _, _ -> 42
    }
  }
  echo case k_tag {
    v8 -> {
      let l = 2
      let constructor = default([100])
      [100, 4]
    }
    constructor -> case "a" <> "res" {
      "ab" <> rest | "bc" <> rest -> [5]
      "" <> rest if rest == "constructor" -> [3]
      "abc" -> [0]
      _ -> {
        let new = k_tag
        let y = "ab"
        [3, 10]
      }
    }
  }
}
