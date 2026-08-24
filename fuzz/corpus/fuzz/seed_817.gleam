pub const k_tag: String = ""

fn constructor(constructor: Float, v0: Int, delete: Bool) -> Int {
1
}

pub fn main() {
  let z = case k_tag, fn(v1) { #(True, 3.14) }(3) {
    "res", #(_, 0.25 as whole) -> k_tag <> k_tag
    "data", #(k_tag, 2.0) as whole -> "b"
    _, _ -> "ab" <> k_tag
  }
  echo z <> {
    k_tag <> "res"
  }
}
