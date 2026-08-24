pub const k_limit: Bool = True
pub const k_seed: Int = 100

pub type Object {
  Record
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn delete(delete: Object) -> String {
"a" <> {
    case 0 % 4 {
      v0 -> "ab"
      2 -> "constructor"
      7 -> "bc"
    }
  }
}

fn f1(prototype: Object) -> Bool {
True
}

pub fn main() {
  echo k_limit
  echo fn(v1) { {
    0.5
  } -. {
    {
      let rest = v1
      let default = [2]
      0.25
    }
  } }("ab")
  echo k_seed
}
