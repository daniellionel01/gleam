pub const k_golden: Int = 4
pub const k_tag: String = "b"

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn constructor(this_: Float) -> List(Int) {
[100, 4]
}

fn class(v0: String, n: List(Int), class: List(Int)) -> Bool {
case fn(v1) { n }("data") {
    [_] -> True
    [h] -> case False, v0 <> "res" {
      _, "ab" -> False
      v2, "res" -> {
        let h = n
        False
      }
      default, "res" <> rest -> True
      _, _ -> False
    }
    v3 -> True
  }
}

pub fn main() {
  let k_golden = case {
      let k_tag = 0.25
      0.0
    }, <<"x":utf8>> {
    1.0, <<"ab":utf8>> as whole -> {
      let new = 100.0
      let v = []
      k_golden
    }
    _, _ -> k_golden
  }
  echo k_golden
  echo [10]
  echo {
    {
      10.0
    } +. {
      {
        0.1
      } +. {
        3.14
      }
    }
  } -. {
    case {
        100.0
      } == {
        0.1
      } {
      False -> {
        let length = k_tag
        let k_golden = k_golden
        2.0
      }
      item -> {
        2.0
      } -. {
        2.0
      }
    }
  }
}
