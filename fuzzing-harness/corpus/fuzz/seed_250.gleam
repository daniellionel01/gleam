pub const k_golden: String = "x"
pub const k_limit: Bool = False
pub const k_tag: Float = 10.0

fn f0(m: String) -> List(Int) {
case 7 < 1 {
    True | True -> [100, 5]
    inner -> [42, 1]
  }
}

fn f1(v0: String, pair: Int) -> Int {
case pair - 7 {
    v1 -> 5
    _ -> 0
  }
}

fn f2(v2: List(Int), new: Int, v3: Bool) -> Bool {
v3
}

pub fn main() {
  let k_golden = case 10 {
    _ -> [3, 2]
    9 | 5 -> {
      let default = False
      []
    }
    inner -> [1, 7]
  }
  let item = "data"
  echo case {
      let constructor = 10
      False
    } {
    False -> case True {
      inner -> {
        let arguments = []
        k_golden
      }
      True | True -> [2]
      inner -> k_golden
    }
    inner -> case 10.0, item <> item {
      2.0, "res" -> k_golden
      v4, "abc" <> rest -> "x" |> f0()
      _, v5 -> [10, 3]
    }
  }
  echo True
}
