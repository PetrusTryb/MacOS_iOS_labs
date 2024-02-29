//3. Arrays
var numbers = [5, 10, 20, 15, 80, 13]
var result = 0
for n in numbers {
	result = max(n,result)
}
print(result)

print(Array(numbers.reversed()))

var allNumbers = [10, 20, 10, 11, 13, 20, 10, 30]
var unique = [Int]()

for n in allNumbers{
	if !unique.contains(n) {
		unique.append(n)
	}
}
print("unique = \(unique)")
