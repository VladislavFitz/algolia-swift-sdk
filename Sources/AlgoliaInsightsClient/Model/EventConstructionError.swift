import Foundation

extension Event {
  enum Constraint {
    public static let maxObjectIDsCount = 20
    public static let maxFiltersCount = 10
  }
}

public extension Event {
  enum ConstructionError: Error {
    case emptyEventName
    case objectIDsCountOverflow
    case filtersCountOverflow
    case objectsAndPositionsCountMismatch(objectIDsCount: Int, positionsCount: Int)
  }
}

extension Event.ConstructionError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .emptyEventName:
      return "Event name cannot be empty"

    case .filtersCountOverflow:
      return "Max filters count in event is \(Event.Constraint.maxFiltersCount)"

    case .objectIDsCountOverflow:
      return "Max objects IDs count in event is \(Event.Constraint.maxObjectIDsCount)"

    case let .objectsAndPositionsCountMismatch(objectIDsCount: objectIDsCount, positionsCount: positionsCount):
      return "Object IDs count \(objectIDsCount) is not equal to positions count \(positionsCount)"
    }
  }
}
