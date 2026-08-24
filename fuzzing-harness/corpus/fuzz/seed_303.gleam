pub const k_pi: Float = 2.0
pub const k_e: Int = 0
pub const k_limit: String = "a"

pub type V0 {
  Error(value: String, inner: String)
}

pub type V1 {
  Cv2(Int)
  Cv3(value: Bool, inner: Bool)
  Some(List(Int), value: Float)
}

fn default(arguments: Int, v4: Bool) -> List(Int) {
case fn(v5) { [4, 5] }("res"), "constructor" <> "bc" {
    [9], "b" -> case Cv2(0) {
      Cv3(v6, _) as whole -> [1, 4]
      Cv2(_) -> {
        let arguments = "res"
        let self_ = 100
        [5]
      }
      v7 -> [2, 7]
    }
    [_, _, ..], "ab" <> _ -> [100]
    [_], "bc" as whole -> fn(v8) { [0] }(0.0)
    v9, _ -> fn(v10, v11) { [100] }(False, 0.25)
  }
}

pub fn main() {
  echo case {
      let pair = []
      7
    }, {
      let new = False
      "bc"
    } {
    7, "bc" -> case 4 {
      3 -> [7, 3]
      k_limit -> []
    }
    8 as whole, y if whole <= 2 || whole <= 4 -> [4, 7]
    v12, _ -> case True, Error("a", "x") {
      True as whole, Error("abc" <> rest as it, "bc") -> [42]
      v13, _ -> {
        let s = [100]
        s
      }
    }
  }
  echo case k_e * 3 {
    _ -> case 100 - 2, k_e - k_e {
      _, 8 -> k_pi
      _, k_limit -> fn(v14) { v14 }(2.0)
    }
    b -> {
      {
        0.5
      } +. {
        10.0
      }
    } *. {
      {
        0.1
      } *. {
        1.0
      }
    }
  }
}
