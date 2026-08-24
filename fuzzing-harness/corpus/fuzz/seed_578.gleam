pub const k_limit: String = "data"
pub const k_e: String = "abc"
pub const k_tag: Int = 100

fn f0(m: String) -> List(Int) {
[]
}

fn f1(m: Bool, v0: Float, v1: Int) -> List(Int) {
[]
}

pub fn main() {
  let k_e = {
    let default = "x"
    let item = 5
    [7]
  }
  echo f1(case {
      let arguments = k_limit
      #(42, False)
    }, "x" {
    #(1, _) as whole, "data" -> True
    #(0, acc), "ab" <> rest if !acc -> True
    #(7, v2) as whole, "bc" <> _ -> True || v2
    _, _ -> True
  }, {
    {
      0.0
    } +. {
      0.5
    }
  } /. {
    3.14
  }, case {
      let v = True
      #("res", True)
    }, {
      let k_limit = 0.5
      k_tag
    } {
    #(_, False), k_tag -> k_tag
    #("constructor" <> rest as whole, _), _ -> k_tag
    _, _ -> k_tag + k_tag
  })
  echo fn(v3) { {
    let k_limit = 1
    v3 *. {
      0.0
    }
  } }(0.0)
}
