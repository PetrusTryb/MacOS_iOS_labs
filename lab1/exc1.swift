//1. Strings and Text
let a = 21
let b = 37
print("\(a) + \(b) = \(a+b)")

let gut = "Gdansk University of Technology"
var replaced = ""
for char in gut {
  if char != "n" {
    replaced = "\(replaced)\(char)"
  } else {
    replaced = "\(replaced)⭐"
  }
}
print(replaced)

var name = "Piotr Trybisz"
name = String(name.reversed())
print(name)
