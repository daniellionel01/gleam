pub const k_pi: Int = 7
pub const k_limit: Int = 100
pub const k_golden: Bool = True

pub type Promise {
  Cv0(value: String, inner: String)
  Error(Float, Float)
  Cv1
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v2: Bool) -> Float {
{
    fn(v3, v4) { 0.0 }("res", False)
  } +. {
    case Cv1 {
      constructor -> {
        10.0
      } +. {
        1.5
      }
      Error(v5, _) -> {
        1.0
      } *. {
        2.0
      }
    }
  }
}

fn default(v6: Bool, v7: Int, class: List(Int)) -> Int {
fn(v8, v9) { {
    fn(v10) { class }(True)
  } |> walk(v7 * 10) }("", True)
}

fn f2(class: #(String, List(Int)), v11: Int) -> Int {
fn(v12) { {
    let x = False
    let arguments = 1.0
    v11
  } }("res")
}

pub fn main() {
  let s = {
    2 - k_pi
  } == {
    [] |> walk(k_pi)
  }
  let s = case fn(v13, v14) { Cv0("constructor", "data") }(0.0, False) {
    a -> [5, 100]
    k_limit -> fn(v15) { [] }("ab")
    _ -> []
  }
  echo case [] {
    [9] -> {
      k_golden || k_golden
    } |> f0()
    [] -> 0.25
    [] -> 0.0
    _ -> 0.25
  }
  echo case Cv1 {
    inner -> case <<"b":utf8, 4:8>>, 7 {
      <<4:8, default:8>> as whole, 3 -> "x" <> "b"
      <<"constructor":utf8, "constructor":utf8>>, 6 -> "abc"
      _, 9 -> "x"
      v16, v17 -> "res"
    }
    Cv0("data", "x" <> rest) -> "res"
  }
  echo k_golden
  echo False
}
