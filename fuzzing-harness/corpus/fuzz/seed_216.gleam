pub const k_seed: Float = 3.14
pub const k_pi: Float = 0.0
pub const k_limit: Int = 7

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: String, l: List(Int), length: Int) -> Bool {
{
    {
      0.25
    } +. {
      0.1
    }
  } >. {
    {
      {
        0.0
      } /. {
        2.0
      }
    } -. {
      {
        1.0
      } /. {
        10.0
      }
    }
  }
}

pub fn main() {
  echo True
}
