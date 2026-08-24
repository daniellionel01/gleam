pub const k_e: Float = 0.0

pub type V0 {
  Record(value: String, inner: String)
}

fn f0(m: Int, s: Float) -> Int {
case Record("", "a") {
    Record("data" <> rest, "constructor") as whole -> m
    Record("data" <> _, v1) -> case "ab" {
      s | "b" <> s -> m
      "bc" -> 1
      "b" -> 5
    }
    _ | Record(_, _) -> {
      m + m
    } + {
      {
        let delete = 10
        m
      }
    }
  }
}

pub fn main() {
  let k_e = True
  let k_e = 0.0
  echo case "constructor" <> "bc" {
    "bc" -> []
    "res" | "b" -> [42]
    _ -> case {
        let delete = []
        let n = k_e
        #("res", 2.0)
      } {
      #("ab", v2) -> fn(v3) { [] }(True)
      #("a" <> rest, 0.5) -> [2, 100]
      _ -> {
        let k_e = False
        [10]
      }
    }
  }
}
