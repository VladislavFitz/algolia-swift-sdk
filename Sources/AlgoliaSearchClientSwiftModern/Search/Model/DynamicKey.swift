//
//  DynamicKey.swift
//
//
//  Created by Vladislav Fitc on 02.09.2022.
//

import Foundation

struct DynamicKey: CodingKey {
  var intValue: Int?
  var stringValue: String

  init(intValue: Int) {
    self.intValue = intValue
    stringValue = String(intValue)
  }

  init(stringValue: String) {
    self.stringValue = stringValue
  }
}
