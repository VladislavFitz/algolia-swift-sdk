@testable import AlgoliaSearchClient
import AlgoliaFoundation
import XCTest
// swiftlint:disable cyclomatic_complexity function_body_length

final class TransportTests: XCTestCase {
  func testRetryStrategy() async throws {
    let client = MockHTTPClient { _ in
      (Data(), URLResponse())
    }

    let hosts = [
      Host(url: "readHost1.com", requestType: .read),
      Host(url: "readHost2.com", requestType: .read),
      Host(url: "writeHost1.com", requestType: .write),
      Host(url: "writeHost2.com", requestType: .write),
      Host(url: "universalHost1.com", requestType: .universal),
      Host(url: "universalHost2.com", requestType: .universal)
    ]

    let requestData = "REQUEST".data(using: .utf8)!
    let responseData = "RESPONSE".data(using: .utf8)!
    let retryableError = URLError(.badServerResponse)
    let nonRetryableError = HTTPError(statusCode: 404, message: ErrorMessage(description: "Not Found"))

    let transport = Transport(httpClient: client, hosts: hosts)

    // Perform read request, expect readHost1.com usage

    client.requestHandler = { request in
      XCTAssertEqual(request.httpMethod, "GET")
      XCTAssertEqual(request.url, URL(string: "https://readHost1.com/test/?"))
      XCTAssertEqual(request.allHTTPHeaderFields, ["h1": "v1"])
      XCTAssertEqual(request.httpBody, requestData)
      XCTAssertEqual(request.timeoutInterval, transport.readTimeout)

      return (responseData,
              HTTPURLResponse(url: request.url!,
                              statusCode: 200,
                              httpVersion: nil,
                              headerFields: request.allHTTPHeaderFields)!)
    }

    let response = try await transport.perform(method: .get,
                                               path: "/test/",
                                               headers: ["h1": "v1"],
                                               body: requestData,
                                               requestType: .read)

    XCTAssertEqual(response, responseData)

    func successResponse(for request: URLRequest) -> HTTPURLResponse {
      HTTPURLResponse(url: request.url!,
                      statusCode: 200,
                      httpVersion: nil,
                      headerFields: request.allHTTPHeaderFields)!
    }

    // Return timeout error for readHost1, next attempt might call readHost2

    client.requestHandler = { request in
      switch request.url?.absoluteString {
      case "https://readHost1.com/test/?":
        return (try JSONEncoder().encode(ErrorMessage(description: "request timeout")),
                HTTPURLResponse(url: request.url!,
                                statusCode: .requestTimeout,
                                httpVersion: nil,
                                headerFields: request.allHTTPHeaderFields)!)
      case "https://readHost2.com/test/?":
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields, ["h1": "v1"])
        XCTAssertEqual(request.httpBody, requestData)
        XCTAssertEqual(request.timeoutInterval, transport.readTimeout)
        return (responseData, successResponse(for: request))
      case let url:
        throw TransportTestError.unexpectedHost(url!)
      }
    }

    _ = try await transport.perform(method: .get,
                                    path: "/test/",
                                    headers: ["h1": "v1"],
                                    body: requestData,
                                    requestType: .read)

    // Next attempt must trigger back readHost1 but with increased timeout

    client.requestHandler = { request in
      XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
      XCTAssertEqual(request.url, URL(string: "https://readHost1.com/test/?"))
      XCTAssertEqual(request.allHTTPHeaderFields, ["h1": "v1"])
      XCTAssertEqual(request.httpBody, requestData)
      XCTAssertEqual(request.timeoutInterval, transport.readTimeout * 2)
      return (responseData, successResponse(for: request))
    }

    _ = try await transport.perform(method: .get,
                                    path: "/test/",
                                    headers: ["h1": "v1"],
                                    body: requestData,
                                    requestType: .read)

    // Return retryable error for readHost1, readHost2 next attempt might call universalHost1

    client.requestHandler = { request in
      switch request.url?.absoluteString {
      case
        "https://readHost1.com/test/?",
        "https://readHost2.com/test/?":
        throw retryableError
      case "https://universalHost1.com/test/?":
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.allHTTPHeaderFields, ["h1": "v1"])
        XCTAssertEqual(request.httpBody, requestData)
        XCTAssertEqual(request.timeoutInterval, transport.readTimeout)
        return (responseData, successResponse(for: request))
      case let url:
        throw TransportTestError.unexpectedHost(url!)
      }
    }

    _ = try await transport.perform(method: .get,
                                    path: "/test/",
                                    headers: ["h1": "v1"],
                                    body: requestData,
                                    requestType: .read)

    XCTAssertFalse(transport.hosts[0].isUp)
    XCTAssertFalse(transport.hosts[1].isUp)

    // Throw retryable error for writeHost1, writeHost2, universalHost1, expect unversalHost2 call

    client.requestHandler = { request in
      switch request.url?.absoluteString {
      case
        "https://writeHost1.com/test/?",
        "https://writeHost2.com/test/?",
        "https://universalHost1.com/test/?":
        throw retryableError
      case "https://universalHost2.com/test/?":
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.allHTTPHeaderFields, ["h1": "v1"])
        XCTAssertEqual(request.httpBody, requestData)
        XCTAssertEqual(request.timeoutInterval, transport.writeTimeout)
        return (responseData, successResponse(for: request))
      case let url:
        throw TransportTestError.unexpectedHost(url!)
      }
    }

    _ = try await transport.perform(method: .post,
                                    path: "/test/",
                                    headers: ["h1": "v1"],
                                    body: requestData,
                                    requestType: .write)

    XCTAssertFalse(transport.hosts[0].isUp)
    XCTAssertFalse(transport.hosts[1].isUp)
    XCTAssertFalse(transport.hosts[2].isUp)
    XCTAssertFalse(transport.hosts[3].isUp)
    XCTAssertFalse(transport.hosts[4].isUp)

    // Throw retryable error for universalHost2, expect no reachable hosts error

    client.requestHandler = { request in
      switch request.url?.absoluteString {
      case "https://universalHost2.com/test/?":
        throw retryableError
      case let url:
        throw TransportTestError.unexpectedHost(url!)
      }
    }

    do {
      _ = try await transport.perform(method: .post,
                                      path: "/test/",
                                      headers: ["h1": "v1"],
                                      body: requestData,
                                      requestType: .write)
    } catch TransportError.noReachableHosts {
    } catch {
      XCTFail("unexpected error \(error)")
    }

    // Since all host are down, next read request might reset all
    // read an universal hosts and perform request on readHost1

    client.requestHandler = { request in
      switch request.url?.absoluteString {
      case "https://readHost1.com/test/?":
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://readHost1.com/test/?"))
        XCTAssertEqual(request.allHTTPHeaderFields, ["h1": "v1"])
        XCTAssertEqual(request.httpBody, requestData)
        XCTAssertEqual(request.timeoutInterval, transport.readTimeout)
        return (responseData, successResponse(for: request))
      case let url:
        throw TransportTestError.unexpectedHost(url!)
      }
    }

    _ = try await transport.perform(method: .get,
                                    path: "/test/",
                                    headers: ["h1": "v1"],
                                    body: requestData,
                                    requestType: .read)

    XCTAssertTrue(transport.hosts[0].isUp)
    XCTAssertTrue(transport.hosts[1].isUp)
    XCTAssertFalse(transport.hosts[2].isUp)
    XCTAssertFalse(transport.hosts[3].isUp)
    XCTAssertTrue(transport.hosts[4].isUp)
    XCTAssertTrue(transport.hosts[5].isUp)

    // Test throw non-retryable error

    client.requestHandler = { _ in
      throw nonRetryableError
    }

    do {
      _ = try await transport.perform(method: .get,
                                      path: "/test/",
                                      headers: ["h1": "v1"],
                                      body: requestData,
                                      requestType: .read)
    } catch TransportError.nonRetryableError {
    } catch {
      XCTFail("unexpected error \(error)")
    }
  }
}

enum TransportTestError: Error, LocalizedError {
  case unexpectedHost(String)

  var errorDescription: String? {
    switch self {
    case let .unexpectedHost(host):
      return "unexpected host: \(host)"
    }
  }
}
