import Combine
import Foundation

public final class ToggleViewModel: ObservableObject {
  @Published public var isOn: Bool

  public init(isOn: Bool = false) {
    self.isOn = isOn
  }
}
