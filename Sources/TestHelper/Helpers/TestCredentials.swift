import AlgoliaFoundation
import Foundation

public struct Credentials {
  public let applicationID: ApplicationID
  public let apiKey: APIKey

  public static func fromEnv(_ appIDVar: String, _ apiKeyVar: String) -> Self {
    let appID = String(environmentVariable: appIDVar)
    let apiKey = String(environmentVariable: apiKeyVar)
    assert(appID != nil, "missing \(appIDVar) environment variable")
    assert(apiKey != nil, "missing \(apiKeyVar) environment variable")
    return Self(applicationID: ApplicationID(rawValue: appID!), apiKey: APIKey(rawValue: apiKey!))
  }

  public static let primary = fromEnv("ALGOLIA_APPLICATION_ID_1", "ALGOLIA_ADMIN_KEY_1")
  public static let secondary = fromEnv("ALGOLIA_APPLICATION_ID_2", "ALGOLIA_ADMIN_KEY_2")
  public static let mcm = fromEnv("ALGOLIA_APPLICATION_ID_MCM", "ALGOLIA_ADMIN_KEY_MCM")
}
