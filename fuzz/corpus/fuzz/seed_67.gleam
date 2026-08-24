pub const k_pi: Int = 4

pub type Record {
  Record
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn class(new: #(String, Int)) -> Bool {
{
    let delete = case {
        let v = False
        10.0
      }, fn(v0, v1) { 10 }(False, 3) {
      0.5 as whole, _ -> "" <> "constructor"
      v2, 7 -> "bc"
      _, _ -> {
        let arguments = True
        "data"
      }
    }
    case fn(v3, v4) { 2 }(False, False) {
      5 | 8 -> fn(v5) { False }(3.14)
      constructor -> False || False
    }
  }
}

fn f1(prototype: Int, v6: Int) -> String {
case v6, "bc" {
    _, v7 -> "x"
    1 as whole, "ab" -> "a"
  }
}

pub fn main() {
  let v = case {
      let this_ = [100, 2]
      #("constructor", [])
    } {
    #(_, [5, ..rest]) -> 0 |> spin(k_pi)
    #("constructor" as whole, [2, ..rest] as it) -> fn(v8) { 42 }(False)
    #("ab", [5, ..rest]) -> 0
    _ -> k_pi
  }
  let v = [0]
  echo {
    let this_ = fn(v9) { f1(5, k_pi) }("b")
    v
  }
}
