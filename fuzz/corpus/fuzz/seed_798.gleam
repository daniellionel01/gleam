pub const k_golden: Int = 0
pub const k_e: Bool = True

pub type Symbol {
  Cv0(value: String, inner: Float)
  Cv1(Float, List(Int))
  Cv2(Int)
}

fn static(constructor: Int, v3: List(Int), v4: #(List(Int), List(Int))) -> Float {
{
    1.5
  } +. {
    case 0.1 {
      v5 -> 1.0
      0.25 | 0.25 -> fn(v6) { 3.14 }(2.0)
    }
  }
}

fn f1(s: #(Float, Int), length: Bool, v7: Int) -> Float {
{
    case [7, 100] {
      [9] -> 0.0
      [_] -> 100.0
      _ -> {
        1.0
      } -. {
        0.5
      }
    }
  } +. {
    {
      100.0
    } -. {
      1.5
    }
  }
}

fn new(v8: Int, delete: Int, v9: String) -> List(Int) {
[42]
}

pub fn main() {
  echo []
  echo 1.5
  echo {
    let k_golden = case 5 {
      inner -> 100.0
      _ -> 2.0
    }
    {
      "a" <> "res"
    } <> "abc"
  }
  echo case fn(v10) { Cv2(7) }(1) {
    Cv0(_, 0.25) -> []
    Cv1(_, [k_golden, constructor, ..] as whole) if k_golden > 0 || constructor > 9 -> whole
    inner -> case 0 - k_golden {
      5 -> [42]
      _ -> {
        let item = [42]
        let arguments = 1.5
        [3]
      }
    }
  }
}
