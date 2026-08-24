pub const k_seed: Int = 5
pub const k_limit: Bool = False
pub const k_golden: Int = 0

pub type V0 {
  Ok(value: String, inner: Float)
  Cv1(Bool, value: List(Int))
  Cv2
}

pub type Object {
  Some
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(delete: Int) -> String {
{
    let delete = case {
        let delete = delete
        Some
      } {
      Some | Some -> False
      Some -> {
        3.14
      } <=. {
        2.0
      }
    }
    "b" <> "abc"
  }
}

pub fn main() {
  let m = k_limit
  echo case {
      let s = k_golden
      let s = ""
      k_limit
    } {
    _ -> spin(fn(v3) { k_seed }("x"), spin(k_seed, 5))
    True | True -> {
      let k_limit = "ab"
      k_seed
    }
  }
  echo "data"
}
