pub const k_golden: Bool = False
pub const k_tag: Bool = False

pub type Promise {
  Cv0(value: String, inner: String)
  Cv1(Float, String)
  Cv2(value: String)
}

fn f0(z: Bool, arguments: Float) -> Float {
{
    {
      {
        100.0
      } -. {
        100.0
      }
    } -. arguments
  } /. {
    10.0
  }
}

fn default(z: String, v3: Promise) -> Float {
0.1
}

fn f2(v4: String, arguments: Int) -> List(Int) {
[3, 2]
}

pub fn main() {
  let l = k_tag
  let pair = "data" <> {
    fn(v5) { "bc" }(0.25)
  }
  echo True
  echo {
    let delete = [7, 10]
    let k_tag = case 3 {
      _ -> k_tag
      a -> pair == pair
    }
    case "data" <> "constructor", "constructor" <> "x" {
      _, _ -> pair |> f2(0 - 10)
      "res" <> _, "a" as whole -> f2("abc", 0)
    }
  }
}
