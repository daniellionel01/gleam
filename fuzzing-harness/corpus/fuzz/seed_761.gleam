pub const k_limit: Bool = False

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(constructor: Float) -> Int {
10
}

fn arguments(item: String, class: String) -> Int {
case 100, 2.0 {
    6, 0.1 -> 3
    _, class -> 7
    0, item -> item |> constructor()
  }
}

fn f2(self_: Float, value: Bool, v0: Float) -> Float {
{
    1.5
  } -. {
    {
      {
        let acc = [7]
        let v0 = acc
        1.5
      }
    } -. {
      fn(v1, v2) { 0.1 }("x", True)
    }
  }
}

pub fn main() {
  let k_limit = {
    let default = k_limit
    {
      let new = True
      let acc = default
      10.0
    }
  }
  echo {
    {
      {
        0.5
      } /. {
        0.5
      }
    } *. f2(k_limit, True, 2.0)
  } <=. {
    case [4, 0] {
      [b, ..rest] -> k_limit /. {
        3.14
      }
      [x, _, ..] -> 0.0
      v3 -> k_limit |> f2(True, 0.5)
    }
  }
}
