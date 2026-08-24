pub const k_e: Bool = False
pub const k_tag: Int = 0
pub const k_pi: Float = 0.25

pub type V0 {
  None(value: String, inner: List(Int))
  Cv1
  Cv2(value: List(Int), inner: Int)
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(arguments: Int, x: Float, v: Bool) -> Bool {
False
}

fn f1(z: List(Int), v3: List(Int), item: Bool) -> Int {
1
}

fn delete(self_: Bool, x: #(Bool, Bool), arguments: Int) -> Float {
100.0
}

pub fn main() {
  let x = {
    let k_pi = {
      let x = 100.0
      k_e
    }
    [7]
  }
  let l = {
    k_pi -. k_pi
  } -. {
    k_pi +. k_pi
  }
  echo case Cv2([4], 1) {
    _ -> 7
    None("b", [l, _, ..]) if l > 9 -> {
      fn(v4, v5) { 5 }(4, 100.0)
    } + 5
    Cv2(_, constructor) -> {
      {
        let class = [4, 2]
        constructor
      }
    } |> spin(3)
  }
}
