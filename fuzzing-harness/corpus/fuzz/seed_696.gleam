pub const k_tag: String = "constructor"
pub const k_pi: Float = 2.0
pub const k_e: Bool = True

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(n: Int) -> List(Int) {
[0]
}

fn f1(v0: String) -> Bool {
fn(v1, v2) { !{
    fn(v3, v4) { True }(4, "constructor")
  } }(5, True)
}

pub fn main() {
  echo {
    {
      {
        0.1
      } -. k_pi
    } *. {
      {
        let k_tag = []
        let k_pi = k_e
        0.1
      }
    }
  } == {
    k_pi -. k_pi
  }
  echo k_tag
  echo {
    let pair = case fn(v5, v6) { "a" }("x", True) {
      _ -> [0, 1]
      a -> fn(v7) { [] }(2.0)
    }
    let l = {
      {
        let pair = k_tag
        4
      }
    } + 3
    pair
  }
  echo {
    let constructor = 10
    100.0
  }
}
