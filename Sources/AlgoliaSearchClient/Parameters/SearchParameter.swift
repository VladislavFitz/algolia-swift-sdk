import AlgoliaFoundation
import Foundation

public protocol SearchParameter: Encodable, URLEncodable, Hashable {
  var key: String { get }
}

@resultBuilder
enum SearchParametersBuilder {
  static func buildBlock() -> [any SearchParameter] { [] }
}

extension SearchParametersBuilder {
  static func buildBlock(_ parameters: any SearchParameter...) -> [any SearchParameter] { parameters }
}
