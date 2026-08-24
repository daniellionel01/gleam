pub const k_tag: Int = 3
pub const k_golden: Float = 0.25
pub const k_e: Bool = False

pub type V0 {
  Some(value: String, inner: String)
  Cv1
  Cv2(Float, value: Int)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn static(v3: Int) -> String {
"abc"
}

fn f1(v4: Int) -> Int {
walk([], {
    fn(v5, v6) { 3 }(True, 3)
  } - {
    v4 + 4
  })
}

pub fn main() {
  let this_ = {
    let length = False
    let length = k_golden
    static(4)
  }
  echo case [] |> walk(k_tag) {
    0 -> f1(1) < {
      fn(v7) { k_tag }(100.0)
    }
    _ -> case {
        let value = "a"
        2
      } {
      b -> {
        0.5
      } <=. {
        0.0
      }
      _ -> False
    }
    k_tag -> case fn(v8) { 4 }(1), {
        let k_tag = k_e
        let x = 10.0
        Cv2(3.14, 2)
      } {
      v9, Cv1 if v9 > 9 && v9 > 9 -> k_e
      v10, _ -> 0 >= v10
      0 as whole, Cv2(this_, _) as it -> {
        let value = 2.0
        k_e
      }
    }
  }
}
