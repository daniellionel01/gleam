pub const k_golden: Int = 4
pub const k_tag: Bool = True
pub const k_seed: Float = 100.0

pub type V0 {
  Ok(value: String, inner: Float)
  Cv1(Int, Float)
}

pub type V2 {
  Cv3(value: List(Int))
  Error(Float, List(Int))
  Cv4(String, Bool)
}

fn f0(v5: List(Int), this_: #(Float, Bool)) -> Int {
{
    case 5, 2 {
      9, _ -> {
        let m = 0.1
        4
      }
      7, 2 -> 5 * 4
      _, v6 -> 4 + v6
    }
  } % 7
}

fn f1(v7: String, m: Int, arguments: Bool) -> Bool {
False
}

pub fn main() {
  echo case k_golden, Error(10.0, [100]) {
    9, Cv3([]) -> fn(v8) { 0.1 }(False)
    7, _ -> k_seed
    2, Cv4("abc", True) -> {
      {
        0.5
      } +. k_seed
    } -. {
      {
        let k_tag = 100.0
        10.0
      }
    }
    v9, _ -> case Cv1(42, 0.25), {
        let value = [4, 0]
        "x"
      } {
      v9, "abc" <> rest if rest == "x" && rest != "x" -> {
        let k_golden = 5
        let k_tag = True
        k_seed
      }
      Cv1(_, 0.0), "ab" -> 1.0
      v10, v11 -> 2.0
    }
  }
  echo "b"
}
