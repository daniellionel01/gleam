pub const k_seed: Float = 1.0
pub const k_e: String = "x"
pub const k_golden: Int = 0

pub type V0 {
  Some(value: String, inner: List(Int))
  None(value: Bool)
}

pub type Promise {
  Cv1(Int)
  Cv2(value: Bool)
}

fn f0(v3: Int) -> String {
"ab"
}

fn f1(v4: Bool, default: Int, v5: Int) -> Int {
default
}

pub fn main() {
  echo case 10 |> f0() {
    "constructor" | "abc" -> {
      let class = False
      let pair = 1.0
      class
    }
    a -> case [10] {
      [7] -> {
        let y = 100.0
        False
      }
      [a] if a <= 1 -> False
      [h, _, ..] -> False
      _ -> {
        0.0
      } != {
        0.0
      }
    }
    "b" | "res" <> _ -> case #("ab", [1]) {
      #("ab", [8, ..rest] as whole) -> {
        100.0
      } >. k_seed
      #("abc", [constructor]) if constructor <= 5 -> False
      #(acc, [1]) -> True
      v6 -> True
    }
  }
  echo case False, {
      let x = k_e
      let length = "ab"
      4
    } {
    _, _ -> case fn(v7, v8) { #(True, True) }(3, 1.0) {
      #(False, True) -> True
      item -> True
      #(_, True) -> fn(v9, v10) { False }(1, "b")
    }
    True as whole, v11 -> 1 <= {
      {
        let whole = [3, 5]
        100
      }
    }
    False, v12 -> True
  }
  echo case {
      let k_golden = False
      let m = [7, 2]
      ""
    } {
    pair -> [4]
    "x" as whole if whole == "bc" -> [4]
    "a" -> {
      let arguments = {
        let acc = True
        [4]
      }
      []
    }
  }
}
