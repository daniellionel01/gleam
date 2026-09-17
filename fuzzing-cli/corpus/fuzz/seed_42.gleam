pub const k_tag: Int = 42
pub const k_pi: String = "res"

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Int, v0: Int, v1: Bool) -> Bool {
case <<2:1, "":utf8>> {
    <<_:utf8>> -> True
    _ -> v1
  }
}

fn f1(n: List(Int), l: #(String, Float)) -> Int {
100
}

fn yield(v2: #(Int, List(Int)), class: Int) -> Float {
3.14
}

pub fn main() {
  echo {
    {
      {
        let s = "ab"
        let arguments = k_tag
        "constructor"
      }
    } <> {
      k_pi <> ""
    }
  } <> {
    {
      k_pi <> k_pi
    } <> {
      "ab" <> k_pi
    }
  }
}
