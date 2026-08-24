pub const k_golden: Float = 100.0
pub const k_limit: String = "ab"
pub const k_seed: Int = 0

pub type V0 {
  Cv1(value: List(Int), inner: Int)
}

pub type V2 {
  Some
}

pub type V3 {
  Cv4
  Cv5(Bool, Int)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v6: Int, pair: Int, value: Int) -> Bool {
True
}

fn export(arguments: Bool) -> Bool {
{
    case {
        let s = []
        let constructor = 10.0
        "bc"
      } {
      "data" | "abc" -> 3.14
      "a" | "" <> _ -> 1.5
      "bc" as whole -> {
        1.5
      } +. {
        0.0
      }
      _ -> 0.25
    }
  } == {
    3.14
  }
}

fn f2(n: Float) -> String {
case "res" {
    "abc" <> item -> {
      {
        let n = [2]
        let z = True
        "bc"
      }
    } <> {
      {
        let v = n
        let length = n
        "data"
      }
    }
    _ -> case fn(v7) { 0.1 }(3), {
        let item = ""
        let n = [5, 3]
        n
      } {
      1.5, [b] -> "bc"
      0.5, [2] -> "data"
      _, _ -> "res" <> "data"
    }
  }
}

pub fn main() {
  let k_limit = fn(v8) { "bc" }(3.14)
  let delete = case {
      let l = True
      Cv1([3], 10)
    } {
    Cv1([k_golden], 1) -> walk([], 42)
    Cv1([], value) -> walk([3], 4)
    v9 -> k_seed - k_seed
  }
  echo case #(5, False) {
    #(_, _) | #(5, False) -> 0.0
    #(3, v10) if v10 && !v10 -> k_golden
    #(_, False) -> {
      1.5
    } *. k_golden
    _ -> case f2(0.1), [100] {
      "a" <> rest, [] if rest != "b" && rest != "ab" -> {
        let l = True
        let constructor = delete
        10.0
      }
      "" <> rest, [k_limit] -> fn(v11, v12) { 0.0 }("abc", 4)
      v13, v14 -> {
        0.1
      } -. k_golden
    }
  }
  echo False
  echo case Cv5(False, 7) {
    Cv4 -> k_golden
    Cv5(False, 2) | Cv5(_, _) -> 0.5
    _ -> 1.5
  }
}
