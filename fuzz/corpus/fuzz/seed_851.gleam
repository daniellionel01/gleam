pub const k_limit: Int = 3
pub const k_tag: Float = 100.0
pub const k_seed: Float = 0.0

pub type V0 {
  Cv1
  Cv2
  Cv3
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(prototype: Int, this_: Int) -> String {
"constructor" <> {
    {
      {
        let delete = []
        let y = "data"
        "res"
      }
    } <> "bc"
  }
}

fn f1(rest: Bool, v4: Bool) -> Float {
0.25
}

fn f2(v5: Int, v6: Float, v7: Int) -> Int {
{
    let v5 = v5
    [10, 4] |> walk(fn(v8, v9) { 3 }(0.1, 0))
  }
}

pub fn main() {
  let self_ = {
    let k_tag = k_seed
    True |> f1(k_seed == k_tag)
  }
  echo case k_limit * k_limit, <<"b":utf8>> {
    _, <<"constructor":utf8, "":utf8>> -> f0(k_limit, k_limit + 7)
    5, <<42:8>> -> "res"
    7, _ -> {
      let k_limit = {
        3.14
      } +. self_
      let k_limit = {
        let this_ = "b"
        0.0
      }
      f0(1, 7)
    }
    v10, v11 -> fn(v12) { "x" <> "ab" }(True)
  }
  echo 10
}
