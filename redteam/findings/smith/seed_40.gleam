pub type Symbol {
  Record
  Cv0(value: Bool, inner: Bool)
}

fn f0(v1: Bool) -> List(Int) {
[]
}

pub fn main() {
  echo True
  echo case False, [0, 3] {
    True, [4, ..rest] -> False
    _, [6, ..rest] -> {
      "" <> "data"
    } == ""
    _, _ -> case <<"x":utf8>> {
      <<_:utf8>> -> False && True
      _ -> 7 >= 5
    }
  }
}
