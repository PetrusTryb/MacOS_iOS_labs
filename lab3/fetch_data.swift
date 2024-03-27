//Script used to fetch GitHub activity feed (it is on homepage)
import Foundation
import FoundationNetworking
let apiEndpoint = "https://api.github.com/users/PetrusTryb/received_events/public?per_page=10"
let filename = "data.json"
if let apiKey = ProcessInfo.processInfo.environment["GITHUB_TOKEN"] {
	let url = URL(string: apiEndpoint)!
	var request = URLRequest(url: url)
	request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
	request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
	let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
		if let error = error {
			print("Error: \(error)")
			exit(EXIT_FAILURE)
		} else if let data = data {
			print("Data: \(data.count) bytes")
			let fileURL = URL(fileURLWithPath: filename)
			do {
				try data.write(to: fileURL)
				print("Data saved to \(filename)")
				exit(EXIT_SUCCESS)
			} catch {
				print("Error: \(error)")
				exit(EXIT_FAILURE)
			}
		} else {
			print("No data.")
			exit(EXIT_FAILURE)
		}
	}
	task.resume()
	RunLoop.main.run()
} else {
	print("No API key. Create a file named '.env' in the root directory of the project and add 'GITHUB_TOKEN'.")
	exit(EXIT_FAILURE)
}