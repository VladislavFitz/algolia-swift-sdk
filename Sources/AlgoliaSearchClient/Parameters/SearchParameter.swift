import AlgoliaFoundation
import Foundation

public protocol SearchParameter: Encodable, URLEncodable {
  var key: String { get }
}

@resultBuilder
enum SearchParametersBuilder {
  static func buildBlock() -> [SearchParameter] { [] }
}

extension SearchParametersBuilder {
  static func buildBlock(_ parameters: SearchParameter...) -> [SearchParameter] { parameters }
}
