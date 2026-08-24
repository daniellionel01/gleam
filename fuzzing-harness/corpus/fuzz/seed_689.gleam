pub const k_seed: Bool = True
pub const k_pi: Int = 1

pub type Map {
  Cv0(value: String, inner: List(Int))
  Some
}

pub type V1 {
  Cv2
  Cv3
  Cv4(String, value: Float)
}

pub type V5 {
  Record(String, String)
  Cv6(value: Bool, inner: Float)
  Cv7(value: Int, inner: Int)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn export(v8: String, constructor: Bool, v9: Bool) -> List(Int) {
fn(v10, v11) { fn(v12, v13) { [] }(2, False) }(False, 7)
}

fn f1(v14: List(Int), v15: Bool, value: Bool) -> String {
case {
      let v15 = 0.5
      "x"
    }, "res" {
    "res" <> rest, "res" <> _ -> case #([42, 0], 7) {
      #([5] as whole, 3) -> rest
      #([a, 2, ..], 2) -> fn(v16) { "abc" }(10)
      _ -> "constructor"
    }
    _, "b" -> case Cv0("constructor", []) {
      Some -> "" <> ""
      default -> "" <> "a"
      Cv0("x" <> rest, [9]) -> "bc" <> ""
    }
    _, v17 -> {
      v17 <> v17
    } <> "x"
  }
}

fn f2(item: Float, l: Int, y: #(Bool, List(Int))) -> List(Int) {
[5, 4]
}

pub fn main() {
  echo case {
      let k_pi = 1.0
      let k_seed = 0
      Cv4("", 10.0)
    }, 3 {
    Cv3, v18 -> {
      let arguments = v18 % 2
      let s = [100, 1]
      True
    }
    Cv2, _ -> fn(v19) { False }("b")
    _, _ -> case fn(v20) { #(0.25, "a") }("a") {
      #(v21, "a") -> True
      #(0.1, _) | #(10.0, "abc") -> "abc" == "b"
      v22 -> False
    }
  }
  echo {
    case True {
      b -> 0
      b -> k_pi
      _ -> k_pi |> spin(spin(5, k_pi))
    }
  } % 6
  echo {
    case {
        let k_seed = 3.14
        let k_pi = False
        #([100], [0])
      }, fn(v23) { "ab" }("ab") {
      #([x, ..rest], [k_seed]), "" <> _ -> x |> spin(spin(7, k_seed))
      #([_, 3, ..], [7] as whole), "a" <> _ -> 0 - 5
      #([_, _, ..], [5]), _ -> k_pi
      v24, v25 -> k_pi
    }
  } != {
    case [42] |> f1(!k_seed, k_pi > k_pi) {
      "a" <> item if item != "" -> k_pi |> spin(spin(k_pi, 7))
      "b" <> rest -> fn(v26, v27) { 42 }(0.1, True)
      v28 -> k_pi
    }
  }
  echo k_seed
}
