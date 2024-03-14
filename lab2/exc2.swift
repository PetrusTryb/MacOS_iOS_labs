//2. Closures
func smartBart(n:Int,closure:()->()){
	for _ in 1...n{
		closure()
	}
}
smartBart(n:11, closure:{print("I will pass this course with best mark, because Swift is great!")})

let numbers = [10, 16, 18, 30, 38, 40, 44, 50]
print(numbers.filter{$0%4 == 0})

print(numbers.reduce(0){max($0, $1)})

var strings = ["Gdansk", "University", "of", "Technology"]
print(strings.reduce(""){$0+$1+" "})

let numbers_2 = [1, 2 ,3 ,4, 5, 6]
let odd_num_sq = numbers_2.filter{$0%2==1}.map{$0*$0}
let odd_num_sq_sum = odd_num_sq.reduce(0){$0+$1}
print("\(odd_num_sq.reduce(""){"\($0)+ \($1) "})-> \(odd_num_sq_sum)")