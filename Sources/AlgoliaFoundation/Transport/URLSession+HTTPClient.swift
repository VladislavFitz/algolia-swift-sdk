import Foundation

extension URLSession: HTTPClient {
  public func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
    try await withCheckedThrowingContinuation { continuation in
      dataTask(with: request) { data, response, error in
        if let error = error {
          continuation.resume(throwing: error)
        } else if let data = data, let response = response {
          continuation.resume(returning: (data, response))
        }
      }.resume()
    }
  }
}
