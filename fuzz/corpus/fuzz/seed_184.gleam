pub const k_seed: Float = 0.1
pub const k_pi: Int = 4
pub const k_e: Bool = False

fn f0(m: String, item: Int, default: Float) -> String {
{
    case <<"":utf8, 4:8>> {
      <<_:big-signed-8, "x":utf8, _:bytes>> -> m
      <<5:16>> -> m
      _ -> "b"
    }
  } <> m
}

pub fn main() {
  let s = "x"
  echo True
}
