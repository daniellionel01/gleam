pub const k_golden: String = "res"
pub const k_pi: Int = 42

pub type V0 {
  Cv1(value: List(Int), inner: Int)
  Cv2
}

pub type Promise {
  Cv3(value: Float)
  Cv4(Int)
  Cv5
}

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(pair: Int, delete: Float) -> Int {
pair
}

fn f1(v6: Float, item: Int) -> Bool {
True
}

pub fn main() {
  let this_ = False
  echo case this_, 100 + k_pi {
    True, 9 as whole -> {
      let default = {
        0.0
      } -. {
        0.5
      }
      this_
    }
    True, 5 -> True
    _, v7 -> {
      {
        let length = [42]
        let l = this_
        "ab"
      }
    } != {
      {
        let l = 1.0
        k_golden
      }
    }
  }
  echo []
  echo case <<5:1, "":utf8>> {
    <<_:big-unsigned-8, _:utf8>> -> {
      fn(v8, v9) { "res" }("a", "res")
    } == "ab"
    _ -> case "a" <> k_golden, {
        let new = 42
        let arguments = new
        []
      } {
      _, [5, 5, ..] -> {
        0.0
      } <=. {
        0.1
      }
      _, [3, 5, ..] -> 4 != k_pi
      "ab" as whole, [h, ..rest] -> this_
      _, v10 -> "data" == k_golden
    }
  }
}
