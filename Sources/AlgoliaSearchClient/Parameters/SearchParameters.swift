import AlgoliaFoundation
import Foundation

public struct SearchParameters {
  
  internal var parameters: [String: any SearchParameter]

  public init(_ parameters: [any SearchParameter]) {
    self.parameters = .init(uniqueKeysWithValues: parameters.map { ($0.key, $0) })
  }

  public init(_ parameters: any SearchParameter...) {
    self.init(parameters)
  }

  public init(@SearchParametersBuilder _ content: () -> [any SearchParameter]) {
    self = Self(content())
  }
}

extension SearchParameters: Equatable {
  
  public static func == (lhs: SearchParameters, rhs: SearchParameters) -> Bool {
    for (key, lValue) in lhs.parameters {
      if let rValue = rhs.parameters[key] {
        if AnyHashable(lValue) != AnyHashable(rValue) {
          return false
        }
      } else {
        return false
      }
    }
    return true
  }
  
}


extension SearchParameters: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CustomCodingKey.self)
    for (key, parameter) in parameters {
      try container.encode(EncodableBox(parameter), forKey: CustomCodingKey(stringValue: key))
    }
  }
}

extension SearchParameters: URLEncodable {
  public var urlEncodedString: String {
    var urlComponents = URLComponents()
    urlComponents.queryItems = parameters.compactMap { parameter in
      URLQueryItem(name: parameter.key, value: parameter.value.urlEncodedString)
    }
    return urlComponents.url?.query ?? ""
  }
}
