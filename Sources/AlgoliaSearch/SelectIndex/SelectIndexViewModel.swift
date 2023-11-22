import AlgoliaFoundation
import Foundation

public final class SelectIndexViewModel: ObservableObject {
  @Published public var selectedIndexName: IndexName

  public let indexNames: [IndexName]

  public init(indexNames: [IndexName],
              selectedIndexName: IndexName) {
    assert(indexNames.contains(selectedIndexName), "indices list might contain selected index name")
    self.indexNames = indexNames
    self.selectedIndexName = selectedIndexName
  }

  public func isSelected(_ indexName: IndexName) -> Bool {
    selectedIndexName == indexName
  }
}
