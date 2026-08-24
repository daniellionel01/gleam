pub const k_e: Float = 1.5
pub const k_limit: Bool = True
pub const k_seed: Float = 0.1

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: List(Int), v0: Int, v1: Bool) -> String {
"x" <> {
    case v0 * v0, v0 + 100 {
      _, _ -> "x" <> "res"
      1 as whole, 3 -> fn(v2) { v2 }("abc")
    }
  }
}

fn f1(default: Bool) -> Int {
fn(v3) { {
    4 + 3
  } + {
    fn(v4) { 1 }("a")
  } }(0.25)
}

pub fn main() {
  echo case {
      1.0
    } +. k_seed {
    a -> case "" {
      "abc" <> rest -> fn(v5, v6) { 2 }("", False)
      "bc" <> rest | "data" <> rest -> True |> f1()
      v7 -> 100
    }
    a -> {
      {
        let z = a
        let pair = [2]
        1
      }
    } - spin(7, 5)
  }
  echo {
    {
      "abc" <> "data"
    } <> {
      "data" <> "a"
    }
  } <> f0([7, 1], {
    let m = 0
    3
  }, {
    let z = []
    let value = z
    k_limit
  })
  echo case "", k_e -. {
      3.14
    } {
    "bc" <> rest, 100.0 -> case {
        3.14
      } -. k_seed {
      _ -> {
        let rest = k_limit
        let l = k_limit
        [7, 4]
      }
      v8 -> [4]
    }
    k_e, _ -> case {
        let m = [4]
        let x = 1
        5
      } {
      k_e -> [2, 1]
      0 -> [7]
      a -> []
    }
  }
  echo case "data", k_e {
    "res" <> rest, _ -> [7]
    "" <> rest, k_seed if k_seed <=. 2.0 || rest != "x" -> [7, 2]
    _, 0.1 -> case [2, 0], {
        let k_limit = 5
        let k_seed = True
        []
      } {
      [3] as whole, [x, 4, ..] -> []
      [], [_] -> fn(v9) { [3] }(4)
      [k_limit], [8, ..rest] -> [3, 2]
      _, _ -> [0]
    }
    _, v10 -> case <<"a":utf8>>, fn(v11, v12) { v11 }(True, "ab") {
      <<"abc":utf8>>, False -> []
      _, True -> [4]
      v13, v14 -> fn(v15) { [1] }(3)
    }
  }
}
