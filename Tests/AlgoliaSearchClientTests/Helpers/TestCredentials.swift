@testable import AlgoliaSearchClient
import AlgoliaFoundation
import Foundation

extension SearchClient {
  convenience init(credentials: Credentials) {
    self.init(appID: credentials.applicationID, apiKey: credentials.apiKey)
  }
}

struct Credentials {
  let applicationID: ApplicationID
  let apiKey: APIKey

  static func fromEnv(_ appIDVar: String, _ apiKeyVar: String) -> Self {
    let appID = String(environmentVariable: appIDVar)
    let apiKey = String(environmentVariable: apiKeyVar)
    assert(appID != nil, "missing \(appIDVar) environment variable")
    assert(apiKey != nil, "missing \(apiKeyVar) environment variable")
    return Self(applicationID: ApplicationID(rawValue: appID!), apiKey: APIKey(rawValue: apiKey!))
  }

  static let primary = fromEnv("ALGOLIA_APPLICATION_ID_1", "ALGOLIA_ADMIN_KEY_1")
  static let secondary = fromEnv("ALGOLIA_APPLICATION_ID_2", "ALGOLIA_ADMIN_KEY_2")
  static let mcm = fromEnv("ALGOLIA_APPLICATION_ID_MCM", "ALGOLIA_ADMIN_KEY_MCM")
}

extension String {
  init?(environmentVariable: String) {
    if
      let rawValue = getenv(environmentVariable),
      let value = String(utf8String: rawValue) {
      self = value
    } else {
      return nil
    }
  }
}
