pub const k_limit: Bool = True
pub const k_pi: Float = 3.14

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(z: String) -> Int {
100
}

fn f1(arguments: Bool, v0: Bool, acc: Int) -> Int {
fn(v1, v2) { fn(v3, v4) { spin(acc, 42) }("data", "abc") }(False, "data")
}

fn f2(v5: String) -> Int {
10
}

pub fn main() {
  let k_pi = k_pi
  echo fn(v6) { 100 + {
    True |> f1(False, 7 - 7)
  } }(True)
  echo {
    let y = k_limit
    let k_pi = case [5, 7] {
      [6, ..rest] -> k_pi *. {
        2.0
      }
      [k_pi] -> 3.14
      [4, ..rest] -> 0.0
      v7 -> 2.0
    }
    fn(v8, v9) { [10] }(False, 0.1)
  }
}
