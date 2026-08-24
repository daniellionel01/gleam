pub const k_seed: Bool = True
pub const k_e: Bool = True
pub const k_tag: Float = 100.0

pub type V0 {
  Ok(value: String, inner: Bool)
  Cv1
  None
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn yield(arguments: Int, this_: Int) -> Bool {
True
}

pub fn main() {
  let z = case {
      let length = k_tag
      let k_tag = "constructor"
      "x"
    } {
    "b" -> [2]
    item | "a" <> item -> [10]
    b | "a" <> b -> {
      let class = k_e
      [1]
    }
  }
  let k_seed = "data"
  echo z
  echo spin(0, {
    fn(v2, v3) { v2 }(1, True)
  } + {
    5 |> spin(fn(v4) { 4 }(100.0))
  })
  echo case Ok("constructor", False) {
    Ok(_, a) if a && a -> case 3 + 42, 5 {
      _, _ -> k_tag
      4 as whole, v5 if v5 > 5 -> {
        100.0
      } -. k_tag
      3, k_tag -> 0.5
    }
    Ok("a", False) -> case #(False, [1, 42]) {
      #(False as whole, []) if whole -> {
        0.1
      } +. {
        100.0
      }
      #(True, [3, x, ..]) -> k_tag /. {
        10.0
      }
      #(False, [b]) -> k_tag
      v6 -> k_tag
    }
    Ok("abc", v7) as whole -> {
      {
        1.5
      } /. {
        2.0
      }
    } -. {
      fn(v8, v9) { 1.0 }(1, 10.0)
    }
    v10 -> {
      let v10 = {
        let k_e = "res"
        [100]
      }
      fn(v11, v12) { k_tag }(5, 0)
    }
  }
}
