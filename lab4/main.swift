import Foundation

struct Coords {
	var latitude: Double
	var longitude: Double
	
	init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
}

class City {
	var id: Int
	var name: String
	var description: String
	var coordinates: Coords
	var tags: [String]

	init(id: Int, name: String, description: String, latitude: Double, longitude: Double, tags: [String]) {
		self.id = id
		self.name = name
		self.description = description
		self.coordinates = Coords(latitude: latitude, longitude: longitude)
		self.tags = tags
	}

	func toString() -> String {
		return "City(id: \(id), name: \(name), description: \(description), latitude: \(coordinates.latitude), longitude: \(coordinates.longitude), tags: \(tags))"
	}
}

let cities = [
	City(id: 1, name: "Warsaw", description: "Capital of Poland", latitude: 52.2297, longitude: 21.0122, tags: ["party", "music"]),
	City(id: 2, name: "Krakow", description: "Poland's cultural capital", latitude: 50.0647, longitude: 19.9450, tags: ["music", "nature"]),
	City(id: 3, name: "Gdansk", description: "Pearl of the Baltic", latitude: 54.3520, longitude: 18.6466, tags: ["seaside", "party"]),
	City(id: 4, name: "Wroclaw", description: "City of cultural meetings", latitude: 51.1079, longitude: 17.0385, tags: ["party", "music"]),
	City(id: 5, name: "Poznan", description: "Capital of Greater Poland", latitude: 52.4064, longitude: 16.9252, tags: ["party", "nature"]),
	City(id: 6, name: "Lodz", description: "City of factories", latitude: 51.7592, longitude: 19.4554, tags: ["music", "party"]),
	City(id: 7, name: "Szczecin", description: "City on islands", latitude: 53.4285, longitude: 14.5528, tags: ["seaside", "nature"]),
	City(id: 8, name: "Bydgoszcz", description: "City on the Brda River", latitude: 53.1235, longitude: 18.0084, tags: ["nature"]),
	City(id: 9, name: "Lublin", description: "Capital of Eastern Culture", latitude: 51.2465, longitude: 22.5684, tags: ["nature", "party"]),
	City(id: 10, name: "Katowice", description: "Capital of Upper Silesia", latitude: 50.2649, longitude: 19.0238, tags: ["music", "party"]),
	City(id: 11, name: "Bialystok", description: "City of the Podlasie region", latitude: 53.1325, longitude: 23.1688, tags: ["nature", "music"]),
	City(id: 12, name: "Torun", description: "City of Nicolaus Copernicus", latitude: 53.0138, longitude: 18.5984, tags: ["music", "party"]),
	City(id: 13, name: "Kielce", description: "City of the Holy Cross", latitude: 50.8661, longitude: 20.6286, tags: ["nature", "music"]),
	City(id: 14, name: "Olsztyn", description: "City of the Warmian-Masurian Voivodeship", latitude: 53.7784, longitude: 20.4801, tags: ["nature", "seaside"]),
	City(id: 15, name: "Opole", description: "City of the Opole Voivodeship", latitude: 50.6756, longitude: 17.9213, tags: ["music", "party"]),
	City(id: 16, name: "Rzeszow", description: "City of the Subcarpathian Voivodeship", latitude: 50.0413, longitude: 21.9991, tags: ["nature", "party"]),
	City(id: 17, name: "Gdynia", description: "City of the Tri-City", latitude: 54.5189, longitude: 18.5305, tags: ["seaside", "party"]),
	City(id: 18, name: "Czestochowa", description: "City of the Jasna Gora Monastery", latitude: 50.8110, longitude: 19.1200, tags: ["music", "nature"]),
	City(id: 19, name: "Sopot", description: "City of the Tri-City", latitude: 54.4416, longitude: 18.5600, tags: ["seaside", "party"]),
	City(id: 20, name: "Radom", description: "City of the Masovian Voivodeship", latitude: 51.4026, longitude: 21.1471, tags: ["music", "party"])
]


func findCitiesByName(_ name: String) -> [City] {
	return cities.filter { $0.name.contains(name) }
}

print("Warszawa: ")
findCitiesByName("Warsaw").forEach { print($0.toString()) }

func findCitiesByTag(_ tag: String) -> [City] {
	return cities.filter { $0.tags.contains(tag) }
}

print("\nMiasta z tagiem 'music': ")
findCitiesByTag("music").forEach { print($0.toString()) }

func calculateDistance(_ city1: City, _ city2: City) -> Double {
	let R = 6371.0
	let lat1 = city1.coordinates.latitude * Double.pi / 180.0
	let lon1 = city1.coordinates.longitude * Double.pi / 180.0
	let lat2 = city2.coordinates.latitude * Double.pi / 180.0
	let lon2 = city2.coordinates.longitude * Double.pi / 180.0
	let dLat = lat2 - lat1
	let dLon = lon2 - lon1
	let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)
	let c = 2 * atan2(sqrt(a), sqrt(1 - a))
	return round(R * c * 1000.0) / 1000.0
}

func calculateDistance(_ city: City, _ coords: Coords) -> Double {
	return calculateDistance(city, City(id: 0, name: "", description: "", latitude: coords.latitude, longitude: coords.longitude, tags: []))
}

print("\nOdległość Gdańsk-Warszawa: \(calculateDistance(findCitiesByName("Gdansk")[0], findCitiesByName("Warsaw")[0])) km\n")

func findClosestAndFarthestCities(_ coordinates: Coords) -> (City, City) {
	var closest: City? = nil
	var farthest: City? = nil
	var minDistance = Double.infinity
	var maxDistance = 0.0
	for city in cities {
		let distance = calculateDistance(city, coordinates)
		if distance < minDistance && distance != 0 {
			minDistance = distance
			closest = city
		}
		if distance > maxDistance {
			maxDistance = distance
			farthest = city
		}
	}
	return (closest!, farthest!)
}

let (closest, farthest) = findClosestAndFarthestCities(findCitiesByName("Gdansk")[0].coordinates)
print("Najbliżej z Gdańska: \(closest.toString())")
print("Najdalej z Gdańska: \(farthest.toString())\n")

func findTwoFarthestCities() -> (City, City) {
	var farthest1: City? = nil
	var farthest2: City? = nil
	var maxDistance = 0.0
	for i in 0..<cities.count {
		for j in i+1..<cities.count {
			let distance = calculateDistance(cities[i], cities[j])
			if distance > maxDistance {
				maxDistance = distance
				farthest1 = cities[i]
				farthest2 = cities[j]
			}
		}
	}
	return (farthest1!, farthest2!)
}

let (farthest1, farthest2) = findTwoFarthestCities()
print("Najbardziej oddalone od siebie miasta: \(farthest1.toString()), \(farthest2.toString())\n")

enum Rating: Int {
	case awful = 1
	case bad = 2
	case average = 3
	case good = 4
	case excellent = 5
}

struct Location {
	var id: Int
	var type: String
	var name: String
	var coords: Coords
	var rating: Rating

	init(id: Int, type: String, name: String, latitude: Double, longitude: Double, rating: Rating) {
		self.id = id
		self.type = type
		self.name = name
		self.coords = Coords(latitude: latitude, longitude: longitude)
		self.rating = rating
	}

	func toString() -> String {
		return "Location(id: \(id), type: \(type), name: \(name), latitude: \(coords.latitude), longitude: \(coords.longitude), rating: \(rating.rawValue))"
	}
}

class CityLocations {
	var relatedCity: City
	var locations: [Location]

	init(relatedCity: City, locations: [Location]) {
		self.relatedCity = relatedCity
		self.locations = locations
	}

	func toString() -> String {
		return "CityLocations(relatedCity: \(relatedCity.toString()), locations: [\(locations.map { $0.toString() }.joined(separator: ", "))])"
	}
}

let citiesWithLocations = [
	CityLocations(relatedCity: cities[0], locations: [
		Location(id: 1, type: "restaurant", name: "U Fukiera", latitude: 52.2297, longitude: 21.0122, rating: .good),
		Location(id: 2, type: "restaurant", name: "Restauracja Polska Rozana", latitude: 52.2297, longitude: 21.0122, rating: .excellent),
		Location(id: 3, type: "museum", name: "Warsaw Uprising Museum", latitude: 52.2297, longitude: 21.0122, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[1], locations: [
		Location(id: 4, type: "restaurant", name: "Pod Wawelem", latitude: 50.0647, longitude: 19.9450, rating: .good),
		Location(id: 5, type: "restaurant", name: "Miod Malina", latitude: 50.0647, longitude: 19.9450, rating: .excellent),
		Location(id: 6, type: "museum", name: "Wawel Royal Castle", latitude: 50.0647, longitude: 19.9450, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[2], locations: [
		Location(id: 7, type: "restaurant", name: "Restauracja Mandu", latitude: 54.3520, longitude: 18.6466, rating: .good),
		Location(id: 8, type: "restaurant", name: "Armata do Chlania", latitude: 54.3693, longitude: 18.6044, rating: .excellent),
		Location(id: 9, type: "museum", name: "European Solidarity Centre", latitude: 54.3520, longitude: 18.6466, rating: .average)
	]),
	CityLocations(relatedCity: cities[3], locations: [
		Location(id: 10, type: "restaurant", name: "Pod Fredra", latitude: 51.1079, longitude: 17.0385, rating: .good),
		Location(id: 11, type: "restaurant", name: "Vincent", latitude: 51.1079, longitude: 17.0385, rating: .excellent),
		Location(id: 12, type: "museum", name: "Panorama Racławicka", latitude: 51.1079, longitude: 17.0385, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[4], locations: [
		Location(id: 13, type: "restaurant", name: "Ratuszova", latitude: 52.4064, longitude: 16.9252, rating: .good),
		Location(id: 14, type: "restaurant", name: "Bamberka", latitude: 52.4064, longitude: 16.9252, rating: .excellent),
		Location(id: 15, type: "museum", name: "Poznan Croissant Museum", latitude: 52.4064, longitude: 16.9252, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[5], locations: [
		Location(id: 16, type: "restaurant", name: "Manekin", latitude: 51.7592, longitude: 19.4554, rating: .good),
		Location(id: 17, type: "restaurant", name: "Pierogarnia Stary Młyn", latitude: 51.7592, longitude: 19.4554, rating: .excellent),
		Location(id: 18, type: "museum", name: "Museum of Art", latitude: 51.7592, longitude: 19.4554, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[6], locations: [
		Location(id: 19, type: "restaurant", name: "Karczma Polska", latitude: 53.4285, longitude: 14.5528, rating: .good),
		Location(id: 20, type: "restaurant", name: "Karczma Rybna", latitude: 53.4285, longitude: 14.5528, rating: .excellent),
		Location(id: 21, type: "museum", name: "National Museum", latitude: 53.4285, longitude: 14.5528, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[7], locations: [
		Location(id: 22, type: "restaurant", name: "Pod Orlem", latitude: 53.1235, longitude: 18.0084, rating: .good),
		Location(id: 23, type: "restaurant", name: "Karczma Rzym", latitude: 53.1235, longitude: 18.0084, rating: .excellent),
		Location(id: 24, type: "museum", name: "Museum of Soap and History of Dirt", latitude: 53.1235, longitude: 18.0084, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[8], locations: [
		Location(id: 25, type: "restaurant", name: "Kuchnia Staropolska", latitude: 51.2465, longitude: 22.5684, rating: .good),
		Location(id: 26, type: "restaurant", name: "Karczma Lubelska", latitude: 51.2465, longitude: 22.5684, rating: .excellent),
		Location(id: 27, type: "museum", name: "Majdanek Concentration Camp", latitude: 51.2465, longitude: 22.5684, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[9], locations: [
		Location(id: 28, type: "restaurant", name: "Karczma Staropolska", latitude: 50.2649, longitude: 19.0238, rating: .good),
		Location(id: 29, type: "restaurant", name: "Karczma Rzym", latitude: 50.2649, longitude: 19.0238, rating: .excellent),
		Location(id: 30, type: "museum", name: "Silesian Museum", latitude: 50.2649, longitude: 19.0238, rating: .bad)
	]),
	CityLocations(relatedCity: cities[10], locations: [
		Location(id: 31, type: "restaurant", name: "Karczma Staropolska", latitude: 53.1325, longitude: 23.1688, rating: .good),
		Location(id: 32, type: "restaurant", name: "Karczma Rzym", latitude: 53.1325, longitude: 23.1688, rating: .average),
		Location(id: 33, type: "museum", name: "Podlasie Museum", latitude: 53.1325, longitude: 23.1688, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[11], locations: [
		Location(id: 34, type: "restaurant", name: "Karczma Staropolska", latitude: 53.0138, longitude: 18.5984, rating: .good),
		Location(id: 35, type: "restaurant", name: "Karczma Rzym", latitude: 53.0138, longitude: 18.5984, rating: .bad),
		Location(id: 36, type: "museum", name: "Nicolaus Copernicus Museum", latitude: 53.0138, longitude: 18.5984, rating: .average)
	]),
	CityLocations(relatedCity: cities[12], locations: [
		Location(id: 37, type: "restaurant", name: "Karczma Staropolska", latitude: 50.8661, longitude: 20.6286, rating: .good),
		Location(id: 38, type: "restaurant", name: "Karczma Rzym", latitude: 50.8661, longitude: 20.6286, rating: .excellent),
		Location(id: 39, type: "museum", name: "Holy Cross Cathedral", latitude: 50.8661, longitude: 20.6286, rating: .good)
	]),
	CityLocations(relatedCity: cities[13], locations: [
		Location(id: 40, type: "restaurant", name: "Karczma Staropolska", latitude: 53.7784, longitude: 20.4801, rating: .good),
		Location(id: 41, type: "restaurant", name: "Karczma Rzym", latitude: 53.7784, longitude: 20.4801, rating: .excellent),
		Location(id: 42, type: "museum", name: "Warmia and Masuria Museum", latitude: 53.7784, longitude: 20.4801, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[14], locations: [
		Location(id: 43, type: "restaurant", name: "Karczma Staropolska", latitude: 50.6756, longitude: 17.9213, rating: .good),
		Location(id: 44, type: "restaurant", name: "Karczma Rzym", latitude: 50.6756, longitude: 17.9213, rating: .bad),
		Location(id: 45, type: "museum", name: "Opole Museum", latitude: 50.6756, longitude: 17.9213, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[15], locations: [
		Location(id: 46, type: "restaurant", name: "Karczma Staropolska", latitude: 50.0413, longitude: 21.9991, rating: .good),
		Location(id: 47, type: "restaurant", name: "Karczma Rzym", latitude: 50.0413, longitude: 21.9991, rating: .excellent),
		Location(id: 48, type: "museum", name: "Subcarpathian Museum", latitude: 50.0413, longitude: 21.9991, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[16], locations: [
		Location(id: 49, type: "restaurant", name: "Karczma Staropolska", latitude: 54.5189, longitude: 18.5305, rating: .good),
		Location(id: 50, type: "restaurant", name: "Karczma Rzym", latitude: 54.5189, longitude: 18.5305, rating: .excellent),
		Location(id: 51, type: "museum", name: "Gdynia Aquarium", latitude: 54.5189, longitude: 18.5305, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[17], locations: [
		Location(id: 52, type: "restaurant", name: "Karczma Staropolska", latitude: 50.8110, longitude: 19.1200, rating: .good),
		Location(id: 53, type: "restaurant", name: "Karczma Rzym", latitude: 50.8110, longitude: 19.1200, rating: .excellent),
		Location(id: 54, type: "museum", name: "Jasna Gora Monastery", latitude: 50.8110, longitude: 19.1200, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[18], locations: [
		Location(id: 55, type: "restaurant", name: "Karczma Staropolska", latitude: 54.4416, longitude: 18.5600, rating: .good),
		Location(id: 56, type: "restaurant", name: "Karczma Rzym", latitude: 54.4416, longitude: 18.5600, rating: .excellent),
		Location(id: 57, type: "museum", name: "Crooked House", latitude: 54.4416, longitude: 18.5600, rating: .excellent)
	]),
	CityLocations(relatedCity: cities[19], locations: [
		Location(id: 58, type: "restaurant", name: "Karczma Staropolska", latitude: 51.4026, longitude: 21.1471, rating: .good),
		Location(id: 59, type: "restaurant", name: "Karczma Rzym", latitude: 51.4026, longitude: 21.1471, rating: .excellent),
		Location(id: 60, type: "museum", name: "Masovian Museum", latitude: 51.4026, longitude: 21.1471, rating: .excellent)
	])
]

func showCitiesWithBestRestaurants() {
	let res = citiesWithLocations.filter { $0.locations.filter { $0.type == "restaurant" && $0.rating == .excellent }.count > 0 }
	res.forEach { print($0.relatedCity.name) }
}
print("Miasta z restauracjami ocenionymi na 5 gwiazdek: ")
showCitiesWithBestRestaurants()

func findLocationsInCity(_ city: City) -> [Location] {
	return citiesWithLocations.filter { $0.relatedCity.id == city.id }.first!.locations.sorted { $0.rating.rawValue > $1.rating.rawValue }
}

print("\nMiejsca w Gdańsku posortowane wg oceny: ")
findLocationsInCity(findCitiesByName("Gdansk")[0]).forEach { print($0.toString()) }

func printBestLocationsCountInCities() {
	citiesWithLocations.forEach { cityLocations in
		let bestLocations = cityLocations.locations.filter { $0.rating == .excellent }
		print("\n\(cityLocations.relatedCity.name): \(bestLocations.count) miejsc o najwyższej ocenie")
		bestLocations.forEach { print($0.toString()) }
	}
}

printBestLocationsCountInCities()