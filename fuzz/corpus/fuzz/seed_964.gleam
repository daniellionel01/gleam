pub const k_tag: Int = 42
pub const k_seed: String = "constructor"
pub const k_e: Bool = True

fn f0(m: String, class: #(Int, List(Int))) -> Int {
7
}

fn f1(acc: Bool) -> Float {
{
    {
      0.5
    } *. {
      {
        2.0
      } -. {
        0.0
      }
    }
  } +. {
    case {
        let y = 0.0
        let acc = acc
        "ab"
      } {
      "bc" -> 1.0
      constructor -> 100.0
      "" <> constructor -> {
        let n = 1
        3.14
      }
    }
  }
}

pub fn main() {
  let v = f0("ab", #(0, []))
  echo {
    0.5
  } -. f1(10 > k_tag)
}
