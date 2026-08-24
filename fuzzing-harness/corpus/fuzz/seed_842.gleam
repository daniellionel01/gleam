pub const k_pi: String = "data"
pub const k_golden: Float = 0.1
pub const k_e: Int = 4

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2
  Some(value: Float)
}

pub type Promise {
  Cv3(value: String)
  Cv4(Float, value: String)
}

pub type Symbol {
  Cv5
  Cv6(value: Bool, inner: Int)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(new: Int, v7: Int, m: String) -> Float {
{
    case "data", {
        let rest = v7
        Cv6(True, 100)
      } {
      "data", Cv6(False, v7) if v7 > 0 -> {
        10.0
      } *. {
        0.0
      }
      "abc", Cv5 -> fn(v8) { 100.0 }("b")
      _, Cv5 -> {
        0.0
      } +. {
        1.5
      }
      v9, _ -> 1.5
    }
  } /. {
    10.0
  }
}

fn f1(length: Int) -> List(Int) {
case Cv3("res") {
    Cv4(_, "constructor" <> rest) if rest != "res" -> []
    Cv3("bc" <> rest) -> {
      let length = length
      let rest = length
      []
    }
    _ -> []
  }
}

pub fn main() {
  let m = {
    {
      let k_golden = k_e
      let constructor = False
      [1]
    }
  } |> walk(42)
  let delete = case {
      let k_pi = "res"
      m
    }, 100 + m {
    y, _ -> [3, 3]
    6, v10 -> [42, 5]
    2, _ -> [2, 3]
  }
  echo {
    {
      let this_ = k_golden <. {
        1.5
      }
      fn(v11, v12) { delete }(True, 0.1)
    }
  } |> walk(m + 42)
  echo {
    {
      let k_golden = delete
      walk(delete, 10)
    }
  } >= k_e
  echo {
    case "" <> k_pi, Cv5 {
      "abc", Cv6(True, _) -> f0(k_e, m, "ab")
      "a", _ -> 0.5
      _, Cv6(True, 6) -> k_golden /. {
        2.0
      }
      _, v13 -> f0(k_e, m, k_pi)
    }
  } +. f0(k_e + k_e, walk(delete, k_e), k_pi <> k_pi)
}
