pub const k_pi: Float = 3.14

pub type Object {
  Record
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(y: Int, class: Float, s: Bool) -> String {
"bc" <> "bc"
}

pub fn main() {
  echo 5
  echo case fn(v0) { True }(True) {
    True -> case 0 + 100, Record {
      _, Record -> [7, 2]
      7, _ -> fn(v1, v2) { [] }(True, 0.25)
      _, _ -> [4]
    }
    inner -> case k_pi {
      constructor -> {
        let k_pi = "abc"
        [10]
      }
      constructor -> [4]
      inner -> []
    }
    new -> []
  }
  echo fn(v3, v4) { {
    {
      let default = False
      let v3 = 100
      k_pi
    }
  } -. {
    fn(v5, v6) { k_pi }(100, 2)
  } }("b", "ab")
}
