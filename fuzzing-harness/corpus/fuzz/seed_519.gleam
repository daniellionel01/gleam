pub const k_tag: Float = 0.0
pub const k_pi: Float = 1.0
pub const k_golden: Int = 5

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(constructor: #(Float, List(Int)), z: Float, length: Int) -> Int {
fn(v0) { length * {
    length - v0
  } }(1)
}

pub fn main() {
  let constructor = fn(v1) { {
    let self_ = True
    False
  } }(42)
  echo {
    {
      k_golden + k_golden
    } - {
      k_golden + k_golden
    }
  } * {
    case {
        let x = 100
        let v = k_pi
        v
      }, {
        let self_ = [5]
        let arguments = k_golden
        [4, 10]
      } {
      2.0, [_, ..rest] -> {
        let k_pi = constructor
        2
      }
      _, [2, ..rest] -> walk([5, 0], 1)
      3.14, [] -> walk([5], k_golden)
      v2, v3 -> k_golden + k_golden
    }
  }
}
