pub const k_seed: Bool = True
pub const k_golden: String = "b"

pub type V0 {
  Cv1(value: List(Int))
  Cv2
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn static(v3: String, v4: Int, delete: Int) -> List(Int) {
[4, 4]
}

fn f1(class: V0, v5: Float) -> Float {
v5
}

pub fn main() {
  let y = []
  echo case 1.5 {
    _ -> {
      let default = k_golden <> k_golden
      let default = 100.0
      k_seed
    }
    1.0 -> case walk([3], 2) {
      0 | 6 -> True
      7 -> k_seed
      8 | 5 -> k_seed
      v6 -> True
    }
    v7 -> {
      y |> walk(3 + 4)
    } <= 7
  }
  echo case k_golden <> k_golden {
    a | "data" <> a -> "abc"
    _ | "abc" -> case f1(Cv2, 0.0), 3 {
      v, 4 -> k_golden
      100.0, 5 -> "res"
      _, _ -> {
        let this_ = [100, 0]
        k_golden
      }
    }
    "res" <> rest | "ab" <> rest -> {
      let z = walk(y, 2)
      let v = 100 <= z
      "x"
    }
  }
  echo fn(v8) { case v8 {
    b -> walk([], v8)
    v9 -> [7, 1] |> walk({
      let constructor = 0.5
      v8
    })
    item -> 2
  } }(4)
  echo y
}
