pub const k_pi: String = "bc"
pub const k_golden: String = "ab"

pub type Map {
  Cv0(value: String, inner: List(Int))
  Cv1(Bool, Int)
}

fn f0(v2: Int) -> Bool {
{
    case "" <> "" {
      constructor -> {
        1.5
      } *. {
        1.5
      }
      "a" <> inner | "constructor" <> inner -> {
        0.5
      } -. {
        0.5
      }
      constructor -> 3.14
    }
  } == {
    0.5
  }
}

pub fn main() {
  let value = case [3, 3], [0, 2] {
    [_, 6, ..], [5] -> []
    [], [b, _, ..] as whole -> whole
    [constructor, 5, ..], [] as whole -> {
      let new = 3.14
      let k_pi = False
      [7, 4]
    }
    v3, _ -> [2, 1]
  }
  echo False
  echo fn(v4) { {
    "bc" <> "ab"
  } <> {
    fn(v5, v6) { k_pi }(3, False)
  } }(1)
  echo True
}
