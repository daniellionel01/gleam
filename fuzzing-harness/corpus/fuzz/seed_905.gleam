pub const k_tag: Bool = True
pub const k_pi: Float = 10.0
pub const k_limit: Bool = True

pub type V0 {
  Cv1(value: List(Int), inner: Int)
}

pub type Object {
  None(Bool)
}

pub type V2 {
  Cv3(List(Int), Int)
  Cv4(value: Int)
  Cv5(String)
}

fn walk(xs: List(Int), acc: Int) -> Int {
  case xs {
    [] -> acc
    [x, ..rest] -> walk(rest, acc + x)
  }
}

fn f0(class: String, v6: Int) -> Int {
case fn(v7, v8) { Cv3([2], 2) }("x", 1.0) {
    item -> 3
    inner -> 42
  }
}

fn f1(prototype: #(Bool, Int), constructor: #(String, Float)) -> Bool {
False
}

fn f2(this_: Int, z: #(Float, Float)) -> Int {
10
}

pub fn main() {
  echo "bc"
}
