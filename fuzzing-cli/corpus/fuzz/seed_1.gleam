pub const k_tag: String = "res"

pub type V0 {
  Ok(value: String, inner: Int)
  Cv1
  Cv2(Int, value: Float)
}

fn f0(v3: Float, v: List(Int)) -> Bool {
True
}

fn f1(v4: Float, delete: String, v5: Int) -> Float {
{
    let new = {
      delete <> ""
    } <> {
      "res" <> "a"
    }
    case v5 - v5 {
      4 -> {
        0.25
      } *. {
        0.0
      }
      item -> fn(v6, v7) { 0.0 }(1, 1.5)
    }
  }
}

pub fn main() {
  let acc = {
    {
      0.0
    } +. {
      0.5
    }
  } |> f1(k_tag, 100)
  echo case fn(v8) { [1, 3] }(1.0) {
    [] -> case {
        let k_tag = 7
        True
      } {
      b -> "x"
      True -> k_tag
    }
    [4, _, ..] as whole -> {
      let delete = 10.0
      let length = whole
      ""
    }
    v9 -> "ab"
  }
  echo f1({
    let this_ = {
      let class = 42
      False
    }
    f1(acc, k_tag, 10)
  }, "a", 7)
  echo 1.0
}
