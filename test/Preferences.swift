
import Foundation
struct Preferences: Codable {
  let authorizeURL: String
  let forceAuthentication: String
  let authenticationPrefix: String
  let tokenPrefix: String
  let userAccount: String
  let token: String
  
  static func get() -> Preferences? {
    guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
      let xml = FileManager.default.contents(atPath: path) else {return nil}
    do {
      let preferences = try PropertyListDecoder().decode(Preferences.self, from: xml)
      return preferences
    } catch {
      print(error)
      return nil
    }
  }
}
