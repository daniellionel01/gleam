pub const k_seed: Float = 3.14
pub const k_e: Bool = False
pub const k_tag: Bool = True

fn constructor(constructor: Bool, rest: Bool, value: Int) -> Float {
{
    {
      {
        0.1
      } +. {
        10.0
      }
    } -. {
      1.5
    }
  } -. {
    2.0
  }
}

fn f1(value: Int, v0: Int, v1: String) -> Float {
{
    case #(100, "b") {
      constructor -> False
      #(4, "ab" <> _) -> fn(v2, v3) { v3 }("data", False)
      #(8, "a" <> _) | #(0, "res") -> fn(v4, v5) { True }(0.1, "constructor")
    }
  } |> constructor(!True, {
    let value = True
    let y = 0.1
    v0
  })
}

pub fn main() {
  let item = [1]
  let k_e = item
  echo "res"
  echo case 0, 1 {
    9, item -> case "ab" <> "abc" {
      "x" | "a" -> {
        let new = k_tag
        let this_ = 2.0
        new
      }
      "b" <> rest | "a" <> rest -> k_tag
      "res" -> !False
      v6 -> k_tag
    }
    2, _ -> k_tag
    0, 8 -> case {
        let this_ = 0.1
        let n = [7, 2]
        "x"
      } {
      item -> fn(v7, v8) { k_tag }(0.1, 100.0)
      "data" -> k_tag
      item -> False
    }
    _, v9 -> False
  }
  echo {
    {
      1.5
    } *. {
      fn(v10, v11) { 1.0 }(100, 10)
    }
  } -. {
    {
      {
        let length = k_seed
        let k_seed = item
        100
      }
    } |> f1(2, {
      let pair = "ab"
      pair
    })
  }
}
