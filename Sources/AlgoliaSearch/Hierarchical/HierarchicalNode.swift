import Foundation

public struct HierarchicalNode<Value> {
  
  public let value: Value
  public let isSelected: Bool
  public let indentationLevel: Int
  
  public init(value: Value,
              isSelected: Bool = false,
              indentationLevel: Int = 0) {
    self.value = value
    self.isSelected = isSelected
    self.indentationLevel = indentationLevel
  }
  
}

extension HierarchicalNode: Equatable where Value: Equatable {}
extension HierarchicalNode: Hashable where Value: Hashable {}

