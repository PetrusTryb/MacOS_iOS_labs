//1. Functions
func minValue(a:Int,b:Int) -> Int {
	if a<b {
		return a
	}
	else {
		return b
	}
}
print(minValue(a:2,b:1))
print(minValue(a:3,b:7))

func lastDigit(_ n:Int) -> Int {
	return n%10
}
print(lastDigit(193557))

func divides(_ a:Int,_ b:Int) -> Bool {
	return (a%b == 0)
}
print(divides(7, 3))
print(divides(8, 4))

func countDivisors(_ number:Int) -> Int {
	var divisors = 0
	for i in 1...number {
		if divides(number,i) {
			divisors += 1
		}
	}
	return divisors
}
print(countDivisors(1))
print(countDivisors(10))
print(countDivisors(12))

func isPrime(_ number:Int) -> Bool {
	if number<2{
		return false
	}
	return countDivisors(number)==2
}
print(isPrime(3))
print(isPrime(8))
print(isPrime(13))