pub type V0 {
  Cv1(value: List(Int))
  Cv2(value: String)
  Cv3(Bool, value: Int)
}

pub type Promise {
  Cv4(value: Int)
  Cv5(String)
}

fn constructor(constructor: Bool, v6: List(Int)) -> Bool {
False
}

fn f1(v7: Int, v8: String) -> Int {
case <<"bc":utf8, "constructor":utf8>> {
    <<_:utf8>> -> 3
    _ -> case v7 * 4 {
      3 | 9 -> 100 + 42
      item -> 100
    }
  }
}

fn f2(v9: Int, v10: V0, class: Int) -> Bool {
{
    False || {
      "ab" == "abc"
    }
  } && {
    !{
      "abc" != "data"
    }
  }
}

pub fn main() {
  let new = [3]
  echo new
  echo new
  echo case <<"b":utf8>> {
    <<"":utf8, 5:8>> -> ""
    <<_:16, _:utf8>> -> "res"
    _ -> case True {
      False -> "b"
      True as whole -> "data"
      _ -> "bc"
    }
  }
}
