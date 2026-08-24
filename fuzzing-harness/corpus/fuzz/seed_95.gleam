pub const k_seed: Int = 3
pub const k_limit: Int = 42
pub const k_pi: String = "res"

pub type Number {
  Record
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn export(y: String) -> String {
y
}

fn f1(arguments: Float, delete: Bool, x: List(Int)) -> Bool {
delete
}

fn f2(v0: Float, value: List(Int), v1: Number) -> Bool {
True
}

pub fn main() {
  echo spin(0, {
    {
      let prototype = "res"
      k_seed
    }
  } |> spin(k_seed))
}
