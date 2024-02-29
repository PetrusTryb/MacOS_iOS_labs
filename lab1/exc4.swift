//4. Sets
let number = 777
var divisors = Set<Int>()
for n in 1...number {
	if number%n == 0 {
		divisors.insert(n)
	}
}
print("divisors = \(divisors.sorted())")
