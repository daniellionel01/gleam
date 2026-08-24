pub const k_limit: Int = 100
pub const k_e: Bool = False
pub const k_pi: String = "x"

pub type V0 {
  Ok(value: String, inner: String)
  Cv1(String)
  Some(value: Int, inner: Float)
}

fn f0(length: Bool, new: V0) -> List(Int) {
[]
}

pub fn main() {
  echo {
    case k_pi, fn(v2, v3) { k_pi }(False, True) {
      _, _ -> 10
      v4, "bc" <> _ as whole -> fn(v5) { k_limit }(1.0)
      "res" <> rest, k_limit -> 2 * 4
    }
  } > 4
  echo f0(case {
      let this_ = 4
      "a"
    } {
    constructor -> k_e
    "constructor" -> True
  }, case {
      let value = []
      10.0
    }, k_pi {
    constructor, "data" <> rest as whole if constructor >. 0.25 -> Cv1("bc")
    3.14, "constructor" -> Ok("", "res")
    _, _ -> Cv1("constructor")
  })
  echo case k_pi <> k_pi {
    "bc" <> _ -> case fn(v6, v7) { k_e }("a", False) {
      _ -> "x"
      k_limit -> k_pi <> k_pi
      item -> k_pi
    }
    "ab" <> _ | "res" <> _ -> {
      k_pi <> k_pi
    } <> k_pi
    constructor -> constructor <> "bc"
  }
  echo f0(fn(v8) { False }(3), Cv1("res"))
}
