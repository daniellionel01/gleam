pub const k_seed: Int = 3
pub const k_tag: Bool = False

pub type V0 {
  Cv1(value: List(Int), inner: Int)
}

fn static(s: V0, n: Bool) -> List(Int) {
case {
      let this_ = []
      s
    } {
    item -> [0]
    Cv1([] as whole, 9) -> case s, "a" {
      _, _ -> whole
      Cv1([_], 3), "ab" as whole -> [1, 4]
      Cv1([_, ..rest], _), "bc" <> tail as whole -> [5]
    }
  }
}

fn new(delete: #(Float, Int), item: List(Int)) -> Bool {
False
}

pub fn main() {
  let length = False
  let k_seed = case "" {
    b -> True || length
    "abc" -> True || k_tag
    "b" | "constructor" <> _ -> True
  }
  echo case "ab", k_seed {
    _, True -> {
      fn(v2) { 10 }(2)
    } * {
      {
        let pair = "b"
        let x = k_seed
        2
      }
    }
    "x" as whole, False -> case "abc" {
      "ab" <> rest -> 0
      "x" <> rest if rest != "b" || rest == "a" -> 42 - 7
      "data" <> constructor | "" <> constructor -> 100 - 42
      _ -> 5 - 42
    }
    v3, _ -> 5
  }
}
