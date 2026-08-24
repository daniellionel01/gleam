pub const k_pi: Bool = False
pub const k_golden: Int = 3

pub type V0 {
  Cv1
  Cv2
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(acc: V0, v3: Bool) -> Float {
1.0
}

fn f1(v: Int, v4: Bool, v5: String) -> Bool {
v4
}

pub fn main() {
  let k_pi = case k_pi {
    a -> [3]
    inner -> [3, 1]
  }
  echo walk(case Cv2, {
      let pair = k_golden
      let pair = "bc"
      "abc"
    } {
    Cv2 as whole, "constructor" -> []
    Cv1, "ab" -> k_pi
    _, _ -> k_pi
  }, {
    {
      let prototype = True
      let prototype = k_golden
      k_golden
    }
  } - {
    {
      let z = [100, 4]
      k_golden
    }
  })
  echo True
}
