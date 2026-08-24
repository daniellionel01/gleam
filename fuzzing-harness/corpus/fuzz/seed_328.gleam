pub const k_seed: Float = 0.5
pub const k_pi: Float = 0.25
pub const k_tag: Bool = True

pub type V0 {
  Ok(value: String, inner: Float)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn default(self_: Bool) -> String {
{
    case "" <> "b" {
      "a" as whole if whole == "ab" || whole != "a" -> whole
      inner | "bc" <> inner -> fn(v1, v2) { "constructor" }(True, 3)
      _ -> "abc"
    }
  } <> {
    {
      let acc = 0 * 3
      let acc = "constructor"
      "b"
    }
  }
}

pub fn main() {
  let l = 1
  let this_ = case <<100:4, 0:4>>, True {
    <<_:utf8, "constructor":utf8>>, _ -> []
    _, _ -> []
  }
  echo case this_ {
    [a] -> k_seed == {
      {
        1.0
      } -. k_seed
    }
    [_, ..rest] -> {
      {
        let v = k_tag
        False
      }
    } || True
    [2] -> {
      k_pi *. k_seed
    } == k_pi
    v3 -> case l % 7 {
      item -> False
      a -> True
    }
  }
  echo fn(v4, v5) { case v4, this_ {
    4, [3] -> k_seed
    6, [0, ..rest] as whole -> k_pi
    3, [] -> 100.0
    _, v6 -> fn(v7) { 1.5 }(4)
  } }(5, True)
  echo {
    case Ok("ab", 100.0) {
      Ok(_, inner) -> "bc" <> "res"
      Ok(_, 0.0) -> "data"
      Ok("data" as whole, 100.0) -> default(True)
    }
  } <> "a"
  echo case l, {
      let z = True
      let default = []
      True
    } {
    6, True -> {
      10.0
    } /. {
      3.14
    }
    8, False -> k_pi
    _, _ -> k_pi +. {
      fn(v8) { v8 }(2.0)
    }
  }
}
