pub const k_limit: Bool = False
pub const k_golden: Int = 42
pub const k_pi: Int = 1

pub type V0 {
  Cv1(value: List(Int))
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn class(m: V0, new: Bool) -> Int {
spin(10 - {
    fn(v2, v3) { v2 }(5, True)
  }, {
    let m = {
      let x = new
      let x = [1, 42]
      3
    }
    m |> spin({
      let v = 1.5
      m
    })
  })
}

pub fn main() {
  let y = k_limit
  echo 2 + {
    {
      let arguments = {
        0.1
      } *. {
        0.1
      }
      k_pi
    }
  }
  echo case k_pi |> spin(5 + k_golden) {
    a -> {
      let x = {
        let l = "b"
        [0, 2]
      }
      let x = {
        10.0
      } >. {
        0.5
      }
      [100]
    }
    b -> [1]
  }
  echo case [] {
    [constructor, x, ..] -> False
    [k_pi] -> y
    [] -> True
    v4 -> k_limit || y
  }
}
