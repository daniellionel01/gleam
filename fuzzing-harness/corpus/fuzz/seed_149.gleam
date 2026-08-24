pub const k_golden: Float = 10.0

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(constructor: List(Int), item: Bool, v0: Int) -> Bool {
case "" == "res" {
    False | True -> case {
        let l = 100
        42
      } {
      9 | 0 -> 4 >= 3
      a -> True
      _ | 8 -> fn(v1, v2) { item }(2.0, 5)
    }
    inner -> walk(constructor, v0) == {
      fn(v3, v4) { 5 }("abc", 3)
    }
  }
}

pub fn main() {
  let k_golden = 100.0
  echo case "abc", {
      1.0
    } <. k_golden {
    "abc", False -> case True || True {
      inner -> "res" <> "b"
      b -> "" <> "res"
      _ -> "bc" <> "ab"
    }
    _, _ -> case {
        let k_golden = 5
        []
      } {
      [_] -> "res"
      [] as whole -> "bc" <> "res"
      [k_golden, ..rest] -> fn(v5, v6) { "a" }(3.14, False)
      _ -> {
        let k_golden = False
        "b"
      }
    }
    "data" <> rest, v7 -> case <<2:1, 5:4>>, <<"x":utf8>> {
      <<_:16>>, <<_:utf8>> -> rest
      <<_:big-unsigned-8, _:utf8>> as whole, <<100:1>> -> "ab"
      _, _ -> "a"
    }
  }
}
