import Foundation

public enum SelectionMode {
  case single
  case multiple(isDisjunctive: Bool)

  public static var multiple: Self = .multiple(isDisjunctive: true)
}
