pub const k_e: Int = 42
pub const k_tag: Int = 4
pub const k_pi: Bool = True

pub type V0 {
  Cv1(value: List(Int))
  Cv2(List(Int))
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(v: List(Int), v3: V0, v4: Int) -> Int {
spin(0, v4)
}

pub fn main() {
  let k_e = []
  let n = k_e
  echo case Cv2([5]) {
    item -> True
    b -> {
      k_tag - 5
    } <= k_tag
  }
  echo {
    fn(v5, v6) { 42 }("b", False)
  } <= k_tag
  echo fn(v7, v8) { v7 <> v7 }("constructor", 0.5)
  echo case <<3:8, 4:8, 3:16>> {
    <<1:8, item:little-signed-8>> -> case {
        let default = 1.0
        let acc = k_tag
        Cv2([100, 5])
      } {
      _ | Cv2(_) -> k_pi
      item -> 10 == 4
      Cv1([8]) -> True
    }
    _ -> True
  }
}
