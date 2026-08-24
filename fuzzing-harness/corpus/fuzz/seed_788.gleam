pub const k_e: Bool = True
pub const k_pi: Float = 10.0

pub type V0 {
  Cv1(value: List(Int))
  Cv2(Int, value: List(Int))
}

pub type V3 {
  Cv4
  None(value: List(Int), inner: List(Int))
  Cv5(value: List(Int))
}

pub type V6 {
  Cv7(value: List(Int), inner: List(Int))
  Cv8(Bool)
}

fn f0(v9: Int, new: V0) -> Int {
case "a" <> "x", fn(v10, v11) { v11 }(False, "constructor") {
    _, v12 -> v9
    v13, "" <> rest as whole -> case True {
      False -> v9
      False | True -> {
        let pair = v13
        2
      }
      v14 -> v9
    }
    "data", _ -> {
      let acc = "abc" <> "data"
      let x = v9 + v9
      10 * 5
    }
  }
}

fn f1(length: Float, self_: Float) -> Bool {
{
    fn(v15) { {
      1.0
    } -. self_ }("x")
  } == {
    case 1 * 3 {
      inner -> {
        let l = inner
        0.5
      }
      b -> self_
    }
  }
}

pub fn main() {
  let k_e = case [3, 1] {
    [] -> 1.0
    [a] if a <= 6 -> k_pi +. {
      2.0
    }
    [h, ..rest] -> {
      let constructor = h
      let self_ = False
      k_pi
    }
    _ -> 0.5
  }
  echo []
  echo fn(v16, v17) { {
    v16 |> f0(fn(v18, v19) { Cv2(2, []) }(0.5, True))
  } |> f0({
    let y = [100, 3]
    Cv2(2, [])
  }) }(42, "res")
  echo !{
    case 2 {
      item -> k_e == k_e
      1 as whole -> {
        2.0
      } != k_pi
    }
  }
}
