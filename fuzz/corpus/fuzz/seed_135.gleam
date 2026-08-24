pub const k_pi: Float = 3.14
pub const k_tag: Int = 7
pub const k_limit: String = "res"

pub type V0 {
  Cv1(value: List(Int), inner: Int)
}

fn static(z: Int, v2: V0) -> List(Int) {
[]
}

pub fn main() {
  let value = {
    let default = fn(v3) { [42] }(True)
    let l = k_tag
    "constructor" <> k_limit
  }
  echo case False {
    True -> {
      {
        let v = k_tag
        True
      }
    } || {
      fn(v4) { v4 }(False)
    }
    _ -> {
      k_pi +. {
        1.5
      }
    } <=. {
      3.14
    }
    constructor -> {
      let prototype = static(k_tag, Cv1([7], 100))
      0 < k_tag
    }
  }
  echo {
    {
      3.14
    } *. {
      2.0
    }
  } >. {
    case #("bc", True), {
        let z = k_pi
        let new = k_tag
        1.0
      } {
      #(_, _), 2.0 as whole -> whole *. whole
      #("res" <> _ as whole, False), k_limit if k_limit >=. 3.14 -> {
        let item = value
        1.5
      }
      #("b", k_pi) as whole, _ -> 0.0
      _, v5 -> k_pi
    }
  }
  echo k_tag + {
    2 * {
      0 - k_tag
    }
  }
  echo {
    case 100 + k_tag {
      8 | 3 -> 42
      item -> 3
      _ -> 2 % 2
    }
  } |> static(Cv1([], 10))
}
