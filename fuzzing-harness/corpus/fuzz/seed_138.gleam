pub const k_seed: Float = 0.25
pub const k_tag: String = ""

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2(value: String)
}

pub type V3 {
  Cv4(List(Int))
}

fn f0(v5: String) -> Bool {
case <<7:8, "":utf8>> {
    <<"bc":utf8, _:big-signed-8, "abc":utf8>> -> case Cv4([3, 42]) {
      default -> False
      _ -> True || True
    }
    _ -> {
      fn(v6, v7) { False }(4, 1)
    } || {
      {
        let z = 1.0
        let n = v5
        False
      }
    }
  }
}

pub fn main() {
  let v = case k_tag {
    "data" <> rest -> {
      let pair = 42
      3
    }
    "abc" <> rest -> 7
    "" <> rest -> 2
    v8 -> 7
  }
  let k_seed = [5, 5]
  echo {
    {
      let arguments = 1.5
      let z = v - v
      fn(v9) { k_tag }(False)
    }
  } <> {
    case fn(v10) { 10 }(True) {
      inner -> fn(v11) { "" }(4)
      _ -> k_tag
      _ | 5 -> "x"
    }
  }
  echo k_tag
  echo {
    let k_seed = case <<"bc":utf8, "res":utf8, "a":utf8>> {
      <<4:1>> -> v + v
      <<"b":utf8, _:8>> -> 1
      v12 -> {
        let k_tag = k_tag
        let value = 10.0
        v
      }
    }
    case "abc" {
      constructor -> fn(v13) { "bc" }(0.25)
      "abc" -> k_tag <> k_tag
      "res" <> _ -> k_tag <> k_tag
    }
  }
}
