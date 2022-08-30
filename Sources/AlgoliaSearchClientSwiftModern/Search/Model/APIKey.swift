//
//  APIKey.swift
//
//
//  Created by Vladislav Fitc on 29.08.2022.
//

import Foundation

public struct APIKey: StringWrapper {
  public let rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}
