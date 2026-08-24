pub const k_e: String = "a"
pub const k_limit: Float = 0.1
pub const k_golden: Bool = False

pub type V0 {
  None(value: String, inner: Float)
  Cv1(value: Bool, inner: String)
}

fn f0(new: Int, v2: Int) -> Int {
{
    let value = case <<"x":utf8>>, "constructor" {
      <<10:8, _:4>>, "ab" -> 1 != new
      <<_:utf8>>, _ -> False
      _, v3 -> True
    }
    let s = {
      let arguments = fn(v4) { 3.14 }(False)
      fn(v5, v6) { True }("res", "")
    }
    case "bc" <> "b", "data" {
      "ab", _ -> new - 5
      "data" <> rest, "ab" <> tail -> v2 % 5
      _, _ -> new
    }
  }
}

pub fn main() {
  echo case None("a", 3.14) {
    Cv1(b, _) if !b || !b -> case [] {
      [0] -> {
        let value = 42
        k_e
      }
      [x, ..rest] as whole if x == 7 -> k_e <> k_e
      [h, ..rest] -> k_e
      v7 -> {
        let k_limit = k_golden
        "data"
      }
    }
    _ -> case k_e {
      delete -> {
        let rest = True
        "a"
      }
      item -> "bc" <> item
    }
    None("b" <> rest, 1.0 as whole) -> {
      fn(v8, v9) { rest }("ab", True)
    } <> {
      k_e <> "constructor"
    }
  }
  echo k_golden
  echo case 1 > 0 {
    _ | True -> case fn(v10, v11) { "abc" }(True, 100.0) {
      "a" -> !True
      "b" <> b -> True || k_golden
      b -> k_golden || k_golden
    }
    _ -> "constructor" == {
      {
        let prototype = 3
        k_e
      }
    }
  }
}
