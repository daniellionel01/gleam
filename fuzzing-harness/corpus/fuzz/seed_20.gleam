pub const k_tag: Bool = True

pub type V0 {
  Cv1
  Cv2
}

pub type V3 {
  Cv4
  Cv5(Int)
  Cv6(Float)
}

pub type V7 {
  Cv8
  None(String)
  Some(List(Int))
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v9: String, constructor: #(Bool, Bool)) -> List(Int) {
case 7 {
    constructor -> [5, 7]
    b -> []
  }
}

fn arguments(item: List(Int), v10: V0, v11: #(Int, List(Int))) -> List(Int) {
[]
}

pub fn main() {
  let k_tag = [7, 4]
  echo arguments(k_tag, Cv1, case k_tag {
    [] as whole -> #(42, [])
    [4, _, ..] -> #(100, [10])
    [k_tag] -> #(7, [])
    _ -> #(3, [])
  })
  echo case "constructor" {
    a -> {
      let k_tag = {
        0.0
      } +. {
        2.0
      }
      arguments([], Cv2, #(100, []))
    }
    _ | "" <> _ -> case {
        0.5
      } != {
        3.14
      } {
      b -> {
        let default = 4
        let k_tag = "bc"
        [7, 1]
      }
      item -> [100, 5]
      inner -> fn(v12) { [7, 4] }("bc")
    }
  }
}
