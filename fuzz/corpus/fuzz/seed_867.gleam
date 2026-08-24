pub const k_limit: Float = 2.0
pub const k_seed: Bool = True
pub const k_tag: String = "bc"

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(self_: String) -> Bool {
{
    let length = case 5 {
      self_ -> [1]
      5 -> []
    }
    let acc = 10
    case 5 {
      a -> acc == a
      b -> False
    }
  }
}

fn f1(m: #(String, Float), y: Int) -> String {
case <<"b":utf8, "constructor":utf8>> {
    <<7:8, "abc":utf8>> -> "ab"
    <<0:16>> as whole -> "data"
    _ -> "constructor" <> {
      "data" <> "abc"
    }
  }
}

pub fn main() {
  echo {
    {
      {
        2.0
      } +. k_limit
    } *. {
      k_limit +. {
        2.0
      }
    }
  } /. {
    3.14
  }
}
