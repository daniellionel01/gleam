pub const k_limit: Float = 0.25
pub const k_tag: String = "a"

pub type V0 {
  Cv1(value: List(Int))
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn static(z: String, v2: Bool) -> Bool {
True
}

fn yield(item: Float, v3: Int, acc: Float) -> Int {
spin({
    v3 |> spin(spin(v3, 4))
  } - 0, v3)
}

fn f2(default: Int, delete: String, pair: Int) -> String {
"b"
}

pub fn main() {
  let s = 0
  echo case "ab" <> k_tag, k_tag <> k_tag {
    "res", z if z != "constructor" -> fn(v4, v5) { z <> "constructor" }(5, 10)
    "bc", "abc" -> case {
        3.14
      } |> yield(s % 5, k_limit /. {
        0.5
      }), #(True, [0]) {
      v6, #(self_, [5]) if v6 <= 2 -> s |> f2(k_tag <> k_tag, s)
      _, #(_, [0]) -> {
        let s = []
        k_tag
      }
      _, v7 -> "b" <> k_tag
    }
    v8, v9 -> v9
  }
  echo 1
  echo 5
}
