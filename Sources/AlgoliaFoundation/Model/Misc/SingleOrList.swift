import Foundation

public typealias SingleOrList<T> = Either<T, [T]>

public extension SingleOrList {
  static func single(_ element: A) -> Self { .first(element) }
  static func list(_ elements: B) -> Self { .second(elements) }
}
