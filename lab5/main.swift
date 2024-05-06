/*
Data sources:
-	Mnemonic words: https://github.com/sindresorhus/mnemonic-words
-	Animals: https://random-word-form.herokuapp.com
-	Jokes: https://github.com/LinuxLovah/TuxTwitchTalker
-	Commit messages: https://github.com/ponsfrilus/commitment
*/
import Foundation
class Hangman {
	var to_guess: String
	var guessed: String
	var tries: Int
	var max_tries: Int

	init(to_guess: String, max_tries: Int) {
		self.to_guess = to_guess
		self.guessed = String(repeating: "_", count: to_guess.count)
		self.tries = 0
		self.max_tries = max_tries
		let hints = " ,.?!"
		for hint in hints {
			self.guess(letter: hint)
		}
	}

	func play(){
		self.tries = 0
		print_board()
		while !is_over() {
			print("Enter a letter: ", terminator: "")
			let letter = readLine()
			guess(letter: Character(letter!))
			print_board()
		}
	}

	func guess(letter: Character) {
		if to_guess.contains(letter) {
			for i in 0..<to_guess.count {
				if to_guess[to_guess.index(to_guess.startIndex, offsetBy: i)] == letter {
					guessed = String(guessed.prefix(i) + String(letter) + guessed.suffix(guessed.count - i - 1))
				}
			}
		} else {
			tries += 1
		}
	}

	func is_over() -> Bool {
		return tries >= max_tries || is_won()
	}

	func is_won() -> Bool {
		return guessed == to_guess
	}

	func print_board() {
		print("\u{001B}[2J", terminator: "")
		print("\u{001B}[H", terminator: "")
		print("Word: \(guessed)")
		print("Tries: \(tries)/\(max_tries)")
	}
}

struct Topic {
	var name: String
	var path: String
	var plaintext: Bool
}

let topics = [
	Topic(name: "Mnemonic words", path: "./words.json", plaintext: false),
	Topic(name: "Animals", path: "./animals.json", plaintext: false),
	Topic(name: "Jokes", path: "./dadjokes.txt", plaintext: true),
	Topic(name: "Commit messages", path: "./commit_messages.txt", plaintext: true)
]

struct Level {
	var name: String
	var max_tries_percentage: Int
}

let levels = [
	Level(name: "Easy", max_tries_percentage: 100),
	Level(name: "Medium", max_tries_percentage: 50),
	Level(name: "Hard", max_tries_percentage: 20),
	Level(name: "Impossible", max_tries_percentage: 5)
]

print("Choose a topic:")
for i in 0..<topics.count {
	print("\(i + 1). \(topics[i].name)")
}

var choice = Int(readLine()!)! - 1
let topic = topics[choice]

let path = URL(fileURLWithPath: topic.path)
let data = try! Data(contentsOf: path)
var to_guess: String
if !topic.plaintext {
	let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String]
	to_guess = json.randomElement()!
} else {
	let words = String(data: data, encoding: .utf8)!.components(separatedBy: "\n")
	to_guess = words.randomElement()!
}

to_guess = to_guess.lowercased()
to_guess = to_guess.replacingOccurrences(of: "[^a-z ,.?!]", with: "", options: [.regularExpression])


print("Choose a level:")
for i in 0..<levels.count {
	print("\(i + 1). \(levels[i].name)")
}
choice = Int(readLine()!)! - 1
let level = levels[choice]
let game = Hangman(to_guess: to_guess, max_tries: level.max_tries_percentage * to_guess.count / 100)
game.play()
if game.is_won() {
	print("You won!")
} else {
	print("Game over, the answer was: \(to_guess).")
}