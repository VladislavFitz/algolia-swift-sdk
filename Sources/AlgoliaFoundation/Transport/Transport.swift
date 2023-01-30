// swiftlint:disable function_body_length
import Foundation
import Logging

public class Transport {
  /// The client which performs HTTP requests
  public let httpClient: HTTPClient

  /// The list of retryable hosts
  public let hosts: [Host]

  /// The interval of host state reset
  public let hostExpirationDelay: TimeInterval

  /// The timeout for each request when performing write operations (POST, PUT ..).
  public var writeTimeout: TimeInterval

  /// The timeout for each request when performing read operations (GET).
  public var readTimeout: TimeInterval

  /// The transport events logger
  public var logger: Logger

  public init(httpClient: HTTPClient = URLSession(configuration: .default),
              hosts: [Host],
              hostExpirationDelay: TimeInterval = 60 * 5,
              writeTimeout: TimeInterval = 30,
              readTimeout: TimeInterval = 5,
              logger: Logger = Logger(label: "Algolia SDK")) {
    self.httpClient = httpClient
    self.hosts = hosts
    self.hostExpirationDelay = hostExpirationDelay
    self.writeTimeout = writeTimeout
    self.readTimeout = readTimeout
    self.logger = logger
    self.logger.logLevel = .trace
  }

  private func prepareHosts() {
    for host in hosts {
      let timeDelayExpired = Date().timeIntervalSince(host.lastUpdated)
      if timeDelayExpired > hostExpirationDelay {
        host.reset()
      }
    }
  }

  private func isTimeout(_ error: Error) -> Bool {
    switch error {
    case let urlError as URLError where urlError.code == .timedOut:
      return true

    case let httpError as HTTPError where httpError.statusCode == .requestTimeout:
      return true

    default:
      return false
    }
  }

  private func isRetryable(_ error: Error) -> Bool {
    switch error {
    case is URLError:
      return true

    case let httpError as HTTPError where !httpError.statusCode.belongs(to: .success, .clientError):
      return true

    default:
      return false
    }
  }

  @discardableResult public func perform(method: HTTPMethod,
                                         path: String,
                                         queryItems: [URLQueryItem] = [],
                                         headers: [String: String],
                                         body: Data?,
                                         requestType: RequestType) async throws -> Data {
    prepareHosts()

    let bodyDescription: String
    if let body = body {
      bodyDescription = body.prettyJson ?? "non-json data"
    } else {
      bodyDescription = "nil"
    }

    logger.debug("""
    request
      requestType: \(requestType)
      method: \(method)
      path: \(path)
      headers: \(headers)
      body: \(bodyDescription)
    """)

    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.path = path
    urlComponents.queryItems = queryItems

    func makeRequest(with host: Host) -> URLRequest? {
      urlComponents.host = host.value
      guard let url = urlComponents.url else {
        return nil
      }
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.allHTTPHeaderFields = headers
      request.httpBody = body

      let baseTimeoutInterval: TimeInterval

      switch requestType {
      case .read:
        baseTimeoutInterval = readTimeout
      case .write:
        baseTimeoutInterval = writeTimeout
      }

      request.timeoutInterval = TimeInterval(host.retryCount + 1) * baseTimeoutInterval

      return request
    }

    let hostsForRequestType = hosts.filter { $0.supports(requestType) }

    if hostsForRequestType.allSatisfy({ !$0.isUp }) {
      hostsForRequestType.forEach { $0.reset() }
    }

    for host in hostsForRequestType where host.isUp {
      do {
        guard let request = makeRequest(with: host) else {
          throw URLError(.badURL, userInfo: ["host": host.value, "path": path])
        }
        logger.debug("request with url: \(request)")

        let (responseData, urlResponse) = try await httpClient.perform(request)

        if let httpError = HTTPError(response: urlResponse as? HTTPURLResponse, data: responseData) {
          throw httpError
        }
        logger.trace("reset host \(host)")
        host.reset()
        logger.debug("response: \(responseData.prettyJson ?? "non-json data")")
        return responseData
      } catch let error where isTimeout(error) {
        host.hasTimedOut()
      } catch let error where isRetryable(error) {
        host.hasFailed()
      } catch {
        throw TransportError.nonRetryableError(error)
      }
    }

    throw TransportError.noReachableHosts
  }
}

extension Data {
  var prettyJson: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

    return prettyPrintedString
  }
}
