pub const k_limit: String = "abc"

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

fn static(item: Bool, acc: Bool) -> Bool {
False
}

pub fn main() {
  let delete = {
    fn(v3) { 100 }("ab")
  } - {
    {
      let k_limit = 1
      let k_limit = False
      3
    }
  }
  echo case {
      1.5
    } +. {
      1.0
    } {
    inner -> [10, 100]
    inner -> fn(v4) { [] }(True)
  }
}
