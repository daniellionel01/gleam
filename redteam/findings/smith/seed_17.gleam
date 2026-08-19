pub type V0 {
  Some(value: List(Int), inner: List(Int))
  Cv1(value: Bool, inner: List(Int))
  Cv2(value: List(Int), inner: String)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v3: #(List(Int), Bool), delete: Int, constructor: Int) -> Int {
{
    let class = False
    spin(fn(v4) { 3 }(4), constructor % 4)
  }
}

pub fn main() {
  let x = case <<"res":utf8, "constructor":utf8>> {
    <<"":utf8, _:8, _:utf8>> -> "constructor"
    <<1:8, _:bytes>> -> fn(v5, v6) { "x" }(True, False)
    v7 -> {
      let class = 1
      "data"
    }
  }
  let default = case [] {
    [] -> fn(v8) { 0 }(True)
    [h] -> h + 7
    [9] -> 2
    v9 -> {
      let y = 10
      let v9 = v9
      4
    }
  }
  echo spin(2, case 4 |> spin(spin(3, default)), Some([], [0, 7]) {
    9 as whole, Cv2([], "ab") -> default % 3
    3, Cv2([], _) -> f0(#([], False), 10, default)
    v10, _ -> 4 |> spin(v10 * default)
  })
  echo default
  echo {
    let x = "a"
    let x = case fn(v11) { "a" }("abc") {
      _ -> x
      item -> {
        let m = 42
        let x = [1, 42]
        item
      }
    }
    case {
        let default = []
        let z = False
        default
      } {
      [0, ..rest] -> True
      [] -> "data" == ""
      [constructor] as whole -> True
      _ -> False
    }
  }
}
