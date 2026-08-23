pub const k_pi: Bool = False
pub const k_e: Bool = True
pub const k_golden: String = "abc"

pub type V0 {
  Error(value: String, inner: List(Int))
  Cv1
}

fn f0(v2: Bool, v3: Int) -> Bool {
False
}

fn f1(this_: Int) -> Int {
0
}

fn constructor(v4: String) -> Int {
7
}

pub fn main() {
  let y = case False || k_e, Error("bc", [2, 5]) {
    True as whole, Cv1 -> whole || True
    False, _ -> True
    _, Cv1 -> False
    v5, v6 -> !v5
  }
  echo case <<"x":utf8>>, "a" {
    <<4:16>>, _ -> case k_golden {
      "bc" <> rest -> "a"
      a -> {
        let k_golden = False
        let length = 4
        a
      }
    }
    <<"x":utf8>>, "res" <> rest if rest == "a" || rest == "bc" -> "x"
    <<_:utf8, arguments:8>>, constructor -> case Error("x", []) {
      constructor -> k_golden
      _ | Cv1 -> fn(v7) { "x" }(False)
    }
    _, v8 -> case y |> f0(3 * 0) {
      True -> ""
      constructor -> k_golden
      _ | False -> "constructor"
    }
  }
  echo False
}
