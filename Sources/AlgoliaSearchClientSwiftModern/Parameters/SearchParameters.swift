//
//  SearchParameters.swift
//
//
//  Created by Vladislav Fitc on 08.08.2022.
//

import Foundation

public struct SearchParameters {
  internal var parameters: [String: SearchParameter]

  public init(_ parameters: [SearchParameter]) {
    self.parameters = .init(uniqueKeysWithValues: parameters.map { ($0.key, $0) })
  }

  public init(_ parameters: SearchParameter...) {
    self.init(parameters)
  }

  public init(@SearchParametersBuilder _ content: () -> [SearchParameter]) {
    self = SearchParameters(content())
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
