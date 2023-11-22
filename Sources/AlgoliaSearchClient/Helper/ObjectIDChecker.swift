import AlgoliaFoundation
import Foundation

public enum ObjectIDChecker {
  private struct ObjectIDContainer: Decodable {
    let objectID: String
  }

  static func checkObjectID<T: Encodable>(_ object: T) throws {
    let data = try JSONEncoder().encode(object)
    do {
      _ = try JSONDecoder().decode(ObjectIDContainer.self, from: data)
    } catch _ {
      throw Error.missingObjectIDProperty
    }
  }

  static func assertObjectID<T: Encodable>(_ object: T) {
    do {
      try checkObjectID(object)
    } catch {
      assertionFailure("\(error.localizedDescription)")
    }
  }

  public enum Error: Swift.Error {
    case missingObjectIDProperty

    var localizedDescription: String {
      switch self {
      case .missingObjectIDProperty:
        return "Object must contain encoded `objectID` field if autoGenerationObjectID is set to false"
      }
    }
  }
}
