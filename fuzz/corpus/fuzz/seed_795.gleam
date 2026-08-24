pub const k_seed: Float = 0.5
pub const k_pi: Int = 3
pub const k_limit: Float = 2.0

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(this_: Bool) -> List(Int) {
fn(v0, v1) { case fn(v2, v3) { [100, 5] }(1.5, ""), fn(v4) { "x" }(False) {
    [], constructor if constructor == "constructor" -> []
    [v1, ..rest], "res" -> [10]
    v5, _ -> v5
  } }(1.5, 10)
}

fn export(z: Int) -> Bool {
100 == {
    case z {
      pair -> 0
      8 | 1 -> z |> spin(3 |> spin({
        let n = z
        n
      }))
      item -> item + 4
    }
  }
}

pub fn main() {
  let x = k_pi
  echo 1.0
  echo {
    spin(x, 0) - 10
  } == {
    case #(False, []) {
      item -> 5 |> spin(7 - k_pi)
      #(value, []) if !value -> fn(v6) { x }("constructor")
      #(True, [8, ..rest]) as whole -> 42
    }
  }
  echo False
  echo "abc"
}
