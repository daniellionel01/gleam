pub const k_tag: Float = 1.5
pub const k_seed: Int = 1

fn spin(n: Int, acc: Int) -> Int {
  case n <= 0 {
    True -> acc
    False -> spin(n - 1, acc + n)
  }
}

fn f0(constructor: List(Int), acc: List(Int), pair: Float) -> Bool {
{
    {
      4 - 4
    } * 10
  } > {
    case <<2:8>> {
      <<"data":utf8>> as whole -> 42
      <<"abc":utf8>> -> 2 * 1
      _ -> 7 |> spin(100 - 0)
    }
  }
}

pub fn main() {
  let self_ = [10]
  echo k_tag
  echo k_seed
  echo fn(v0) { k_tag }(5)
}
