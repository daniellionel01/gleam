pub const k_golden: Bool = False
pub const k_e: Int = 1

pub type V0 {
  Cv1(value: List(Int))
  Cv2(Bool)
  Cv3(value: String, inner: Int)
}

fn static(v4: #(Float, List(Int)), n: #(Bool, List(Int))) -> Bool {
False
}

pub fn main() {
  let default = {
    {
      1.0
    } +. {
      0.25
    }
  } *. {
    3.14
  }
  let class = static({
    let l = [10]
    #(2.0, [])
  }, #(False, [100, 3]))
  echo {
    2.0
  } <=. {
    {
      let y = []
      let v = 0.5
      0.0
    }
  }
  echo case "b" <> "b" {
    "abc" | "constructor" -> case {
        let x = k_e
        let new = "res"
        new
      }, "res" {
      "constructor", "data" <> rest if rest == "data" -> rest <> "ab"
      _, "" <> rest -> {
        let default = 0
        let default = rest
        rest
      }
      _, _ -> "x" <> "b"
    }
    a -> "abc" <> {
      {
        let k_golden = [10, 0]
        let k_e = a
        a
      }
    }
  }
  echo {
    k_e % 1
  } != {
    k_e + 42
  }
}
