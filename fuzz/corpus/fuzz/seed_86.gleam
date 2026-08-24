pub const k_tag: String = "res"
pub const k_pi: String = "res"
pub const k_seed: Float = 100.0

fn f0(m: String, value: Int) -> List(Int) {
[]
}

fn export(v0: Bool, v: Bool) -> Bool {
fn(v1, v2) { case "b" {
    _ -> False
    "bc" -> fn(v3) { True }(100)
    b -> v2
  } }("x", True)
}

pub fn main() {
  let y = {
    fn(v4, v5) { 4 }("ab", True)
  } + {
    {
      let x = 100
      let s = "a"
      x
    }
  }
  let m = k_seed +. {
    k_seed +. k_seed
  }
  echo case k_tag {
    "ab" | "res" -> [5]
    "data" -> [10, 1]
    "a" <> rest -> [42]
    v6 -> f0(v6 <> k_tag, y)
  }
  echo case [], <<1:16, 100:4>> {
    [_], <<arguments:little-unsigned-8, 3:16>> -> {
      0.5
    } +. {
      fn(v7, v8) { 2.0 }(0.1, False)
    }
    [k_seed, ..rest], _ -> case <<10:16>> {
      <<42:1, _:utf8>> -> 0.1
      _ -> m -. m
    }
    _, v9 -> case 7 - 1 {
      5 -> {
        let this_ = True
        let constructor = k_tag
        k_seed
      }
      _ -> {
        let pair = True
        2.0
      }
    }
  }
}
