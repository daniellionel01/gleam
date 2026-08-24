pub const k_tag: Int = 0

pub type Symbol {
  Record
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(delete: Int, v: Int) -> String {
"" <> "b"
}

pub fn main() {
  echo {
    let y = 10
    let m = 0.0
    case Record {
      Record -> y
      this_ -> {
        let k_tag = m
        y
      }
      Record -> 0
    }
  }
  echo {
    case fn(v0) { k_tag }("ab"), Record {
      _, Record -> False && False
      6, Record -> False
      2, Record -> True
      _, _ -> fn(v1, v2) { v2 }(2.0, False)
    }
  } && True
  echo "b" <> {
    case Record, Record {
      Record, Record -> f0(1, k_tag)
      item, Record -> "ab"
      _, _ -> "abc" <> "bc"
    }
  }
  echo {
    spin(2, 2) - {
      3 - k_tag
    }
  } |> f0(k_tag)
}
