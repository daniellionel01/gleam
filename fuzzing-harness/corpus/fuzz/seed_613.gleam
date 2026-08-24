pub const k_pi: String = "bc"

pub type V0 {
  Cv1
  Cv2
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(item: V0, v3: Int, v4: List(Int)) -> Bool {
case fn(v5, v6) { v6 }("constructor", True) {
    False -> True
    b -> False
    inner -> {
      {
        let item = v3
        let item = [10]
        v3
      }
    } != walk(v4, v3)
  }
}

fn arguments(s: String, m: Float, l: Bool) -> Float {
m
}

pub fn main() {
  let k_pi = fn(v7, v8) { {
    let v7 = [2, 42]
    let k_pi = v7
    k_pi
  } }(100.0, True)
  echo "bc"
  echo {
    {
      let constructor = fn(v9) { "abc" }("bc")
      "constructor"
    }
  } |> arguments(arguments("abc", 0.25, False), True)
  echo "res"
  echo "bc"
}
