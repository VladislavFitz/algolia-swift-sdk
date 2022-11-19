import Foundation

public class Client {
  /// Transport which performs HTTP requests
  public let transport: Transport
  /// Encoder for JSON requests
  public let jsonEncoder: JSONEncoder
  /// Decoder for JSON responses
  public let jsonDecoder: JSONDecoder

  /**
   - Parameter transport: Transport which performs HTTP requests.
   - Parameter jsonEncoder: Encoder for JSON requests.
   - Parameter jsonDecoder: Decoder for JSON responses.
   */
  public init(transport: Transport,
              jsonEncoder: JSONEncoder,
              jsonDecoder: JSONDecoder) {
    self.transport = transport
    self.jsonEncoder = jsonEncoder
    self.jsonDecoder = jsonDecoder
  }
}
