pub const k_pi: Bool = True
pub const k_tag: String = "constructor"
pub const k_seed: Float = 100.0

pub type Record {
  Cv0(value: String, inner: Float)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v1: Bool, v2: #(List(Int), Int), y: #(List(Int), String)) -> Int {
{
    case {
        let new = 3.14
        let n = "a"
        Cv0("data", 1.5)
      } {
      Cv0("abc", y) -> 0
      Cv0(_, constructor) -> fn(v3, v4) { v3 }(4, 1.0)
    }
  } - 3
}

fn extends(v5: Int, x: #(Int, Bool)) -> Bool {
{
    case fn(v6) { Cv0("", 0.0) }(False), "" {
      Cv0("data" <> rest, _), "ab" as whole if rest != "data" || whole == "b" -> True
      Cv0(new, 1.5), "" <> rest -> {
        let value = ""
        let class = rest
        False
      }
      _, _ -> False
    }
  } && {
    case 4, fn(v7, v8) { "constructor" }(3.14, True) {
      3, "abc" -> True
      8, "abc" <> rest if rest != "data" && rest != "x" -> {
        let length = [100]
        False
      }
      x, "a" <> _ -> False && True
      _, _ -> v5 >= v5
    }
  }
}

pub fn main() {
  let m = "abc"
  let k_pi = {
    let default = k_seed *. {
      10.0
    }
    k_seed *. {
      0.1
    }
  }
  echo case Cv0("b", 0.25) {
    arguments -> m
    b -> k_tag
    Cv0("res" <> rest, 2.0) -> k_tag <> "constructor"
  }
}
