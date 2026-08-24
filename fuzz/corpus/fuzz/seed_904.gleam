pub const k_limit: Float = 100.0

pub type Number {
  Record
  Cv0(Float)
  None(value: Bool)
}

fn extends(v1: Int) -> Bool {
True
}

pub fn main() {
  echo {
    0 - {
      42 + 0
    }
  } - {
    0 - {
      2 % 6
    }
  }
  echo case k_limit {
    b -> {
      k_limit +. b
    } +. {
      {
        let acc = True
        k_limit
      }
    }
    1.0 -> {
      10.0
    } -. {
      {
        let k_limit = False
        let m = "bc"
        1.5
      }
    }
  }
  echo k_limit >=. {
    fn(v2) { {
      100.0
    } -. {
      100.0
    } }(0.25)
  }
  echo case {
      let z = False
      ""
    }, 2 {
    "res" as whole, 6 -> [1, 10]
    "b" <> _, pair -> {
      let pair = extends(pair)
      []
    }
    _, v3 -> []
  }
}
