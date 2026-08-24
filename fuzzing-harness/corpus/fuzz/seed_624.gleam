pub const k_limit: Int = 4
pub const k_pi: Bool = True

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(constructor: Bool, v0: List(Int), v1: Bool) -> Float {
0.0
}

fn class(rest: Bool, value: String, v2: String) -> List(Int) {
case {
      0.0
    } == {
      100.0
    } {
    _ -> []
    True -> case [] |> walk(fn(v3, v4) { 100 }(0.0, 4)), {
        let item = [1, 7]
        value
      } {
      _, _ -> [42]
      5, "x" <> rest if rest != "constructor" -> []
      _, "abc" -> [0, 100]
    }
    item -> [42, 3]
  }
}

pub fn main() {
  echo {
    {
      {
        2.0
      } -. {
        10.0
      }
    } +. f0(k_pi, [], False)
  } -. {
    case k_pi {
      False -> {
        3.14
      } +. {
        0.1
      }
      False | True -> {
        10.0
      } +. {
        2.0
      }
      a -> f0(False, [3, 4], k_pi)
    }
  }
  echo case "bc", #(2, True) {
    "res", #(_, False as whole) -> whole
    "x", #(v5, False) as whole if v5 <= 7 -> {
      let value = fn(v6, v7) { True }(0, True)
      k_pi
    }
    "a", #(_, False) -> {
      [2] |> walk(k_limit * k_limit)
    } > k_limit
    v8, v9 -> True
  }
  echo [1, 0]
  echo {
    "x" != {
      "res" <> "res"
    }
  } && {
    case class(True, "a", "data"), k_limit - 0 {
      [_, ..rest], _ -> "abc" != "a"
      [2, h, ..], v10 -> "data" == "b"
      v11, v12 -> {
        let delete = k_pi
        let class = v12
        True
      }
    }
  }
}
