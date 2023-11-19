import Foundation
import Combine
import AlgoliaFoundation

public final class HierarchicalViewModel: ObservableObject {
  
  @Published public var values: [HierarchicalNode<Facet>]
  
  public var didToggle: PassthroughSubject<Facet, Never>
    
  public init(values: [HierarchicalNode<Facet>] = []) {
    self.values = values
    self.didToggle = .init()
  }
    
  public func toggle(_ facet: Facet) {
    didToggle.send(facet)
  }
        
}
