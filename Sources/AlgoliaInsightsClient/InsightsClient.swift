import AlgoliaFoundation
import Foundation
import Logging

/// Algolia Insights client
public class InsightsClient: Client {
  /**
   - Parameter appID: Algolia application ID.
   - Parameter apiKey: Algolia API key of the application.
   */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey,
                          region: Region? = nil,
                          extraUserAgents: [String] = []) {
    let userAgents = [
      "AlgoliaSDK-Insights/\(CurrentVersion.version) (\(OperatingSystem.description))"
    ] + extraUserAgents
    let urlSessionConfiguration = URLSessionConfiguration.default
    urlSessionConfiguration.httpAdditionalHeaders = [
      "X-Algolia-Application-Id": appID.rawValue,
      "X-Algolia-API-Key": apiKey.rawValue,
      "User-Agent": userAgents.joined(separator: ";")
    ]
    let urlSession = URLSession(configuration: urlSessionConfiguration)

    let regionComponent = region.flatMap { ".\($0.rawValue)" } ?? ""
    let hosts = [Host(url: "insights\(regionComponent).algolia.io")]

    let transport = Transport(httpClient: urlSession,
                              hosts: hosts,
                              logger: Logger(label: "AlgoliaInsightsClient"))
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .algoliaClientDateEncodingStrategy
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .algoliaClientDateDecodingStrategy

    self.init(transport: transport,
              jsonEncoder: jsonEncoder,
              jsonDecoder: jsonDecoder)
  }
}

public extension InsightsClient {
  /**
   Send Insight event

   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: JSON  object
   */
  func send(_ events: Event...) async throws {
    try await send(events)
  }

  /**
   Send Insights events

   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: JSON  object
   */
  func send(_ events: [Event]) async throws {
    let request = FieldWrapper.events(events)
    let body = try jsonEncoder.encode(request)
    try await transport.perform(method: .post,
                                path: "/1/events",
                                headers: ["Content-Type": "application/json"],
                                body: body,
                                requestType: .write)
  }
}
