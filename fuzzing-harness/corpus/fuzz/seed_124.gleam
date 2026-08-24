pub const k_seed: Bool = True
pub const k_pi: String = "a"

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: Bool, v0: Int, delete: Bool) -> List(Int) {
[0, 10]
}

fn f1(prototype: Float, length: #(Bool, String), v1: #(Int, Float)) -> List(Int) {
case "b", 1 {
    v2, 4 if v2 == "abc" && v2 != "a" -> []
    l, _ -> []
  }
}

fn f2(new: Float, v3: Int, constructor: Float) -> List(Int) {
False |> f0(v3 + 4, False)
}

pub fn main() {
  echo k_pi
}
