import Foundation

public struct DeleteQueryParameters {
  internal var parameters: [String: DeleteQueryParameter]

  public init(_ parameters: [DeleteQueryParameter]) {
    self.parameters = .init(uniqueKeysWithValues: parameters.map { ($0.key, $0) })
  }

  public init(_ parameters: DeleteQueryParameter...) {
    self.init(parameters)
  }

  public init(@DeleteQueryParametersBuilder _ content: () -> [DeleteQueryParameter]) {
    self = Self(content())
  }
}

extension DeleteQueryParameters: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CustomCodingKey.self)
    for (key, parameter) in parameters {
      try container.encode(EncodableBox(parameter), forKey: CustomCodingKey(stringValue: key))
    }
  }
}

extension DeleteQueryParameters: URLEncodable {
  public var urlEncodedString: String {
    var urlComponents = URLComponents()
    urlComponents.queryItems = parameters.compactMap { parameter in
      URLQueryItem(name: parameter.key, value: parameter.value.urlEncodedString)
    }
    return urlComponents.url?.query ?? ""
  }
}
