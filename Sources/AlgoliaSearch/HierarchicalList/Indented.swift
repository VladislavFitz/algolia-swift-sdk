import Foundation

public struct Indented<Value> {
  public let value: Value
  public let indentationLevel: Int

  public init(value: Value,
              indentationLevel: Int = 0) {
    self.value = value
    self.indentationLevel = indentationLevel
  }
}

public extension Indented {
  
  func isSelected(_ isSelected: Bool) -> Selectable<Self> {
    Selectable(self, isSelected: isSelected)
  }
  
}

extension Indented: Equatable where Value: Equatable {}
extension Indented: Hashable where Value: Hashable {}
