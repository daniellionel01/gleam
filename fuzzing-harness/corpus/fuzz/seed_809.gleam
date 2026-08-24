pub const k_e: String = "x"
pub const k_golden: String = "a"
pub const k_limit: Bool = False

pub type Number {
  Cv0(value: String, inner: Float)
  None
}

pub type Record {
  Cv1(Float, value: String)
  Ok
}

pub type V2 {
  Cv3(Int)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(s: Int, y: Float, x: Int) -> Int {
x
}

pub fn main() {
  let value = case {
      let k_limit = 0.25
      let m = 10.0
      #([10, 4], "constructor")
    } {
    #([_], value) if value == "abc" -> {
      1.5
    } <. {
      3.14
    }
    #([5, ..rest], "abc") -> {
      0.25
    } != {
      0.0
    }
    _ -> {
      0.1
    } >=. {
      10.0
    }
  }
  let n = 10 + 2
  echo case k_e, n |> f0({
      let length = False
      let s = 100.0
      s
    }, {
      let acc = n
      let n = 3.14
      42
    }) {
    _, 9 -> case k_e <> "abc" {
      "b" -> k_limit
      "abc" <> rest | "x" <> rest -> fn(v4) { value }(False)
      constructor | "x" <> constructor -> n < n
    }
    "bc", _ -> value
    "x" <> rest, 7 -> False
    _, v5 -> {
      let n = n
      {
        let k_limit = 0.5
        value
      }
    }
  }
  echo {
    case Ok, "b" {
      pair, "a" <> rest if rest != "a" || rest == "a" -> k_e
      Ok as whole, "a" -> "bc" <> k_golden
      Ok, v6 -> k_e <> k_golden
      _, _ -> "b"
    }
  } <> "bc"
  echo k_e <> {
    case <<"a":utf8>>, "x" {
      <<"data":utf8>>, _ -> "abc"
      <<3:16>>, "data" -> k_golden <> k_golden
      <<_:utf8>>, "bc" -> k_golden
      v7, _ -> fn(v8, v9) { k_golden }(7, False)
    }
  }
}
