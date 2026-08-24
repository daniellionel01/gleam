pub const k_seed: Int = 10
pub const k_e: String = "ab"

pub type V0 {
  Cv1(value: List(Int))
  Cv2(String)
}

pub type Record {
  Number(value: Float)
  Cv3(List(Int))
  Cv4(Bool)
}

pub type Number {
  Cv5
  Cv6
  Some
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn class(v7: Bool, class: Float, s: Int) -> String {
"data"
}

pub fn main() {
  let s = case 0 - k_seed, 7 {
    9, 3 as whole if whole == 1 && whole > 8 -> [1]
    _, 4 -> []
    6, 1 -> {
      let k_e = True
      [7]
    }
    v8, v9 -> [7]
  }
  echo {
    let n = True
    let k_seed = False
    {
      let n = "a"
      0.25
    }
  }
  echo case "b", {
      let k_e = "b"
      0.25
    } {
    k_e, 0.25 if k_e == "" -> case fn(v10) { 42 }(4), {
        100.0
      } -. {
        3.14
      } {
      v11, 2.0 -> "a" == k_e
      4, 10.0 -> False && True
      2 as whole, _ -> True || True
      _, _ -> True
    }
    "" <> _, _ -> False
    _, v12 -> case 10.0 {
      b -> False
      constructor -> True || False
    }
  }
  echo case "" {
    v13 | "bc" <> v13 -> {
      fn(v14, v15) { "ab" }(3.14, 3.14)
    } <> {
      fn(v16, v17) { "abc" }("abc", True)
    }
    "a" -> k_e
    "res" -> "res"
  }
  echo case k_seed - k_seed, #(5, True) {
    4, #(1, True) -> {
      s |> walk(k_seed * k_seed)
    } - 7
    5 as whole, #(_, True as it) -> 4
    9, #(7, this_) -> case [1] {
      [9, a, ..] -> k_seed
      [1, ..rest] -> walk(rest, k_seed)
      _ -> walk(s, 100)
    }
    _, _ -> 1 - {
      [3, 4] |> walk(walk([100], 100))
    }
  }
}
