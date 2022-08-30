//
//  IndexName.swift
//
//
//  Created by Vladislav Fitc on 14.08.2022.
//

import Foundation

public struct IndexName: StringWrapper {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}
