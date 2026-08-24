pub const k_tag: String = "abc"
pub const k_pi: Float = 0.5

fn constructor(constructor: String, v0: Bool, y: Int) -> Bool {
v0
}

pub fn main() {
  echo {
    case 2, k_pi -. {
        10.0
      } {
      0, 10.0 as whole -> 100 - 7
      8 as whole, y -> whole * 3
      1, 0.5 -> 1
      _, _ -> 5 % 5
    }
  } - {
    case 2 {
      inner -> inner * inner
      constructor -> 42 - 7
      _ | 3 -> 7
    }
  }
}
