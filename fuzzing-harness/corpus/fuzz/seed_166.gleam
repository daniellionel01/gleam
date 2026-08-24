pub const k_limit: Float = 3.14
pub const k_e: Int = 42
pub const k_seed: Float = 10.0

pub type Record {
  Cv0(value: String, inner: String)
  Cv1(value: String)
}

fn constructor(v2: Bool) -> Bool {
False
}

fn f1(default: List(Int), new: List(Int), arguments: String) -> Float {
{
    0.5
  } +. {
    2.0
  }
}

pub fn main() {
  let delete = case [4, 2] {
    [9, ..rest] -> False
    [5, k_limit, ..] -> True
    _ -> True |> constructor()
  }
  echo case fn(v3) { Cv1("res") }(5) {
    b -> case {
        let m = [4, 2]
        let n = False
        "constructor"
      }, {
        let m = 4
        let k_e = 0.5
        b
      } {
      "ab" as whole, Cv1("x" <> _) if whole != "data" -> 0.0
      b, Cv0("bc", "a") if b != "" || b != "" -> k_seed
      "x" as whole, Cv0("bc" <> _ as it, "b" as subject_) -> f1([42, 3], [10, 7], it)
      _, _ -> k_limit
    }
    inner -> f1([0], {
      let y = [42, 2]
      []
    }, "res" <> "bc")
    v4 -> case "b" <> "constructor" {
      delete | "b" <> delete -> k_seed -. {
        100.0
      }
      "res" | "ab" -> k_seed
      a | "" <> a -> f1([42, 2], [1], "ab")
    }
  }
  echo {
    case fn(v5) { v5 }(3) {
      _ | 5 -> k_seed +. {
        2.0
      }
      1 | 3 -> 0.5
      0 | 7 -> 3.14
    }
  } +. k_seed
  echo k_limit
  echo {
    let v = {
      "res" != "a"
    } && {
      delete && delete
    }
    let z = k_seed /. {
      10.0
    }
    case 2 {
      b -> b + k_e
      a -> k_e
    }
  }
}
