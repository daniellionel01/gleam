pub const k_limit: String = "bc"
pub const k_seed: Int = 5
pub const k_e: Float = 1.5

pub type V0 {
  Cv1(value: List(Int))
  Cv2(List(Int))
  Record
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn new(m: Int) -> Bool {
False
}

fn static(prototype: List(Int), x: V0, item: List(Int)) -> List(Int) {
case 4 {
    inner -> {
      let v = {
        let self_ = item
        "a"
      }
      [100]
    }
    8 as whole -> item
  }
}

pub fn main() {
  echo case fn(v3) { k_limit }(True), static([0, 1], Record, [100, 5]) {
    _, [a, ..rest] if a == 6 -> k_e
    "res" <> rest, [k_e] if k_e == 7 && k_e > 0 -> case <<"a":utf8>>, {
        let s = 0.5
        []
      } {
      <<7:8>>, [b, 4, ..] as whole if b <= 2 -> 0.5
      _, [6, ..rest] -> fn(v4) { 2.0 }(4)
      _, _ -> 0.25
    }
    arguments, [7] -> {
      {
        let arguments = False
        3.14
      }
    } /. {
      3.14
    }
    v5, _ -> {
      {
        let v = "ab"
        k_e
      }
    } -. {
      3.14
    }
  }
  echo k_limit
  echo {
    let self_ = case <<"b":utf8>>, Record {
      <<"":utf8>> as whole, Cv1([a, ..rest]) -> True
      <<"ab":utf8>>, Cv1([]) -> new(k_seed)
      _, Record -> False
      v6, v7 -> {
        let self_ = True
        False
      }
    }
    let default = case new(4) {
      item -> k_e
      False as whole -> k_e +. {
        3.14
      }
    }
    5
  }
  echo []
}
