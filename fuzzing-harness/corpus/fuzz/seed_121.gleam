pub const k_limit: Bool = True
pub const k_tag: String = "abc"
pub const k_pi: Bool = True

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(Int)
}

fn f0(v3: String, default: Float) -> Int {
10
}

fn f1(class: V0) -> Int {
case [100, 0] {
    [1, ..rest] as whole -> {
      {
        let class = whole
        "abc"
      }
    } |> f0(fn(v4) { 1.0 }(False))
    [8] -> f0("constructor", 3.14) - 10
    _ -> 42
  }
}

pub fn main() {
  let length = case {
      let k_pi = 3.14
      let y = "data"
      "abc"
    }, Cv2(42) {
    v5, Cv2(5 as whole) if v5 != "data" -> k_tag
    "res" <> rest, Cv2(_) -> k_tag <> rest
    v6, _ -> k_tag <> k_tag
  }
  let class = 3 > 42
  echo fn(v7) { {
    let k_pi = {
      10.0
    } <=. {
      0.1
    }
    {
      let n = length
      100
    }
  } }(4)
  echo {
    let length = case fn(v8, v9) { Cv1([], 10) }("a", 1.5) {
      Cv1([3], 8) | Cv2(_) -> 0 == 10
      constructor -> class
    }
    let acc = case {
        let class = [10]
        let z = 4
        []
      }, [10, 1] {
      [], [8] -> class
      [4] as whole, [h, ..rest] -> True
      _, _ -> length
    }
    {
      2.0
    } == {
      {
        let y = 3
        let length = [4]
        10.0
      }
    }
  }
  echo {
    7 * {
      1 - 42
    }
  } - {
    {
      let n = False
      7 - 42
    }
  }
  echo {
    case 7 % 6 {
      _ | 0 -> "data"
      item -> "x"
      item -> {
        let z = k_limit
        "data"
      }
    }
  } <> k_tag
}
