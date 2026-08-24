pub const k_e: Int = 5
pub const k_seed: Int = 100

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(constructor: String, s: String, n: List(Int)) -> List(Int) {
{
    let value = [42, 3] |> walk(5 + 1)
    let rest = case <<"b":utf8>>, "data" {
      <<4:8>>, _ -> s
      <<_:utf8, _:big-signed-1>>, value -> s <> constructor
      <<0:4, _:utf8>>, _ -> s <> constructor
      _, v0 -> "abc"
    }
    [100]
  }
}

pub fn main() {
  let s = []
  let k_seed = case {
      let k_seed = k_seed
      let prototype = k_e
      s
    }, fn(v1) { k_seed }(1.5) {
    [6, ..rest], 7 -> k_e * k_seed
    [a], 5 -> 10
    [k_e], _ -> 42
    v2, v3 -> walk([1, 100], v3)
  }
  echo k_e
  echo 0.25
}
