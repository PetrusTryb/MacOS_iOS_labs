//3. Tuples
func minmax(a:Int,b:Int) -> (Int,Int) {
	return (min(a,b),max(a,b))
}
print(minmax(a:2137,b:420))

var stringsArray = ["gdansk", "university", "gdansk", "university", "university",
					 "of", "technology", "technology", "gdansk", "gdansk"]
let countedStrings = (Set(stringsArray).map{x in (x,stringsArray.filter{el in el==x}.count)})
print(countedStrings)