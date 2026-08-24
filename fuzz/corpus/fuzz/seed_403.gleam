pub const k_pi: Bool = True

pub type Record {
  Cv0(value: String, inner: List(Int))
  Cv1(value: Float)
}

fn f0(v2: #(List(Int), List(Int))) -> String {
"res"
}

fn extends(v3: #(List(Int), Int), default: Bool) -> String {
case "b", 1 != 5 {
    "constructor" <> rest as whole, False -> {
      #([10], []) |> f0()
    } <> whole
    _, _ -> ""
    "constructor" <> rest, True -> rest <> {
      {
        let length = rest
        let default = 10.0
        rest
      }
    }
  }
}

pub fn main() {
  let k_pi = fn(v4, v5) { 0 }(True, "bc")
  echo k_pi
  echo {
    let k_pi = True
    let k_pi = []
    False
  }
  echo {
    let z = fn(v6, v7) { [10, 0] }(True, 0.5)
    {
      {
        1.0
      } +. {
        1.0
      }
    } +. {
      {
        1.5
      } *. {
        2.0
      }
    }
  }
  echo f0(case k_pi {
    _ | 5 -> #([4, 42], [])
    item -> #([3], [])
    _ | 6 -> {
      let class = 0.5
      let prototype = True
      #([2], [7])
    }
  })
}
