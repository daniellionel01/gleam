pub const k_pi: Int = 100
pub const k_limit: Bool = False
pub const k_e: Int = 10

fn f0(m: String, this_: Float, v0: Int) -> List(Int) {
[4]
}

fn f1(v1: Int, v2: Bool, length: #(Float, Float)) -> Float {
{
    case <<100:8>> {
      <<0:16>> -> {
        10.0
      } *. {
        1.0
      }
      _ -> 3.14
    }
  } +. {
    1.0
  }
}

fn f2(class: Bool, arguments: Float, v3: Float) -> Int {
2 - {
    2 - 5
  }
}

pub fn main() {
  let k_e = False
  let arguments = k_e
  echo f0(case "constructor" <> "abc" {
    "a" -> "res"
    "a" <> inner | "ab" <> inner -> "b" <> "b"
    "b" <> rest | "abc" <> rest -> "abc"
    v4 -> "bc"
  }, f1(fn(v5) { k_pi }("data"), {
    let k_pi = True
    let v = "a"
    arguments
  }, #(2.0, 3.14)), 0)
  echo case 10.0 {
    a -> k_e || {
      k_limit && k_e
    }
    k_limit -> case [] {
      [k_e] -> k_limit != {
        0.25
      }
      [] -> "" == "data"
      v6 -> k_pi > 4
    }
  }
  echo 5
}
