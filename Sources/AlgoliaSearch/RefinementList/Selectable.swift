import Foundation

public struct Selectable<T> {
  
  public let value: T
  public var isSelected: Bool
  
  public init(_ value: T,
              isSelected: Bool = false) {
    self.value = value
    self.isSelected = isSelected
  }
  
}

extension Selectable: Equatable where T: Equatable {}
extension Selectable: Hashable where T: Hashable {}
