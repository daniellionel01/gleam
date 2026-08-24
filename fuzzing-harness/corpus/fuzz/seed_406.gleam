pub const k_tag: Bool = False
pub const k_e: Bool = True
pub const k_pi: Bool = False

pub type V0 {
  Record(value: String, inner: String)
  Cv1(Float, value: List(Int))
}

pub type Promise {
  Cv2(Bool, value: String)
  Number(value: Int)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(v: #(String, Bool), s: Int, this_: List(Int)) -> List(Int) {
this_
}

fn default(z: V0, item: String) -> Bool {
{
    case {
        let m = 7
        Number(0)
      }, item {
      Cv2(_, _), _ -> {
        let item = False
        item
      }
      _, "data" -> True
      Number(0), "bc" -> True
      _, _ -> False
    }
  } && False
}

pub fn main() {
  let k_pi = [1, 1]
  echo walk(k_pi, fn(v3, v4) { v3 }(3, True)) % 7
  echo case "data" <> "res" {
    "bc" <> constructor | "b" <> constructor -> case 10 {
      _ | 1 -> f0(#("", False), 3, [])
      constructor -> {
        let n = k_pi
        [0, 3]
      }
    }
    "b" <> rest | "b" <> rest -> k_pi
    _ -> case [7] {
      [2, ..rest] as whole -> [4, 42]
      [a, k_tag, ..] -> [100, 2]
      v5 -> k_pi
    }
  }
  echo case k_tag, {
      let new = 1
      let default = "abc"
      5
    } {
    _, _ -> case <<"res":utf8, "a":utf8, "data":utf8>>, Cv1(3.14, [42]) {
      <<"res":utf8>>, _ -> 1.5
      <<"bc":utf8>>, Record("ab" <> rest, "abc") as whole if rest != "abc" -> 0.1
      <<"constructor":utf8>>, k_e -> {
        1.5
      } -. {
        1.5
      }
      _, _ -> {
        0.25
      } +. {
        0.25
      }
    }
    class, 1 if class -> case "" {
      _ | "data" -> 0.0
      "res" -> 100.0
    }
    True, 9 -> {
      {
        3.14
      } /. {
        10.0
      }
    } /. {
      3.14
    }
  }
  echo False
}
