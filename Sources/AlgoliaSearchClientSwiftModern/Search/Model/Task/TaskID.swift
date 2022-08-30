//
//  TaskID.swift
//
//
//  Created by Vladislav Fitc on 27.08.2022.
//

import Foundation

public struct TaskID: StringWrapper {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}
