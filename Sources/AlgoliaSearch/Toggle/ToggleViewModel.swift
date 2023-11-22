import Foundation
import Combine

final public class ToggleViewModel: ObservableObject {

  @Published public var isOn: Bool

  public init(isOn: Bool = false) {
    self.isOn = isOn
  }

}
