pub const k_limit: Bool = True
pub const k_seed: Float = 0.5

fn f0(m: String) -> Float {
case 42 % 5 {
    _ -> fn(v0, v1) { v0 -. v0 }(0.0, False)
    2 -> {
      fn(v2) { v2 }(0.1)
    } -. {
      1.5
    }
  }
}

pub fn main() {
  let k_limit = 2.0
  echo True
  echo {
    {
      "a" <> "res"
    } <> {
      "constructor" <> "b"
    }
  } <> {
    case 5 - 7 {
      arguments -> "constructor"
      v3 -> "constructor" <> "abc"
    }
  }
  echo {
    case "a", {
        let arguments = True
        [5, 7]
      } {
      "bc", [k_limit] if k_limit > 1 -> 5 + 4
      _, [] -> 42
      _, _ -> 3 + 0
    }
  } * 10
}
