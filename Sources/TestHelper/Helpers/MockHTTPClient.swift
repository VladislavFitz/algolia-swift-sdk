import AlgoliaFoundation
import Foundation

public class MockHTTPClient: HTTPClient {
  public var requestHandler: (URLRequest) async throws -> (Data, URLResponse)

  public init(_ requestHandler: @escaping (URLRequest) async throws -> (Data, URLResponse)) {
    self.requestHandler = requestHandler
  }

  public func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
    try await requestHandler(request)
  }
}
