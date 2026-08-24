pub const k_golden: Float = 0.1
pub const k_e: String = "data"
pub const k_seed: String = ""

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(String, value: Int)
}

fn default(v3: #(Bool, Int)) -> List(Int) {
[]
}

fn delete(item: Bool, m: Bool, v4: Int) -> Int {
case {
      let value = 0.1
      let z = value
      False
    }, "a" {
    True as whole, "" <> rest -> v4
    True, _ -> 5 + {
      {
        let item = 2
        let s = True
        3
      }
    }
    True, "a" -> v4 - 10
    _, _ -> fn(v5, v6) { v4 - 7 }(4, True)
  }
}

pub fn main() {
  let k_e = case 1 {
    b -> fn(v7) { k_seed }("ab")
    inner -> {
      let inner = 10.0
      k_seed
    }
  }
  let k_seed = "x"
  echo {
    "data" <> {
      k_seed <> k_e
    }
  } <> "a"
  echo {
    1 - 7
  } != 10
  echo fn(v8) { fn(v9, v10) { "b" <> k_e }(0, "data") }(False)
}
