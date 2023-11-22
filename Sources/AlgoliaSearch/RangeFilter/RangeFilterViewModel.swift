import Foundation

final public class RangeFilterViewModel: ObservableObject {

  @Published public var bounds: ClosedRange<Int>
  @Published public var value: ClosedRange<Int>

  public init(bounds: ClosedRange<Int>,
              value: ClosedRange<Int>) {
    self.bounds = bounds
    self.value = value
  }

}
