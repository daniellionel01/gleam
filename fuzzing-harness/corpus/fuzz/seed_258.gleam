pub const k_limit: Int = 3
pub const k_e: Float = 0.1
pub const k_golden: Bool = False

pub type Record {
  Cv0(value: String, inner: Int)
  Ok(value: String)
  Some
}

fn f0(acc: Bool, x: Bool) -> Int {
7
}

pub fn main() {
  echo {
    {
      fn(v1) { k_e }(True)
    } -. {
      {
        let k_limit = "bc"
        k_e
      }
    }
  } /. {
    0.5
  }
  echo True
  echo !{
    case #(1, "x"), "x" {
      #(_, _) as whole, "constructor" <> rest -> k_golden
      #(6 as whole, v2), length -> k_golden
      #(v3, "abc"), v4 -> k_limit == 10
      v5, _ -> False
    }
  }
}
