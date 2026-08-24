pub const k_golden: Float = 1.0
pub const k_seed: Int = 10
pub const k_pi: Bool = False

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(List(Int))
  Record(value: String)
}

pub type V3 {
  Number(value: Int)
  Cv4(Int, value: Float)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn arguments(v5: #(Bool, Bool)) -> Float {
case {
      let v5 = True
      "ab"
    } {
    "x" -> {
      100.0
    } -. {
      10.0
    }
    "a" -> {
      3.14
    } /. {
      1.0
    }
    "constructor" -> case [2, 1] {
      [_, ..rest] as whole -> 0.1
      [_] -> 3.14
      _ -> {
        0.1
      } *. {
        1.5
      }
    }
    v6 -> {
      1.5
    } -. {
      1.0
    }
  }
}

fn f1(v7: V3, v8: Float) -> Float {
#(True, True) |> arguments()
}

fn f2(s: List(Int), self_: String, v9: Float) -> String {
case <<"a":utf8, 100:1, "bc":utf8>> {
    <<_:utf8>> -> {
      let v9 = 4 - 0
      {
        let item = "constructor"
        let v = 10
        "abc"
      }
    }
    _ -> {
      let v9 = {
        let delete = v9
        2
      }
      let s = 100
      {
        let v9 = self_
        v9
      }
    }
  }
}

pub fn main() {
  let new = 7
  let s = [2]
  echo {
    k_golden +. k_golden
  } +. {
    {
      let k_golden = s
      {
        10.0
      } +. {
        0.25
      }
    }
  }
  echo case s, walk([5], k_seed) {
    [h, ..rest] as whole, 6 if h <= 0 && h <= 8 -> {
      let m = {
        0.1
      } +. {
        100.0
      }
      s
    }
    [_] as whole, k_pi -> [7]
    _, v10 -> [5]
  }
  echo {
    {
      100.0
    } -. k_golden
  } -. arguments(#(True, False))
}
