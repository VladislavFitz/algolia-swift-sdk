import AlgoliaFoundation
@testable import AlgoliaSearchClient
import Foundation

class MockHTTPClient: HTTPClient {
  var requestHandler: (URLRequest) async throws -> (Data, URLResponse)

  init(_ requestHandler: @escaping (URLRequest) async throws -> (Data, URLResponse)) {
    self.requestHandler = requestHandler
  }

  func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
    try await requestHandler(request)
  }
}
