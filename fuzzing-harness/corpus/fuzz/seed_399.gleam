pub const k_e: Bool = True
pub const k_golden: String = "bc"
pub const k_seed: Float = 0.1

pub type V0 {
  Cv1(value: List(Int))
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn export(acc: String, v2: Int) -> List(Int) {
[10, 2]
}

pub fn main() {
  let k_seed = case k_golden {
    a | "" <> a -> k_e
    item | "a" <> item -> True
    "bc" <> _ -> {
      let y = []
      let new = k_golden
      k_e
    }
  }
  let x = {
    let delete = {
      1.0
    } +. {
      1.5
    }
    let value = delete
    3 * 42
  }
  echo x
  echo [10]
  echo 1.0
  echo {
    let k_seed = case spin(x, 3) {
      inner -> x * 5
      _ -> {
        let prototype = k_e
        let length = []
        100
      }
      4 -> spin(4, 42)
    }
    {
      {
        1.0
      } *. {
        0.0
      }
    } +. {
      {
        1.0
      } /. {
        2.0
      }
    }
  }
}
