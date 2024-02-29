//5. Dictionaries
var flights: [[String: String]] = [
    [
        "flightNumber" : "AA8025",
        "destination" : "Copenhagen"
    ],
    [
        "flightNumber" : "BA1442",
        "destination" : "New York"
    ],
    [
        "flightNumber" : "BD6741",
        "destination" : "Barcelona"
    ]
]

var flightNumbers = [String]()
for f in flights {
	flightNumbers.append(f["flightNumber"]!)
}
print("flightNumbers = \(flightNumbers)")

var names = ["Hommer","Lisa","Bart"]
let lastName = "Simpson"
var fullName = [[String: String]]()
for n in names {
	fullName.append(["firstName":n, "lastName":lastName])
}
print("fullName = \(fullName)")
