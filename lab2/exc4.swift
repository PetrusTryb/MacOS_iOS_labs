//4. Enums
enum Day: Int{
	case Monday = 1
	case Tuesday
	case Wednesday
	case Thursday
	case Friday
	case Saturday
	case Sunday
	func emoji()->String{
		switch self{
			case .Monday: return "🗿"
			case .Tuesday: return "🐜"
			case .Wednesday: return "🪓"
			case .Thursday: return "👽"
			case .Friday: return "👻"
			case .Saturday: return "🍺"
			case .Sunday: return "🍕"
		}
	}
}

for day in 1...7{
	print(Day(rawValue: day)!, Day(rawValue: day)!.emoji())
}