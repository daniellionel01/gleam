pub const k_limit: Float = 0.0

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Record(Float)
  Ok
}

pub type V2 {
  Cv3
}

fn constructor(length: Bool, v4: V2) -> List(Int) {
[]
}

fn f1(y: Bool) -> String {
case Cv3 {
    Cv3 -> {
      let y = 42 == 2
      "abc"
    }
    v5 -> "res"
    y -> case "constructor", Ok {
      _, Cv1([y], 0) if y <= 7 -> "a"
      "abc", Ok -> "res" <> "ab"
      _, Cv1([y], 1) -> "constructor" <> "abc"
      _, _ -> "bc" <> "a"
    }
  }
}

pub fn main() {
  let default = {
    let k_limit = True
    let l = True && k_limit
    k_limit
  }
  echo "abc"
}
