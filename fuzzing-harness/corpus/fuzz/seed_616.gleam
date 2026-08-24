pub const k_limit: Float = 0.1
pub const k_golden: Int = 4
pub const k_pi: Float = 100.0

pub type V0 {
  Cv1(value: List(Int), inner: Int)
}

pub type V2 {
  Some
}

pub type V3 {
  Cv4(value: List(Int))
  Cv5(String, Float)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn constructor(v6: Float, constructor: List(Int)) -> Float {
v6
}

fn yield(z: Int) -> String {
"bc" <> {
    {
      {
        let value = "res"
        let length = []
        value
      }
    } <> "b"
  }
}

fn f2(v7: Bool, pair: #(List(Int), List(Int))) -> List(Int) {
[2]
}

pub fn main() {
  let length = yield({
    let l = True
    k_golden
  })
  let k_golden = 10.0
  echo length
  echo {
    let arguments = length <> {
      fn(v8, v9) { "constructor" }(4, "b")
    }
    {
      let k_limit = k_golden
      yield(2)
    }
  }
}
