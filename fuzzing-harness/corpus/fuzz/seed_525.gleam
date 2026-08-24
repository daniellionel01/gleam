pub const k_e: String = "res"

pub type V0 {
  Some(value: String, inner: Float)
  Cv1(Float)
  Error
}

fn f0(v2: Int, v3: List(Int)) -> Bool {
case Some("abc", 1.5) {
    _ -> case "x" <> "data" {
      "res" -> False
      "res" <> rest | "" <> rest -> True
      "res" <> rest | "abc" <> rest -> True
      _ -> False
    }
    Cv1(0.5) -> {
      v2 * v2
    } <= {
      fn(v4, v5) { 10 }(False, 1)
    }
    Some(_, v6) -> v6 <=. {
      1.5
    }
  }
}

fn new(v7: V0, v8: String) -> String {
{
    {
      "a" <> v8
    } <> v8
  } <> v8
}

pub fn main() {
  let self_ = {
    let delete = "x"
    let delete = []
    k_e
  }
  let self_ = {
    {
      let self_ = k_e
      1.0
    }
  } -. {
    {
      let v = k_e
      let n = True
      1.0
    }
  }
  echo 7
}
