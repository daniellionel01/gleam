pub const k_limit: Float = 1.5
pub const k_seed: Int = 7
pub const k_golden: Bool = True

pub type V0 {
  Record(value: String, inner: Int)
  Cv1
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn export(z: Int, v2: V0, v3: String) -> Int {
z
}

fn delete(v4: List(Int), item: Int) -> Int {
{
    item - {
      v4 |> walk(7)
    }
  } + item
}

fn f2(pair: String) -> String {
{
    {
      "a" <> pair
    } <> {
      fn(v5, v6) { "data" }(0.0, True)
    }
  } <> {
    fn(v7, v8) { pair <> pair }(1.5, True)
  }
}

pub fn main() {
  let rest = {
    {
      10.0
    } +. {
      0.5
    }
  } +. {
    0.5
  }
  echo {
    let self_ = {
      3.14
    } +. k_limit
    []
  }
  echo case True && False {
    a -> k_seed
    False as whole if !whole -> case fn(v9) { Record("constructor", 4) }("b") {
      Record("constructor", 5) | Cv1 -> 0
      constructor -> 10 - k_seed
    }
    False -> walk([42, 100], 0) * k_seed
  }
  echo case #(10.0, 2.0) {
    #(1.5, 2.0) | #(3.14, 10.0) -> {
      1.5
    } +. {
      0.5
    }
    #(_, new) -> case Cv1 {
      item -> rest +. {
        0.5
      }
      Record("bc", _) -> 2.0
    }
    a -> case "abc" <> "b", fn(v10) { [100, 7] }("x") {
      "constructor" as whole, [] if whole != "a" -> fn(v11) { k_limit }(100.0)
      "x", [] -> 0.25
      v12, _ -> {
        0.0
      } *. {
        10.0
      }
    }
  }
  echo {
    let k_limit = True
    5 < {
      k_seed - 7
    }
  }
}
