pub const k_e: Bool = False

fn extends(constructor: #(Bool, Float), item: String, length: String) -> Int {
4
}

fn f1(v0: Int, v1: Float, item: Int) -> Int {
0
}

fn f2(default: String) -> List(Int) {
[]
}

pub fn main() {
  let k_e = {
    {
      2.0
    } -. {
      2.0
    }
  } -. {
    0.1
  }
  echo case [5, 0], True {
    [_, 3, ..], False -> case extends(#(True, 10.0), "constructor", "res"), [7, 5] {
      7, [constructor] if constructor % 2 == 0 -> {
        let length = constructor
        let y = length
        False
      }
      4, [_, ..rest] -> True
      _, _ -> k_e != k_e
    }
    [4, _, ..], True -> True
    _, v2 -> {
      let k_e = False
      {
        let v2 = "data"
        False
      }
    }
  }
  echo case "abc" {
    "data" <> a -> {
      {
        3.14
      } +. {
        10.0
      }
    } +. {
      fn(v3, v4) { 1.5 }(5, "b")
    }
    "b" -> 100.0
    "b" <> _ -> {
      k_e -. {
        0.0
      }
    } +. {
      {
        1.5
      } +. k_e
    }
    _ -> k_e
  }
  echo case 1 * 4 {
    constructor -> case fn(v5, v6) { constructor }(True, 0.1), 4 - constructor {
      8, this_ -> "x"
      0, 7 -> "b"
      _, v7 -> "data"
    }
    6 -> "ab"
    v8 -> {
      {
        let k_e = 10.0
        let acc = True
        "res"
      }
    } <> {
      "abc" <> "abc"
    }
  }
}
