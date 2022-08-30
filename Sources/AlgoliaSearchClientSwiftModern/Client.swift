import Combine
import Foundation

public class Client {
  public let transport: Transport
  public let jsonEncoder: JSONEncoder
  public let jsonDecoder: JSONDecoder

  internal var storage = Set<AnyCancellable>()

  public init(transport: Transport,
              jsonEncoder: JSONEncoder,
              jsonDecoder: JSONDecoder) {
    self.transport = transport
    self.jsonEncoder = jsonEncoder
    self.jsonDecoder = jsonDecoder
  }

  public convenience init(appID: ApplicationID,
                          apiKey: APIKey) {
    func buildHost(_ components: (suffix: String, requestType: RequestTypeSupport)) -> Host {
      Host(url: "\(appID)\(components.suffix)", requestType: components.requestType)
    }
    let specializedHosts = [
      ("-dsn.algolia.net", .read),
      (".algolia.net", .write)
    ].map(buildHost)

    let unversalHosts = [
      ("-1.algolianet.com", .universal),
      ("-2.algolianet.com", .universal),
      ("-3.algolianet.com", .universal)
    ].shuffled().map(buildHost)

    let hosts = specializedHosts + unversalHosts

    let confugration = URLSessionConfiguration.default
    confugration.httpAdditionalHeaders = [
      "X-Algolia-Application-Id": appID.rawValue,
      "X-Algolia-API-Key": apiKey.rawValue
    ]
    let urlSession = URLSession(configuration: confugration)
    let transport = Transport(httpClient: urlSession,
                              hosts: hosts)
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .algoliaClientDateEncodingStrategy
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .algoliaClientDateDecodingStrategy
    self.init(transport: transport,
              jsonEncoder: jsonEncoder,
              jsonDecoder: jsonDecoder)
  }
}
