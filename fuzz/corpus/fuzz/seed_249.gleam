pub const k_tag: Bool = True
pub const k_e: Int = 7

fn f0(m: String) -> Bool {
False
}

pub fn main() {
  let k_tag = k_e
  let k_e = ""
  echo 10.0
  echo {
    case fn(v0, v1) { [3] }(1.5, 0.1), k_e {
      [4, ..rest], "bc" -> k_e
      [3, ..rest], "a" -> k_e
      [a], _ -> {
        let arguments = 4
        k_e
      }
      _, _ -> "data"
    }
  } |> f0()
  echo case False, <<5:8, 7:8>> {
    _, <<"x":utf8, n:16>> -> case n {
      b -> True
      item -> False
      _ | 5 -> False
    }
    _, <<"abc":utf8, _:utf8>> -> case #([100], True), <<"a":utf8>> {
      #([], _), <<"abc":utf8>> -> True
      #([_] as whole, v2) as it, <<_:utf8>> -> {
        let x = k_e
        v2
      }
      v3, _ -> True
    }
    self_, _ -> {
      {
        let delete = k_e
        3.14
      }
    } >=. {
      {
        1.5
      } /. {
        2.0
      }
    }
  }
  echo case k_tag, k_e {
    4, "res" -> 42
    _, "bc" as whole if whole != "data" -> 10
    0 as whole, _ -> whole
    _, v4 -> case 3 - k_tag {
      inner -> 1
      constructor -> constructor + k_tag
      a -> 100
    }
  }
}
