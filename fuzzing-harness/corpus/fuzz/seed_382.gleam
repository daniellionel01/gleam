pub const k_pi: String = ""
pub const k_e: Bool = True
pub const k_limit: Float = 1.5

pub type V0 {
  Cv1(value: List(Int))
}

pub type V2 {
  Cv3
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v4: V2) -> Bool {
False
}

pub fn main() {
  let default = {
    k_limit -. k_limit
  } -. {
    {
      let k_pi = 100
      100.0
    }
  }
  let z = "a"
  echo case 42 {
    4 -> 4
    7 as whole -> case <<"":utf8, "b":utf8, "res":utf8>>, "a" {
      <<7:16>> as whole, l -> 4
      _, "ab" -> fn(v5) { 5 }(True)
      _, _ -> 0
    }
    v6 -> 0
  }
}
