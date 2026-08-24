pub const k_golden: Int = 4
pub const k_tag: Int = 1
pub const k_e: String = "a"

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Number(Int, Bool)
  Cv2(List(Int), String)
}

pub type V3 {
  Cv4(value: List(Int), inner: String)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn export(v5: Int, new: List(Int), y: List(Int)) -> List(Int) {
new
}

fn default(length: List(Int), x: V0, v6: V0) -> Bool {
case fn(v7) { True }(4), fn(v8) { length }(1.5) {
    True as whole, [0, a, ..] as it -> case {
        let whole = 0.0
        let acc = 1.5
        False
      } {
      True -> a >= a
      item -> {
        0.5
      } != {
        0.0
      }
      _ -> {
        3.14
      } != {
        1.0
      }
    }
    x, [0] -> case walk(length, 10) {
      3 as whole if whole == 5 -> x
      7 -> fn(v9, v10) { False }(False, 0.0)
      _ -> "constructor" != "data"
    }
    v11, _ -> False
  }
}

fn f2(acc: String, class: String, y: V0) -> Bool {
True
}

pub fn main() {
  let m = export(1, {
    let item = k_tag
    [7, 42]
  }, [42])
  let z = {
    let m = {
      0.25
    } +. {
      0.1
    }
    let default = m -. m
    k_golden + 4
  }
  echo case fn(v12) { 100 }(100.0) {
    inner -> {
      let m = walk(m, k_tag)
      []
    }
    6 -> [5]
  }
  echo {
    let x = z
    let length = False
    case 0 |> export(m, {
        let m = k_e
        let self_ = length
        [0, 10]
      }), 3 {
      [0, _, ..], 0 -> m
      [a, ..rest], 7 -> []
      v13, v14 -> {
        let x = k_tag
        let v14 = [10]
        m
      }
    }
  }
}
