import Foundation

protocol HTTPClient {
  func perform(_ request: URLRequest) async throws -> (Data, URLResponse)
}
