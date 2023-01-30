import AlgoliaFoundation
import Foundation
import Logging

/// Algolia search client
public class SearchClient: Client {
  /**
   - Parameter appID: Algolia application ID.
   - Parameter apiKey: Algolia API key of the application.
   */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey,
                          extraUserAgents: [String] = []) {
    func buildHost(_ components: (suffix: String, requestType: RequestTypeSupport)) -> AlgoliaFoundation.Host {
      Host(url: "\(appID)\(components.suffix)", requestType: components.requestType)
    }
    let specializedHosts = [
      ("-dsn.algolia.net", .read),
      (".algolia.net", .write)
    ].map(buildHost)

    let universalHosts = [
      ("-1.algolianet.com", .universal),
      ("-2.algolianet.com", .universal),
      ("-3.algolianet.com", .universal)
    ].shuffled().map(buildHost)

    let hosts = specializedHosts + universalHosts

    let userAgents = [
      "AlgoliaSDK-Search/\(CurrentVersion.version) (\(OperatingSystem.description))"
    ] + extraUserAgents

    let urlSessionConfiguration = URLSessionConfiguration.default
    urlSessionConfiguration.httpAdditionalHeaders = [
      "X-Algolia-Application-Id": appID.rawValue,
      "X-Algolia-API-Key": apiKey.rawValue,
      "User-Agent": userAgents.joined(separator: ";")
    ]
    let urlSession = URLSession(configuration: urlSessionConfiguration)
    let transport = Transport(httpClient: urlSession,
                              hosts: hosts,
                              logger: Logger(label: "AlgoliaSearchClient"))
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .algoliaClientDateEncodingStrategy
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .algoliaClientDateDecodingStrategy
    self.init(transport: transport,
              jsonEncoder: jsonEncoder,
              jsonDecoder: jsonDecoder)
  }
}
