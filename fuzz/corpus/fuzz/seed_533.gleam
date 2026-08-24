pub const k_limit: String = ""
pub const k_pi: String = ""
pub const k_seed: Int = 7

pub type V0 {
  Ok(value: String, inner: Float)
  Cv1
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn class(self_: Int, v: String, this_: Bool) -> String {
{
    {
      v <> "res"
    } <> {
      {
        let self_ = [100]
        v
      }
    }
  } <> {
    v <> v
  }
}

fn f1(item: String, z: Int) -> String {
{
    {
      let z = z
      fn(v2) { item }(True)
    }
  } <> "abc"
}

fn extends(v3: Int, delete: Float, self_: Bool) -> String {
"x"
}

pub fn main() {
  echo {
    {
      k_seed - k_seed
    } - {
      k_seed - k_seed
    }
  } - k_seed
}
