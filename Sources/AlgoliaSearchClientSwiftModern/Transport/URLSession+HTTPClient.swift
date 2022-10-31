import Foundation

extension URLSession: HTTPClient {
  func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
    try await data(for: request)
  }
}
