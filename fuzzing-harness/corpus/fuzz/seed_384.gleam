pub const k_tag: Float = 0.0
pub const k_seed: Bool = False
pub const k_pi: Bool = True

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(value: Bool)
  Number
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(new: List(Int), item: V0, v3: Int) -> List(Int) {
case 1.0, fn(v4) { 3.14 }(False) {
    1.0 as whole, 3.14 as it -> [5, 10]
    10.0 as whole, 0.5 -> case fn(v5) { Cv1([], 2) }(10), new |> walk(1) {
      Cv2(item), 3 if item || item -> [10]
      Cv2(_), 2 -> []
      v6, _ -> [4]
    }
    v7, 0.25 -> case item {
      Cv1(_, constructor) -> [1]
      _ | Number -> {
        let v3 = new
        let v3 = True
        [10, 2]
      }
    }
    v8, v9 -> new
  }
}

pub fn main() {
  let k_seed = {
    {
      let acc = k_tag
      let k_seed = "ab"
      k_seed
    }
  } <> {
    {
      let x = 42
      "ab"
    }
  }
  let z = case 1.0 {
    _ | 10.0 -> [4]
    0.25 -> [3, 42]
    0.0 | 0.1 -> fn(v10) { [] }(100)
  }
  echo {
    k_seed == {
      {
        let s = 5
        let acc = z
        k_seed
      }
    }
  } && {
    {
      7 - 3
    } == {
      0 + 2
    }
  }
}
