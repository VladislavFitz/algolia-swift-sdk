import Foundation
import AlgoliaFoundation

public struct FacetSortDescriptor {
  
  public static func compare(_ a: Selectable<Facet>, _ b: Selectable<Facet>) -> Bool {
    guard a.isSelected == b.isSelected else {
      return a.isSelected && !b.isSelected
    }
    
    guard a.value.count == b.value.count else {
      return a.value.count > b.value.count
    }
    
    guard a.value.value == b.value.value else {
      return a.value.value < b.value.value
    }
    
    return false
  }
  
}
