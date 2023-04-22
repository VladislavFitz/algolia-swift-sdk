import AlgoliaFoundation
import Foundation

public protocol DeleteQueryParameter: Encodable, URLEncodable {
  var key: String { get }
}

@resultBuilder
enum DeleteQueryParametersBuilder {
  static func buildBlock() -> [any SearchParameter] { [] }
}

extension DeleteQueryParametersBuilder {
  static func buildBlock(_ parameters: DeleteQueryParameter...) -> [DeleteQueryParameter] { parameters }
}
