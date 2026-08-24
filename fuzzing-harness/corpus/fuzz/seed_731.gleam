pub const k_limit: String = "abc"
pub const k_seed: Int = 2
pub const k_golden: Int = 100

pub type V0 {
  Error(value: String, inner: List(Int))
  Cv1(Float)
}

pub type V2 {
  Cv3(value: Int, inner: List(Int))
  Ok(Bool, value: Float)
  Cv4(value: Int, inner: List(Int))
}

fn f0(v5: Int, constructor: Int) -> Int {
{
    let constructor = {
      1.0
    } +. {
      fn(v6) { 3.14 }("res")
    }
    v5
  }
}

fn f1(n: Int, v7: Int) -> Float {
{
    {
      let acc = "constructor"
      let v7 = "abc" <> acc
      100.0
    }
  } /. {
    10.0
  }
}

pub fn main() {
  let constructor = case k_seed {
    constructor -> {
      let constructor = k_limit
      let rest = 5
      [5]
    }
    0 -> [42]
  }
  let k_golden = [7, 10]
  echo {
    0.1
  } +. {
    case {
        let this_ = k_limit
        k_limit
      }, 4 |> f0({
        let constructor = 100
        4
      }) {
      "res" <> _, 0 -> 2.0
      "ab" <> rest, 9 if rest != "x" -> {
        100.0
      } +. {
        3.14
      }
      "a", 1 -> {
        let v = 1.5
        let value = "x"
        v
      }
      _, _ -> {
        let k_limit = 0.0
        let default = "a"
        k_limit
      }
    }
  }
  echo 100 - {
    {
      k_seed % 4
    } - {
      {
        let constructor = [100]
        let s = True
        k_seed
      }
    }
  }
  echo k_seed
  echo {
    {
      let acc = k_golden
      let constructor = 1
      {
        0.5
      } -. {
        2.0
      }
    }
  } /. {
    0.5
  }
}
