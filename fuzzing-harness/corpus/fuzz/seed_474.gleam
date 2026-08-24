pub const k_golden: Float = 0.25
pub const k_limit: String = "x"
pub const k_e: String = "a"

pub type V0 {
  Cv1
  Cv2
  Cv3(value: List(Int))
}

fn f0(v4: String, v5: List(Int), v6: String) -> Int {
{
    {
      fn(v7) { 2 }("bc")
    } % 3
  } + {
    {
      fn(v8) { v8 }(42)
    } - 7
  }
}

pub fn main() {
  let s = "x"
  let k_e = case fn(v9) { k_limit }(2.0), "x" <> s {
    "abc" <> rest, "a" -> 3
    _, _ -> 42
  }
  echo case fn(v10, v11) { Cv1 }("constructor", ""), s <> "x" {
    Cv3([x]), "bc" -> case 2, 10.0 {
      _, 3.14 -> fn(v12) { 1.0 }(0.25)
      k_e, 10.0 -> k_golden -. {
        0.25
      }
      v13, v14 -> {
        1.0
      } *. {
        1.0
      }
    }
    Cv1, "ab" as whole -> {
      {
        let arguments = True
        k_golden
      }
    } -. {
      {
        1.0
      } +. k_golden
    }
    v15, v16 -> 0.1
  }
  echo {
    let k_golden = f0(s, [4], s) + {
      1 * k_e
    }
    True
  }
  echo {
    k_e - {
      k_e + k_e
    }
  } * k_e
}
