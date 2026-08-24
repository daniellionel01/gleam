pub const k_limit: String = "constructor"
pub const k_golden: Int = 7

pub type V0 {
  Cv1(value: List(Int))
  Cv2(Bool, String)
  Cv3(value: Float)
}

pub type V4 {
  Cv5
  None
  Cv6(value: Int)
}

pub type V7 {
  Error(Bool, value: String)
  Cv8
  Cv9(String)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v10: Float, v11: List(Int), constructor: Int) -> List(Int) {
fn(v12, v13) { [4, 5] }("bc", False)
}

fn f1(constructor: List(Int)) -> Bool {
case 1 {
    _ -> False
    5 | 0 -> case Error(True, "ab"), 4 |> spin({
        let m = 10
        let constructor = constructor
        10
      }) {
      Cv9(_) as whole, _ -> 7 != 5
      Cv9("constructor" <> _) as whole, 8 -> 5 >= 7
      _, _ -> !True
    }
    _ | 4 -> True
  }
}

pub fn main() {
  let new = 0.25
  let length = fn(v14, v15) { new +. new }(True, 5)
  echo {
    0 - {
      0 - k_golden
    }
  } |> spin(5)
  echo k_limit
  echo {
    fn(v16, v17) { "" <> "res" }(7, 7)
  } == {
    case k_limit, "bc" <> k_limit {
      "bc", "data" <> rest -> {
        let this_ = 0.1
        rest
      }
      "bc" <> rest, "b" <> _ -> rest <> "b"
      "ab", "data" -> k_limit <> k_limit
      v18, _ -> k_limit <> v18
    }
  }
  echo {
    {
      k_limit <> k_limit
    } <> "constructor"
  } <> {
    {
      let constructor = k_limit
      let n = 42
      "abc" <> constructor
    }
  }
}
