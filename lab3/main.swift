import Foundation

enum reference_type: String{
	case branch
	case repository
	case tag
}
struct user {
	var id: Int
	var login: String
	var display_login: String?
	var gravatar_id: String
	var url: String
	var avatar_url: String
	func to_string() -> String {
		return "\(self.display_login ?? self.login)"
	}
}
struct repository {
	var id: Int
	var name: String
	var url: String
	func frontendURL() -> String {
		return self.url.replacingOccurrences(of: "api.", with: "").replacingOccurrences(of: "repos/", with: "")
	}
}
class GithubEvent {
	var id: String
	var actor: user
	var repo: repository
	var payload: [String: Any]
	var _public: Bool
	var created_at: String
	var org: user?
	init(id: String, actor: user, repo: repository, payload: [String: Any], _public: Bool, created_at: String, org: user?) {
		self.id = id
		self.actor = actor
		self.repo = repo
		self.payload = payload
		self._public = _public
		self.created_at = created_at
		self.org = org
	}
	func formatCreationDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: self.created_at)
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
		return dateFormatter.string(from: date!)
	}
	func to_string() -> String {
		if self._public {
			return "[\(self.formatCreationDate())] \(self.actor.to_string()) performed an action in \(self.repo.name) (\(self.repo.frontendURL()))"
		} else {
			return "[\(self.formatCreationDate())] \(self.actor.to_string()) performed an action in a private repository"
		}
	}
}
class CreateEvent: GithubEvent {
	var ref: String?
	var ref_type: reference_type
	var master_branch: String
	var description: String?
	var pusher_type: String?
	override
	init(id: String, actor: user, repo: repository, payload: [String: Any], _public: Bool, created_at: String, org: user?) {
		self.ref = payload["ref"] as? String
		self.ref_type = reference_type(rawValue: payload["ref_type"] as! String)!
		self.master_branch = payload["master_branch"] as! String
		self.description = payload["description"] as? String
		self.pusher_type = payload["pusher_type"] as? String
		super.init(id: id, actor: actor, repo: repo, payload: payload, _public: _public, created_at: created_at, org: org)
	}
	override
	func to_string() -> String {
		if self._public {
			return "[\(self.formatCreationDate())] \(self.actor.to_string()) created \(self.ref_type.rawValue) \(self.ref ?? "") in \(self.repo.name) (\(self.repo.frontendURL()))"
		} else {
			return "[\(self.formatCreationDate())] \(self.actor.to_string()) created \(self.ref_type.rawValue) \(self.ref ?? "") in a private repository"
		}
	}
}
class MemberEvent: GithubEvent {
	var member: user
	var action: String
	override
	init(id: String, actor: user, repo: repository, payload: [String: Any], _public: Bool, created_at: String, org: user?) {
		let _member = payload["member"] as! [String: Any]
		self.member = user(id: _member["id"] as! Int, login: _member["login"] as! String, display_login: _member["display_login"] as? String, gravatar_id: _member["gravatar_id"] as! String, url: _member["url"] as! String, avatar_url: _member["avatar_url"] as! String)
		self.action = payload["action"] as! String
		super.init(id: id, actor: actor, repo: repo, payload: payload, _public: _public, created_at: created_at, org: org)
	}
	override
	func to_string() -> String {
		if self._public {
			return "[\(self.formatCreationDate())] \(self.actor.to_string()) \(self.action) \(self.member.to_string()) to \(self.repo.name) (\(self.repo.frontendURL()))"
		} else {
			return "[\(self.formatCreationDate())] \(self.actor.to_string()) \(self.action) \(self.member.to_string()) to a private repository"
		}
	}
}
class WatchEvent: GithubEvent {
	var action: String
	override
	init(id: String, actor: user, repo: repository, payload: [String: Any], _public: Bool, created_at: String, org: user?) {
		self.action = payload["action"] as! String
		super.init(id: id, actor: actor, repo: repo, payload: payload, _public: _public, created_at: created_at, org: org)
	}
	override
	func to_string() -> String {
		if self._public {
		return "[\(self.formatCreationDate())] \(self.actor.to_string()) \(self.action) watching \(self.repo.name) (\(self.repo.frontendURL()))"
		} else {
			return "[\(self.formatCreationDate())] \(self.actor.to_string()) \(self.action) watching a private repository"
		}
	}
}
//Hardcoded test data
print("---Hardcoded test data---")
let hardcodedEvents = [
	CreateEvent(id: "2", actor: user(id : 1, login: "PetrusTryb", display_login: "Piotr Trybisz", gravatar_id: "123", url: " ", avatar_url: " "), repo: repository(id: 1, name: "MacOS_iOS_labs", url: "https://github.com/PetrusTryb/MacOS_iOS_labs"), payload: ["ref": "main", "ref_type": "branch", "master_branch": "main", "description": " ", "pusher_type": " "], _public: true, created_at: "2021-10-10T10:00:00Z", org: nil),
	MemberEvent(id: "1", actor: user(id : 1, login: "PetrusTryb", display_login: "Piotr Trybisz", gravatar_id: "123", url: " ", avatar_url: " "), repo: repository(id: 1, name: "MacOS_iOS_labs", url: "https://github.com/PetrusTryb/MacOS_iOS_labs"), payload: ["member": ["id": 2, "login": "testuser1", "display_login": nil, "gravatar_id": "123", "url": " ", "avatar_url": " "], "action": "added"], _public: true, created_at: "2021-10-10T10:05:00Z", org: nil),
	GithubEvent(id: "3", actor: user(id: 1, login: "PetrusTryb", display_login: "Piotr Trybisz", gravatar_id: "123", url: " ", avatar_url: " "), repo: repository(id: 1, name: "MacOS_iOS_labs", url: "https://github.com/PetrusTryb/MacOS_iOS_labs"), payload: ["action": "created"], _public: true, created_at: "2021-10-10T10:20:00Z", org: nil),
	WatchEvent(id: "7", actor: user(id : 1, login: "PetrusTryb", display_login: "Piotr Trybisz", gravatar_id: "123", url: " ", avatar_url: " "), repo: repository(id: 1, name: "MacOS_iOS_labs", url: "https://github.com/PetrusTryb/MacOS_iOS_labs"), payload: ["action": "started"], _public: false, created_at: "2021-10-10T10:24:30Z", org: nil)
]
for event in hardcodedEvents {
	print(event.to_string())
}

//Test data from JSON (acquired from GitHub API)
print("---Test data from JSON---")
let filename = "data.json"
let fileURL = URL(fileURLWithPath: filename)
let data = try Data(contentsOf: fileURL)
let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
var events = [GithubEvent]()
for item in json {
	let _type = item["type"] as! String
	let id = item["id"] as! String
	let _actor = item["actor"] as! [String: Any]
	let actor_obj = user(id: _actor["id"] as! Int, login: _actor["login"] as! String, display_login: _actor["display_login"] as? String, gravatar_id: _actor["gravatar_id"] as! String, url: _actor["url"] as! String, avatar_url: _actor["avatar_url"] as! String)
	let _repo = item["repo"] as! [String: Any]
	let repo_obj = repository(id: _repo["id"] as! Int, name: _repo["name"] as! String, url: _repo["url"] as! String)
	switch _type{
		case "CreateEvent":
			let payload = item["payload"] as! [String: Any]
			let create_event = CreateEvent(id: id, actor: actor_obj, repo: repo_obj, payload: payload, _public: item["public"] as! Bool, created_at: item["created_at"] as! String, org: nil)
			events.append(create_event)
		case "MemberEvent":
			let payload = item["payload"] as! [String: Any]
			let member_event = MemberEvent(id: id, actor: actor_obj, repo: repo_obj, payload: payload, _public: item["public"] as! Bool, created_at: item["created_at"] as! String, org: nil)
			events.append(member_event)
		case "WatchEvent":
			let payload = item["payload"] as! [String: Any]
			let watch_event = WatchEvent(id: id, actor: actor_obj, repo: repo_obj, payload: payload, _public: item["public"] as! Bool, created_at: item["created_at"] as! String, org: nil)
			events.append(watch_event)
		default:
			let payload = item["payload"] as! [String: Any]
			let github_event = GithubEvent(id: id, actor: actor_obj, repo: repo_obj, payload: payload, _public: item["public"] as! Bool, created_at: item["created_at"] as! String, org: nil)
			events.append(github_event)
	}
}
for event in events {
	print(event.to_string())
}