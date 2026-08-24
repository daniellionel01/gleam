pub const k_tag: Float = 2.0
pub const k_limit: Float = 2.0

pub type V0 {
  Number(value: String, inner: List(Int))
  Cv1(Int)
}

fn f0(v2: V0, v3: #(List(Int), Int)) -> Int {
fn(v4) { 1 }(5)
}

fn default(default: List(Int)) -> Int {
case default {
    [8, _, ..] -> 42
    [_, b, ..] if b > 2 && b <= 7 -> {
      {
        let constructor = b
        let acc = [3, 3]
        b
      }
    } - f0(Number("x", []), #([1, 0], 7))
    [] -> {
      2 - 5
    } + 42
    _ -> {
      Cv1(3) |> f0({
        let s = 10.0
        let item = 0.1
        #([42], 7)
      })
    } + f0(Cv1(4), #([1, 3], 2))
  }
}

fn f2(new: Int, arguments: Bool) -> Int {
2
}

pub fn main() {
  let m = case k_limit *. {
      100.0
    } {
    constructor -> fn(v5) { [] }(3.14)
    v6 -> [100]
  }
  let rest = case m {
    [9, ..rest] -> k_limit
    [] as whole -> fn(v7, v8) { k_limit }("b", 0.25)
    [] -> {
      let k_limit = "data"
      k_tag
    }
    _ -> {
      let k_tag = "bc"
      let self_ = k_limit
      self_
    }
  }
  echo "ab"
  echo case 7 - 7, fn(v9, v10) { "a" }(False, 100) {
    _, "res" -> 1.0
    1, "x" -> 0.1
    _, _ -> {
      {
        let m = m
        let s = []
        1.0
      }
    } +. {
      2.0
    }
  }
}
