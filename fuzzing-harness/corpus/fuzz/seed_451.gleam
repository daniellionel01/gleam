pub const k_tag: Bool = True
pub const k_limit: Bool = False
pub const k_e: Int = 3

pub type Map {
  Cv0(value: String, inner: List(Int))
  Ok(value: List(Int), inner: Bool)
  Number(Int)
}

pub type V1 {
  Cv2(value: Bool, inner: Int)
}

fn f0(v3: String, v: Float, rest: Int) -> List(Int) {
[0, 10]
}

fn f1(m: String, n: String, v4: List(Int)) -> Float {
{
    case {
        2.0
      } -. {
        3.14
      }, fn(v5) { m }(2.0) {
      v, "constructor" -> 1.0
      1.5, "abc" -> 1.5
      _, "x" as whole -> {
        0.25
      } *. {
        1.5
      }
      _, _ -> {
        0.5
      } +. {
        0.5
      }
    }
  } -. {
    case 0 - 0 {
      b -> 0.25
      inner -> 100.0
      n -> {
        1.5
      } /. {
        10.0
      }
    }
  }
}

fn new(new: Float, v6: Map) -> Int {
10
}

pub fn main() {
  let k_tag = 0.25
  echo case [] {
    [0, ..rest] -> case 1 {
      a -> rest
      5 | 7 -> {
        let k_limit = "abc"
        let k_limit = k_e
        rest
      }
      prototype -> rest
    }
    [h] -> [0, 7]
    _ -> {
      let rest = "b" == "constructor"
      [42]
    }
  }
  echo True
  echo {
    {
      2 - k_e
    } - {
      0 + 42
    }
  } + 100
}
