pub const k_pi: Bool = False
pub const k_golden: String = "abc"
pub const k_e: Int = 4

pub type Record {
  Cv0(value: String, inner: Float)
  Error(value: Int, inner: List(Int))
  None
}

fn f0(v1: String, v2: Float) -> Bool {
{
    case fn(v3) { [100] }(False) {
      [6, ..rest] -> 4
      [3] -> 1
      [4, 2, ..] -> 10 - 100
      _ -> 3
    }
  } <= {
    {
      0 - 4
    } % 4
  }
}

fn f1(delete: Int, v4: Int, m: Record) -> Float {
{
    0.1
  } +. {
    {
      1.5
    } -. {
      10.0
    }
  }
}

fn extends(delete: Int) -> String {
{
    let n = "res"
    n
  }
}

pub fn main() {
  echo case k_e {
    _ | 5 -> 0
    6 -> k_e * {
      {
        let prototype = [42]
        1
      }
    }
  }
  echo case [], k_e % 1 {
    [_], 2 -> case k_e {
      3 -> {
        let x = [42]
        let self_ = "x"
        k_e
      }
      constructor -> constructor
    }
    [], 6 -> case Cv0("constructor", 0.5) {
      Error(6, [7, 3, ..]) -> 0 - 7
      Cv0("b" <> rest, 0.1) if rest != "bc" -> fn(v5) { k_e }(42)
      Error(constructor, _) -> constructor - k_e
      _ -> k_e - 100
    }
    [3, ..rest], _ -> case {
        let delete = 0.0
        None
      }, k_e {
      v6, 0 -> 7
      None, v7 if v7 <= 4 -> {
        let k_pi = 1.0
        let class = False
        k_e
      }
      Cv0("res" as whole, 3.14), _ -> k_e + 3
      v8, _ -> k_e
    }
    v9, _ -> 10
  }
  echo 1
}
