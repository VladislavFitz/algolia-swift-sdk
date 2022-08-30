//
//  SearchParameter.swift
//
//
//  Created by Vladislav Fitc on 08.08.2022.
//

import Foundation

public protocol SearchParameter: Encodable, URLEncodable {
  static var key: String { get }
}

@resultBuilder
enum SearchParametersBuilder {
  static func buildBlock() -> [SearchParameter] { [] }
}

extension SearchParametersBuilder {
  static func buildBlock(_ parameters: SearchParameter...) -> [SearchParameter] { parameters }
}
